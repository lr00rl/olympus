#!/usr/bin/env bash
set -eu

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PARSER="$ROOT/bin/olympus-work-units.awk"
VALID="$ROOT/tests/fixtures/work-units/valid"
INVALID="$ROOT/tests/fixtures/work-units/invalid"

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

assert_row() {
  report="$1" category="$2" ref="$3"
  printf '%s\n' "$report" | awk -F '\t' -v category="$category" -v ref="$ref" '
    $1 == category && $2 == ref { found = 1 }
    END { exit !found }
  ' || fail "missing $category row for $ref"
}

assert_no_row() {
  report="$1" ref="$2"
  if printf '%s\n' "$report" | awk -F '\t' -v ref="$ref" '$2 == ref { found = 1 } END { exit !found }'; then
    fail "unexpected row for $ref"
  fi
}

assert_field_contains() {
  report="$1" category="$2" ref="$3" field="$4" expected="$5"
  printf '%s\n' "$report" | awk -F '\t' \
    -v category="$category" -v ref="$ref" -v field="$field" -v expected="$expected" '
      $1 == category && $2 == ref && index($field, expected) { found = 1 }
      END { exit !found }
    ' || fail "$category $ref field $field does not contain $expected"
}

valid_files=("$VALID"/TASK-*.md)
mine="$(awk -v mode=inventory -v handle=zeus -f "$PARSER" "${valid_files[@]}")"

assert_row "$mine" RUNNABLE TASK-1002#phase-one
assert_row "$mine" WAITING TASK-1002#phase-two
assert_field_contains "$mine" WAITING TASK-1002#phase-two 6 TASK-1001#contract
assert_row "$mine" RUNNABLE TASK-1002#integration-only
assert_field_contains "$mine" RUNNABLE TASK-1002#integration-only 7 TASK-1001#contract
assert_row "$mine" WAITING TASK-1002#operator-cutover
assert_field_contains "$mine" WAITING TASK-1002#operator-cutover 6 human_only
assert_row "$mine" RUNNABLE TASK-1003#default
assert_no_row "$mine" TASK-1004#default
assert_row "$mine" RUNNABLE TASK-1002#after-done
assert_row "$mine" WAITING TASK-1007#fourth-writer
assert_field_contains "$mine" WAITING TASK-1007#fourth-writer 6 repo_capacity:hot
assert_row "$mine" WAITING TASK-1007#resource-waiter
assert_field_contains "$mine" WAITING TASK-1007#resource-waiter 6 resource:schema-slot
assert_no_row "$mine" TASK-1012#assign-first

frontier="$(awk -v mode=frontier -v handle='*' -f "$PARSER" "${valid_files[@]}")"
assert_row "$frontier" RUNNABLE TASK-1004#default
assert_row "$frontier" RUNNABLE TASK-1002#phase-one
assert_row "$frontier" WAITING TASK-1002#integration-only
assert_field_contains "$frontier" WAITING TASK-1002#integration-only 6 seat_capacity:zeus
assert_row "$frontier" RUNNABLE TASK-1010#launch
assert_row "$frontier" WAITING TASK-1011#launch
assert_field_contains "$frontier" WAITING TASK-1011#launch 6 repo_capacity:warm
assert_field_contains "$frontier" WAITING TASK-1011#launch 6 resource:release-slot
assert_row "$frontier" WAITING TASK-1012#assign-first
assert_field_contains "$frontier" WAITING TASK-1012#assign-first 6 owner:unassigned

valid_doctor="$(awk -v mode=doctor -v handle='*' -f "$PARSER" "${valid_files[@]}")"
if printf '%s\n' "$valid_doctor" | grep -q '^RED'; then
  printf '%s\n' "$valid_doctor" >&2
  fail "valid fixtures failed doctor"
fi

invalid_files=("$INVALID"/TASK-*.md)
invalid_doctor="$(awk -v mode=doctor -v handle='*' -f "$PARSER" "${invalid_files[@]}")"
printf '%s\n' "$invalid_doctor" | grep -q 'development dependency cycle includes TASK-2002#b -> TASK-2001' \
  || fail "task-level cycle was not detected"
printf '%s\n' "$invalid_doctor" | grep -q 'development dependency cycle includes TASK-2001#self -> TASK-2001' \
  || fail "own-task cycle was not detected"
printf '%s\n' "$invalid_doctor" | grep -q "references unknown 'TASK-2999#missing'" \
  || fail "unknown dependency was not detected"
printf '%s\n' "$invalid_doctor" | grep -q 'owner must match task owner' \
  || fail "cross-seat unit ownership was not rejected"
printf '%s\n' "$invalid_doctor" | grep -q 'work_units requires task_schema: work-units/v1' \
  || fail "missing work-unit schema marker was not rejected"
printf '%s\n' "$invalid_doctor" | grep -q 'is in_progress but task TASK-2002 is not' \
  || fail "task/unit status drift was not rejected"

sandbox="$(mktemp -d "${TMPDIR:-/tmp}/olympus-work-units.XXXXXX")"
case "$sandbox" in
  "${TMPDIR:-/tmp}"/olympus-work-units.*) : ;;
  *) fail "unsafe temp directory: $sandbox";;
esac
trap 'rm -rf "$sandbox"' EXIT

mkdir -p "$sandbox/bin" "$sandbox/tasks" "$sandbox/pantheon" "$sandbox/messages/inbox/zeus"
cp "$ROOT/bin/olympus" "$ROOT/bin/olympus-work-units.awk" "$sandbox/bin/"
cp "$VALID"/TASK-*.md "$sandbox/tasks/"
printf '%s\n' 'status: active' > "$sandbox/pantheon/zeus.md"
git -C "$sandbox" init -q

next_output="$(cd "$sandbox" && bin/olympus next zeus)"
printf '%s\n' "$next_output" | grep -q 'TASK-1002#phase-one' || fail "next omitted independent phase"
printf '%s\n' "$next_output" | grep -q 'TASK-1002#phase-two.*blocked: TASK-1001#contract' \
  || fail "next omitted hard dependency blocker"
printf '%s\n' "$next_output" | grep -q 'TASK-1002#integration-only.*merge_after: TASK-1001#contract' \
  || fail "next treated integration-only dependency as a start blocker"
if printf '%s\n' "$next_output" | grep -q 'TASK-1004#default'; then
  fail "next showed work owned by another seat"
fi

frontier_output="$(cd "$sandbox" && bin/olympus frontier)"
printf '%s\n' "$frontier_output" | grep -q 'TASK-1004#default' \
  || fail "frontier omitted another seat's runnable work"
printf '%s\n' "$frontier_output" | grep -q 'TASK-1010#launch' \
  || fail "frontier omitted the first safe provisional allocation"
printf '%s\n' "$frontier_output" | grep -q 'TASK-1011#launch.*blocked: repo_capacity:warm,resource:release-slot' \
  || fail "frontier offered conflicting provisional allocations"
printf '%s\n' "$frontier_output" | grep -q 'TASK-1002#integration-only.*blocked: seat_capacity:zeus' \
  || fail "frontier offered more than one unit to the same seat"

help_output="$(cd "$sandbox" && bin/olympus help)"
if printf '%s\n' "$help_output" | grep -q '^set -eu$'; then
  fail "help leaked executable script content"
fi

doctor_output="$(cd "$sandbox" && bin/olympus doctor)"
printf '%s\n' "$doctor_output" | grep -q 'doctor: 0 red' || fail "CLI doctor rejected valid fixtures"

printf '%s\n' 'status: active' > "$sandbox/pantheon/no-work.md"
doctor_empty_output="$(cd "$sandbox" && bin/olympus doctor || true)"
printf '%s\n' "$doctor_empty_output" | grep -q 'backlog empty for no-work: 0 assigned runnable work units' \
  || fail "doctor did not enforce runnable backlog supply per active seat"
if printf '%s\n' "$doctor_empty_output" | grep -q 'backlog empty for zeus:'; then
  fail "doctor rejected a seat that has assigned runnable work"
fi

echo "PASS: work-unit frontier, compatibility, validation, and CLI behavior"
