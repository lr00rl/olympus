---
task: TASK-1011
task_schema: work-units/v1
title: Conflicting provisional frontier allocation
owner: artemis
status: ready
repos: [warm]
depends_on: []
blocked_by_ruling:
needs_ack: no
work_units:
  - id: launch
    title: Wait behind the selected frontier allocation
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

Take the slot after it is released.
