---
task: TASK-XXXX
title: <one line>
owner: <handle>
status: draft
plan_ref: <plan/ backlog item; or "new">
repos: []                    # code repos touched
branches: []                 # filled at start
depends_on: []               # TASK ids / others' branches; empty if none
needs_ack: no                # touches contract/shared files/resources/auth → yes
created: YYYY-MM-DD          # UTC date (rules/02 §0)
---

## Goal

<what, why, the observable result>

## Scope / non-goals

- In:
- Out:

## Notes

<key decisions; contract/plan references; modules & files>

## DoD

- [ ] merged into {{INTEGRATION_BRANCH}}
- [ ] tests green (entries & expected numbers)
- [ ] docs updated (list)
- [ ] finish letter sent

## Log (append-only, newest first)

- YYYY-MM-DD: <progress / decision / blocker / break-point>
