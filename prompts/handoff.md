# Oracle · Handoff (pass an in-flight task to another member)

> Use when a task changes hands mid-flight — different specialty needed, a runtime hit its quota, someone is away — or when you park a task another member may pick up.
> Members often work at different hours, on different runtimes. **A task only its author can resume is a task the mountain will eventually lose.**

---

## The resumability rule

A task is resumable when **the task file alone** — no chat history, no memory of the session — answers four questions:

1. **Where** — branch name and last commit hash in every repo touched, all pushed;
2. **Done / not done** — which DoD lines are ticked; for each unticked line, its current state;
3. **Verified / not verified** — real numbers for what was run, and an explicit list of what was *not* checked;
4. **Next** — the single next concrete action.

## Giving the baton

1. **Push everything.** Local-only work is invisible work; nothing that matters stays on your disk.
2. Append a `handoff` entry to the task Log with the four answers **plus the dead ends** — "tried X, failed because Y" is the most expensive thing for the next member to rediscover.
3. Set `owner:` to the receiver, keep `status: in_progress` or `blocked`, set `last_touched_by: <me>`.
4. Letter the receiver: task id, why it is moving, the four answers in one paragraph, anything awaiting an ack.
5. **Harvest memory now** (`memory/README.md`) — the receiver cannot inherit what you learned unless it is written down.

## Taking the baton

1. Read in this order: task file → letter → code. The file is the contract; the letter is context.
2. **Verify the four answers against reality** before building on them — branch exists, commit is really pushed, tests really are where the log says. Logs describe the moment they were written.
3. Reality disagrees with the log? Fix the log first, then letter the giver — do not silently absorb the drift.
4. Update `owner:` and status, then re-enter the work loop (`prompts/work-loop.md`).

## Two things a handoff is not

- **Not an escape from a hard problem.** Three failed attempts → log findings, mark `blocked`, letter — that is a blocker report, not a handoff.
- **Not a review.** The receiver inherits the work, not an approval. Required acks (`rules/01 §4`) still belong to the reviewers named there.
