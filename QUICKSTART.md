# QUICKSTART — your first day on the mountain

One page. Eight ideas, three commands, one loop. Everything else is looked up at the moment you
need it (`AGENTS.md §5` has the index) — do not study the rules up front.

---

## The eight ideas

1. **Seat** — you are a registered identity in `pantheon/<handle>.md`, not "an AI" or "a user".
   The seat's `principal` is the accountable human; its `runtime` is whoever types today.
2. **Task** — one file per undertaking in `tasks/`, states `draft → ready → in_progress → done →
   merged`. The file — not any chat — is the contract; anyone can resume from it.
3. **Letter** — one file per message in `messages/inbox/<recipient>/`. Every letter says what it
   needs back (`needs: none|info|review|decision|approval`); a decision request carries options,
   a recommendation, a deadline, and a **fallback that applies itself** if the deadline passes.
4. **Status board** — `status/<handle>.md`, yours alone: what you're doing *now*, one screen max.
5. **The Touch** — the tether ritual: pull, scan your inbox, push your changes
   (`bin/olympus touch <me>`). At session start, after every commit-level step, before any summary.
6. **Worktree** — sharing a machine? Code edits happen in *your* worktree (`../.wt/<handle>-<repo>`),
   never in the shared clone. The Olympus repo itself is deliberately shared.
7. **Danger table** — deploys, servers, DB writes, secrets, CI: **human hands only** (`rules/03`).
   Agents draft at most and stop at "Run this yourself".
8. **DoD** — "done" is proven by named tests and commits, never by prose.

## Joining (someone already on the mountain runs #1 for you)

```bash
bin/olympus join <handle>        # profile skeleton + inbox + status board + member-table row
$EDITOR pantheon/<handle>.md     # fill domain, ownership, boundaries; Arbiter acks role changes
```

## Starting a session (every session — it's one line)

```bash
claude -p "$(bin/olympus bootstrap <handle>)"      # or paste the printed prompt into any agent CLI
```

Your agent then: touches the mountain → reads its whitelist (profile → memory index → boards →
open letters → its tasks) → reports → enters the **work loop** and stays in it until a legal stop.

## The loop your agent runs (and you can run by hand)

```
Touch → Pick → Start → Build → Verify → Finish → Checkpoint → back to Touch
```

- **Pick** order: my `in_progress` → letters where someone waits on me → `ready` tasks with no
  deps (`bin/olympus next <me>` lists them).
- **Blocked?** Mark it, send a letter, switch tasks. Waiting is never idling.
- **No reply?** Don't chase. Past 24h a decision letter applies its own fallback; everything else
  proceeds with a `[no-response]` note.
- **Same error three times?** Stop grinding: log it, `blocked`, letter, switch.
- **Stopping because nothing is left?** Ring the bell first: backlog letter to the Orchestrator +
  `bin/olympus wake <orchestrator>`. Quiet must never be silent.

## Hygiene in one command

```bash
bin/olympus doctor        # red = protocol violation, yellow = housekeeping due
```

## While you're away

Optional wake channels (`bin/README.md`) let events do the typing: a heartbeat cron processes
your inbox on schedule; a git hook wakes a seat the moment a letter lands; ntfy pings your phone
when something genuinely needs *you*. Your agent handles what your profile's `inbox_autonomy`
allows; everything else waits for you as a drafted recommendation, not a mystery.

That's the whole first day. The rules exist (`rules/01–05`) — open them **at the moment of the
action**, the way the index says, and never all at once.
