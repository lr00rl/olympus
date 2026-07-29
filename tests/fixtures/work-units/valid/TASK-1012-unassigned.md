---
task: TASK-1012
task_schema: work-units/v1
title: Work awaiting an explicit owner
owner: <handle>
status: ready
repos: [cold]
depends_on: []
blocked_by_ruling:
needs_ack: no
work_units:
  - id: assign-first
    title: Assign this task before offering it
    status: ready
    start_after: []
    merge_after: []
    repos: [cold]
    resources: []
    needs_ack: no
    human_only: no
    decision_gate: ""
---

## First slice

Assign the task to exactly one seat.
