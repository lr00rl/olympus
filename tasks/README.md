# tasks/ · The Moirai (task files)

One file per task: `TASK-<NNNN>-<slug>.md`. Numbers are global and first-come (collision: later pusher +1s and renames).
The owner owns the body; others comment by letter. `plan/` is the backlog source; TASK files are runtime truth.

## States (spin → measure → cut)

```
draft → ready → in_progress → done → merged
                    ↓ ↑
                  blocked          any state → cancelled (with reason)
```

## Splitting rule

Split any task that (a) waits on someone else's unmerged shared-resource claim, or (b) exceeds roughly a day of work. Field data: small slices merge in hours; monoliths collect review rounds and outlive every sibling.

## Work units: the machine-readable development frontier

New tasks use `task_schema: work-units/v1` and define one or more `work_units` in frontmatter.
The task remains the integration/DoD boundary; a work unit is the smallest independently startable
development slice. `bin/olympus next <handle>` lists runnable units for one seat, while
`bin/olympus frontier` computes a safe parallel launch set for the whole mountain. The frontier
greedily reserves one unit per idle seat plus repo-writer and exclusive-resource capacity as it
walks task IDs; later conflicts remain visible as waiting instead of being offered concurrently.

Dependency fields have intentionally different meanings:

- `start_after`: hard development dependency. The unit stays out of the runnable frontier until
  every referenced task or unit is `done`/`merged`.
- `merge_after`: integration-only dependency. It is displayed with the runnable unit but does not
  block coding, tests, review preparation, or other reversible work.
- `decision_gate`: an unresolved ruling that blocks starting this unit; clear it when resolved.
- `needs_ack`: a review/contract gate before merge, not a reason to delay development.
- `human_only: yes`: never offered as runnable agent work.
- `resources`: exclusive claims the starter must acquire under `contract/shared-resources.md`.

References are `TASK-0042` or `TASK-0042#unit-id`. Keep array fields on one line (`[]` or
`[TASK-0042#api-shape, TASK-0043]`) so the optional dependency-free CLI can validate them with
POSIX awk. Richer runtimes may parse the same YAML normally.

Tasks without `work_units` remain valid: the CLI maps each to a synthetic `#default` unit and
preserves the old task-level `depends_on` behavior. Once `work_units` exist, their `start_after`
fields are the scheduling truth; top-level `depends_on` is only a compatibility summary.

Task status summarizes the units: `ready` when a frontier is published, `in_progress` when any
unit has started, `done` only after every required unit is done, and `merged` only after the task's
integration/DoD boundary closes. Work units inherit the task owner: `work-units/v1` deliberately
keeps one writer per task file. Work that belongs to another seat must be split into another task,
so parallelism does not reintroduce shared-file conflicts. A `ready` task must also have a real
top-level owner: `<handle>`/unassigned work stays waiting until the Orchestrator assigns exactly one
seat, so it cannot satisfy several seats' backlog checks at once.

## Index

**The files are the truth** — list them any time with `grep -H "^status:" TASK-*.md | sort`. The hand-maintained table below is optional and rots fast; trust the grep, not the table.

| TASK | Title | Owner | State | Source |
|---|---|---|---|---|
| 0001 | (example) see TASK-0001.example.md — delete at setup | athena.example | ready | plan/… |
