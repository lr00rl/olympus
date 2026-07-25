# Shared-resource claim ledger (claim first, code second)

Everything that collides when two people add one simultaneously queues here: DB migration numbers, global enum values, ports, event names, route prefixes, error-code ranges… Adapt sections at setup.
Rules: **claim in this table before writing code**; collisions → later merger renumbers and updates the ledger; states `open → in_progress (TASK id) → merged (commit)`.
Dependencies: a claim that builds on earlier **unmerged** numbers is not developed on top of them in parallel — branch the dependent slice after its predecessors merge, or take an earlier slot (rules/01 §2, rules/02 §3.5).

## DB migration numbers

| No. | Content | Owner | State | TASK |
|---|---|---|---|---|
| (example) v1 | initial schema | zeus.example | merged | — |
| | | | | |

## Global enums / constant ranges

| Name | Value/range | Owner | State | TASK |
|---|---|---|---|---|
| | | | | |

## Ports / route prefixes / event names (add sections as needed)

| Resource | Value | Owner | State | TASK |
|---|---|---|---|---|
| | | | | |
