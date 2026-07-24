# Oracle · Work Loop (anti-idle, anti-drift)

> Fixes the two commonest agent failures: **quitting early** (one small thing done, farewell summary, session over — with ready tasks left) and **going dark** (a long task swallows the agent; it stops syncing). Referenced by bootstrap; humans can paste it mid-session to restore the loop.

---

## 1. The loop

```
  ┌────────────────────────────────────────────────────────┐
  ▼                                                        │
①Touch → ②Pick → ③Start → ④Build → ⑤Verify → ⑥Finish → ⑦Checkpoint ─┘
```

| Step | Action | Ref |
|---|---|---|
| ① Touch | pull Olympus, scan inbox & changelog, push status delta | AGENTS.md §2 |
| ② Pick | priority: in_progress > letters where someone waits on me (ack/review/reply) > `ready` w/o deps > instantiate from plan/ | tasks/README |
| ③ Start | `prompts/start-task.md` | |
| ④ Build | small commits; ownership boundaries; **Touch after each commit** | rules/01/03 |
| ⑤ Verify | run tests / real execution; record real numbers | |
| ⑥ Finish | `prompts/finish-task.md` | |
| ⑦ Checkpoint | emit §3 report, then **back to ①** | |

## 2. Anti-idle / anti-drift clauses

1. **Finishing a task ≠ ending the session.** After ⑥ comes ⑦ then ①, not a farewell.
2. **Before writing any summary, run the three checks**: DoD all ticked? · any `ready` task left? · any `open` letter? — **any "yes" → back to ①.**
3. "Sent a letter, waiting" is not a stop — switch tasks (rules/02 §4).
4. "This task is huge" is not a stop — split it into subtasks in tasks/ and do the first one. **The Touch cadence survives inside big tasks**: however deep you are, every commit-level step ends with a Touch. If you notice you haven't touched the mountain in a long stretch — stop building, Touch, then continue.
5. Partial work never poses as done: plan-only isn't done, half-written isn't done, untested isn't done. Interrupting? keep `in_progress`, log the break-point.
6. Same error three times in a row → stop grinding: log findings to the task, mark `blocked`, letter, switch.

## 3. Checkpoint report (end of every cycle)

```
── checkpoint #N ──
✔ done:    TASK-xxxx <one line> (commit <hash> / tests <real numbers>)
▶ next:    TASK-yyyy <why this one>
⏸ waiting: <letter to whom about what | none>
☰ backlog: <n> ready tasks, <m> open letters
```

The human may redirect at any checkpoint; **no instruction means keep looping**.

## 4. Legal stops (only four)

1. The human says stop;
2. No `ready` tasks, nothing to instantiate from plan/, inbox empty — the mountain is quiet;
3. The human's session budget (time/cost/cycles) is reached;
4. The only possible step needs a human decision and no alternative task exists.

A legal stop still ends with: final checkpoint + status board updated + Olympus pushed — **leave the mountain so the next session picks up seamlessly**.
