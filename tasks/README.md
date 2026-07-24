# tasks/ · The Moirai (task files)

One file per task: `TASK-<NNNN>-<slug>.md`. Numbers are global and first-come (collision: later pusher +1s and renames).
The owner owns the body; others comment by letter. `plan/` is the backlog source; TASK files are runtime truth.

## States (spin → measure → cut)

```
draft → ready → in_progress → done → merged
                    ↓ ↑
                  blocked          any state → cancelled (with reason)
```

## Index (maintain by hand; the wizard seeds the first batch)

| TASK | Title | Owner | State | Source |
|---|---|---|---|---|
| 0001 | (example) see TASK-0001.example.md — delete at setup | athena.example | ready | plan/… |
