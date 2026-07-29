---
task: TASK-1010
task_schema: work-units/v1
title: First provisional frontier allocation
owner: poseidon
status: ready
repos: [warm]
depends_on: []
blocked_by_ruling:
needs_ack: no
work_units:
  - id: launch
    title: Reserve the last warm writer slot and release slot
    status: ready
    start_after: []
    merge_after: []
    repos: [warm]
    resources: [release-slot]
    needs_ack: no
    human_only: no
    decision_gate: ""
---

## First slice

Take the available parallel slot.
