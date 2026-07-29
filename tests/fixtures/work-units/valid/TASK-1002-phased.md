---
task: TASK-1002
task_schema: work-units/v1
title: Phased consumer
owner: zeus
status: in_progress
repos: [api, ui]
depends_on: [TASK-1001]
blocked_by_ruling:
needs_ack: yes
work_units:
  - id: phase-one
    title: Build the independent spike
    status: ready
    start_after: []
    merge_after: []
    repos: [api]
    resources: []
    needs_ack: no
    human_only: no
    decision_gate: ""
  - id: phase-two
    title: Bind to the upstream contract
    status: ready
    start_after: [TASK-1001#contract]
    merge_after: []
    repos: [api]
    resources: []
    needs_ack: no
    human_only: no
    decision_gate: ""
  - id: integration-only
    title: Build against the proposed shape
    status: ready
    start_after: []
    merge_after: [TASK-1001#contract]
    repos: [ui]
    resources: []
    needs_ack: yes
    human_only: no
    decision_gate: ""
  - id: operator-cutover
    title: Perform the production cutover
    status: ready
    start_after: []
    merge_after: []
    repos: [api]
    resources: [production-cutover]
    needs_ack: yes
    human_only: yes
    decision_gate: ""
  - id: after-done
    title: Consume a finished unit
    status: ready
    start_after: [TASK-1001#done-slice]
    merge_after: []
    repos: [api]
    resources: []
    needs_ack: no
    human_only: no
    decision_gate: ""
---

## First slice

Build the independent spike.
