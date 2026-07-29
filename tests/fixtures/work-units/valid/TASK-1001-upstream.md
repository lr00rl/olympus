---
task: TASK-1001
task_schema: work-units/v1
title: Upstream contract
owner: athena
status: in_progress
repos: [hot]
depends_on: []
blocked_by_ruling:
needs_ack: no
work_units:
  - id: contract
    title: Publish the contract
    status: in_progress
    start_after: []
    merge_after: []
    repos: [hot]
    resources: [schema-slot]
    needs_ack: no
    human_only: no
    decision_gate: ""
  - id: done-slice
    title: Finished prerequisite
    status: done
    start_after: []
    merge_after: []
    repos: [hot]
    resources: []
    needs_ack: no
    human_only: no
    decision_gate: ""
---

## First slice

Publish the contract.
