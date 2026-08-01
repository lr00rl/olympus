#!/usr/bin/env bash
# tests/test_enforcement.sh — enforcement-layer checks for bin/olympus:
#   G1 fallback-expiry doctor red · G3 heartbeat stale-lock takeover ·
#   G9 second-precision noclobber letters · G11 repo transaction lock takeover
# Each test runs in a throwaway git sandbox (bare origin + clone) — no network, no writes here.
set -eu

SRC="$(cd "$(dirname "$0")/.." && pwd)"
FAIL=0
say()  { printf '%s\n' "$*"; }
pass() { say "PASS: $1"; }
fail() { FAIL=1; say "FAIL: $1"; }

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

make_sandbox() {  # $1 = name; echoes clone path
  local base="$TMP/$1"
  git init -q --bare -b main "$base/origin.git"
  git clone -q "$base/origin.git" "$base/work" 2>/dev/null
  (
    cd "$base/work"
    git config user.email test@example.invalid
    git config user.name  test
    mkdir -p messages/inbox/alice messages/inbox/bob status tasks pantheon
    printf 'handle: alice\n' > pantheon/alice.md
    cp -R "$SRC/bin" .
    git add -A
    git commit -qm init
    git push -q -u origin main
  )
  printf '%s' "$base/work"
}

# fake clock: freezes the letter-filename format only; everything else passes through
make_fake_date() {  # $1 = dir
  cat > "$1/date" <<'EOF'
#!/bin/sh
for a in "$@"; do
  case "$a" in +%Y%m%d-%H%M%S) echo "20260801-000000"; exit 0;; esac
done
exec /bin/date "$@"
EOF
  chmod +x "$1/date"
}

# ---------- 1. doctor: fallback expiry (G1) ----------
W="$(make_sandbox doctor)"
(
  cd "$W"
  cat > messages/inbox/alice/20000101-000000Z-bob-expired.md <<'EOF'
---
from: bob
to: alice
date: 2000-01-01T00:00Z
re: general
needs: decision
status: open
---
choices: []
recommendation: a
due: 2000-01-01T00:00Z
fallback: a
EOF
  cat > messages/inbox/alice/20000101-000001Z-bob-applied.md <<'EOF'
---
from: bob
to: alice
date: 2000-01-01T00:00Z
re: general
needs: decision
status: open
---
due: 2000-01-01T00:00Z
fallback: a

> [fallback-applied] a 2000-01-02T00:30Z
EOF
  cat > messages/inbox/alice/20000101-000002Z-bob-mustwait.md <<'EOF'
---
from: bob
to: alice
date: 2000-01-01T00:00Z
re: general
needs: decision
status: open
---
due: 2000-01-01T00:00Z
fallback: none
EOF
  out="$(bin/olympus doctor 2>&1 || true)"
  echo "$out" | grep -q 'expired.md: due passed.*without \[fallback-applied\]' \
    && pass "expired open decision without marker is red" \
    || fail "missing red for expired decision: $out"
  echo "$out" | grep -q 'applied.md.*without \[fallback-applied\]' \
    && fail "letter with marker wrongly flagged" \
    || pass "applied marker suppresses the red"
  echo "$out" | grep -q 'mustwait.md: decision overdue and fallback: none' \
    && pass "fallback:none overdue is yellow (wake the decider)" \
    || fail "missing yellow for fallback:none: $out"
)

# ---------- 2. letter: seconds precision + noclobber (G9) ----------
W="$(make_sandbox letter)"
(
  cd "$W"
  FAKE="$TMP/fakebin"; mkdir -p "$FAKE"; make_fake_date "$FAKE"
  out1="$(PATH="$FAKE:$PATH" OLYMPUS_HANDLE=alice bin/olympus letter bob ping --needs none)"
  echo "$out1" | grep -q 'wrote messages/inbox/bob/20260801-000000Z-alice-ping.md' \
    && pass "letter filename carries seconds precision" \
    || fail "unexpected letter path: $out1"
  if PATH="$FAKE:$PATH" OLYMPUS_HANDLE=alice bin/olympus letter bob ping --needs none >/dev/null 2>"$TMP/err2"; then
    fail "same-second same-slug letter overwrote silently"
  else
    grep -q 'letter already exists' "$TMP/err2" \
      && pass "noclobber refuses same-second collision" \
      || fail "wrong error on collision: $(cat "$TMP/err2")"
  fi
)

# ---------- 3. heartbeat: live lock skips, stale lock is taken over (G3) ----------
W="$(make_sandbox heartbeat)"
(
  cd "$W"
  lockd="${TMPDIR:-/tmp}/olympus-heartbeat-alice.lock.d"
  rm -rf "$lockd"
  # live holder (this shell's pid, fresh timestamp) ⇒ skip
  mkdir "$lockd"; echo "$$" > "$lockd/pid"; date -u +%s > "$lockd/started"
  out="$(bin/olympus heartbeat alice)"
  echo "$out" | grep -q 'still holds the lock — skipping' \
    && pass "live heartbeat lock is respected" \
    || fail "live lock not respected: $out"
  # stale holder (dead pid, epoch 0) ⇒ takeover, quiet inbox exits clean, lock removed
  rm -rf "$lockd"; mkdir "$lockd"; echo "999999" > "$lockd/pid"; echo 0 > "$lockd/started"
  out="$(bin/olympus heartbeat alice)"
  echo "$out" | grep -q 'taking over stale lock' \
    && pass "stale heartbeat lock is taken over" \
    || fail "stale lock not taken over: $out"
  echo "$out" | grep -q 'inbox quiet for alice' \
    && pass "quiet inbox is a zero-token no-op after takeover" \
    || fail "expected quiet-inbox no-op: $out"
  [ ! -d "$lockd" ] \
    && pass "heartbeat lock released on exit" \
    || { fail "heartbeat lock leaked"; rm -rf "$lockd"; }
)

# ---------- 4. repo transaction lock: stale takeover (G11) ----------
W="$(make_sandbox repolock)"
(
  cd "$W"
  mkdir -p .git/olympus-repo.lock.d; echo 0 > .git/olympus-repo.lock.d/started
  out="$(bin/olympus heartbeat alice 2>&1)"
  echo "$out" | grep -q 'taking over stale repo lock' \
    && pass "stale repo lock is taken over" \
    || fail "stale repo lock not taken over: $out"
  [ ! -d .git/olympus-repo.lock.d ] \
    && pass "repo lock released after heartbeat" \
    || fail "repo lock leaked"
)

say "----"
if [ "$FAIL" -eq 0 ]; then
  say "PASS: enforcement suite (fallback expiry, noclobber letters, heartbeat/repo lock takeover)"
else
  say "FAIL: enforcement suite"; exit 1
fi
