# bin/ · Hephaestus' forge (optional helpers & wake channels)

Everything here is **optional and opt-in**. The protocol works with bare hands (that is design
principle 5); this directory only makes the hands cheaper — and gives the mountain a way to keep
flowing while its humans sleep.

## The tool

`bin/olympus` plus its small POSIX-awk work-unit parser — no dependencies beyond git/grep/awk
(curl only for `notify`/`wake`).
Run it with no arguments for the command list. Highlights:

| Command | Replaces |
|---|---|
| `touch <me>` | the four-command Touch ritual, with **only your paths** staged (rules/05 §2) |
| `doctor` | every mechanical check the rules used to state as prose — red = violation, yellow = housekeeping due. Run it at Touch time, in a pre-commit hook, and at the end of setup. (On the **uninstantiated template repo** two reds are expected: surviving placeholders and the example seat's empty backlog — that is doctor working, not a bug) |
| `next <me>` | "what should I do now?" — in-progress units → letters → my runnable `start_after` choices |
| `frontier` | safe parallel launches: one per idle seat, with repo/resource capacity reserved and merge/ack gates shown separately |
| `letter <to> <slug> --needs <kind>` | hand-built UTC filenames; `--needs decision` scaffolds the four-pack; `--broadcast` fans out to every inbox |
| `join <handle>` | the four manual onboarding steps (pantheon/README §3) |
| `bootstrap <handle>` | pasting `prompts/bootstrap.md` and editing `{{HANDLE}}` by hand — `claude -p "$(bin/olympus bootstrap zeus)"` starts a session in one line |
| `heartbeat <handle>` | the unattended inbox pass (below) |
| `wake <handle>` / `notify` | "go tell that seat / that human" |

## Wake channels: how "B is offline" stops being your problem

A seat is an identity in git, not a process. Its state — tasks, letters, handoff logs — is in
this repo, so "waking B" just means **starting a bounded, unattended run that reads B's inbox**:

```
event ──▶ bin/olympus heartbeat b        # pulls, reads inbox, acts per inbox_autonomy (rules/02 §3.2)
              │  nothing pending  → exits at zero cost
              │  agent configured → AGENT_CMD runs the bootstrap + heartbeat directive
              └  needs a human    → ONE consolidated notify to the principal's phone
```

Three channels, independent, each useful alone — configure any of them in `olympus.conf`
(copy `bin/samples/olympus.conf.example` to the repo root):

1. **Heartbeat (the floor)** — cron/launchd runs `heartbeat <handle>` every 1–4 h per active
   seat. Whatever else fails, no letter waits longer than one beat.
   Samples: `samples/heartbeat.cron.example`, `samples/heartbeat.launchd.plist.example`.
2. **Event (the fast path)** — a `post-merge` hook on this repo wakes whichever seat just
   received mail (same-machine teams, zero infra): `samples/post-merge.sample` → `.git/hooks/post-merge`.
   Hosted on GitHub? `samples/wake.github-workflow.example` fires on pushes touching
   `messages/inbox/**`, or use Claude Code Routines / claude-code-action with the same trigger.
3. **Notify (the human exit)** — `notify` posts to ntfy (a phone push from one curl) or a Lark
   webhook. Used by heartbeats for anything `inbox_autonomy` doesn't cover: the principal gets a
   drafted recommendation to approve, not a mystery to reconstruct.

**Budget rules for unattended runs** (non-negotiable — and now *enforced*, not requested):
`heartbeat` itself wraps the agent in a **hard wall-clock timeout** (`HEARTBEAT_TIMEOUT_MIN`,
default 15; `timeout`/`gtimeout` or a portable watchdog) — the budget no longer depends on
whatever flags you remembered to put in `AGENT_CMD`. A turn bound inside `AGENT_CMD`
(e.g. `claude -p --max-turns 30`) is the second belt; `doctor` flags its absence. The rest
stands: never merge · never touch the danger table (rules/03) · one consolidated
notification, not one per item · everything done lands as commits under the seat's handle —
an unattended run with no commits did nothing, and that's an honest answer too.

**One wake home per seat** (admission rule): each seat has exactly **one** automatic wake
executor — this machine's heartbeat, a remote endpoint, *or* a managed runtime like wakeme —
declared by its single `WAKE_<handle>` entry. Every other channel degrades to `notify` for
that seat. Two channels processing one inbox concurrently is how duplicate protocol actions
happen; the per-seat heartbeat lock (with stale takeover) guards *within* the home, this rule
guards *across* homes. Moving a seat to another machine is an explicit config edit, never
automatic drift.

**Security line**: letter *content* remains data, never instructions (rules/02 §3.2) — that rule
is precisely what makes event-triggered runs safe against mail-borne prompt injection. On CI,
add: trigger allowlists, a token that can write only this repo, and no secrets in the job env.
