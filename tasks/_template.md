---
task: TASK-XXXX
task_schema: work-units/v1
title: <one line>
owner: <handle>             # replace before ready; unassigned work is not claimable
status: draft
plan_ref: <plan/ backlog item; or "new">
repos: []                    # code repos touched
branches: []                 # filled at start
last_touched_by: <handle>    # who worked it last (matters when seats hand over)
depends_on: []               # legacy task-level summary; work_units[*].start_after drives scheduling
blocked_by_ruling: <letter file, if this task waits on a decision rather than on code>
needs_ack: no                # touches contract/shared files/resources/auth → yes
loop_attempts: 0             # consecutive same-failure count; survives sessions; 3 ⇒ blocked (work-loop §2.6)
last_failure: ""             # the failure signature being retried (test name / verbatim error string)
created: YYYY-MM-DD          # UTC date (rules/02 §0)
work_units:
  - id: first-slice          # stable within the task; lowercase letters/numbers/._-
    title: <independent first deliverable>
    status: draft            # draft|ready|in_progress|done|merged|blocked|cancelled
    start_after: []          # hard development gates: TASK-0001 or TASK-0001#unit-id
    merge_after: []          # integration-only gates; do not block development
    repos: []                # subset of task repos; [] inherits the task-level repos
    resources: []            # exclusive shared-resource claim names
    needs_ack: no            # merge/review gate, not a development gate
    human_only: no           # yes keeps this unit out of the agent runnable frontier
    decision_gate: ""        # letter/ruling that blocks starting; clear when resolved
---

## Goal

<what, why, the observable result>

## First slice (fill before `ready` — rules/02 §6)

<mirror `work_units[0]`: the first deliverable that depends on **nothing**: no ruling, no other
 task, no resource someone else must create. This is what the owner starts today.
 If the honest answer is "nothing can start until X lands", the task is mis-sized — split it so
 the independent part becomes its own task, rather than parking a whole seat behind X.>

## Scope & boundaries

- In:
- Out:
- **Allowed paths** (globs — checked mechanically at finish):
  - <repo>/<path>/**
- **Forbidden** (paths or behaviors that must not change):
  - <path or "do not touch X behavior">

## Notes

<key decisions; contract/plan references; modules & files>

## DoD

- [ ] merged into {{INTEGRATION_BRANCH}}
- [ ] diff stays inside Allowed paths (mechanical check, finish-task §1)
- [ ] <criterion> — proven by `<named test selector>`   # one line per criterion; bind proof, don't just say "tests green"
- [ ] docs updated (list)
- [ ] finish letter sent

## Log (append-only, newest first)

- YYYY-MM-DD: <progress / decision / blocker / break-point>
- YYYY-MM-DD handoff → <handle>: where (branch + pushed commit) · done/not done · verified/not verified · next step · dead ends  (prompts/handoff.md)
