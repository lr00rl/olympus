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

## Index

**The files are the truth** — list them any time with `grep -H "^status:" TASK-*.md | sort`. The hand-maintained table below is optional and rots fast; trust the grep, not the table.

| TASK | Title | Owner | State | Source |
|---|---|---|---|---|
| 0001 | (example) see TASK-0001.example.md — delete at setup | athena.example | ready | plan/… |
