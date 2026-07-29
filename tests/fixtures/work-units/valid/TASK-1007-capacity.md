---
task: TASK-1007
task_schema: work-units/v1
title: Repository and resource capacity
owner: zeus
status: ready
repos: [hot, cold]
depends_on: []
blocked_by_ruling:
needs_ack: no
work_units:
  - id: fourth-writer
    title: Wait for repository capacity
    status: ready
    start_after: []
    merge_after: []
    repos: [hot]
    resources: []
    needs_ack: no
    human_only: no
    decision_gate: ""
  - id: resource-waiter
    title: Wait for the exclusive schema slot
    status: ready
    start_after: []
    merge_after: []
    repos: [cold]
    resources: [schema-slot]
    needs_ack: no
    human_only: no
    decision_gate: ""
---

## First slice

Wait until one active writer leaves the hot repository.
