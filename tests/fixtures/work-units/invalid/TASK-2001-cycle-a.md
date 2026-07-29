---
task: TASK-2001
task_schema: work-units/v1
title: Cycle A
owner: zeus
status: ready
repos: [api]
depends_on: []
blocked_by_ruling:
needs_ack: no
work_units:
  - id: a
    title: A
    owner: athena
    status: ready
    start_after: [TASK-2002]
    merge_after: []
    repos: [api]
    resources: []
    needs_ack: no
    human_only: no
    decision_gate: ""
  - id: self
    title: Self cycle
    status: ready
    start_after: [TASK-2001]
    merge_after: []
    repos: [api]
    resources: []
    needs_ack: no
    human_only: no
    decision_gate: ""
---
