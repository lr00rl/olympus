# memory/ · The Pool of Mnemosyne (long-term memory)

Initiates drank from Mnemosyne's pool to *remember*. This directory is the mountain's durable memory — for the large project maintained over months by rotating humans and agents, where every new session otherwise starts ignorant.

**Drink before you climb**: session startup reads `INDEX.md` (AGENTS.md §3). **Harvest before you descend**: finishing a task asks "did this teach a durable fact?" (finish-task §3).

## What belongs here (durable facts only)

| Kind | Example |
|---|---|
| `architecture` | "service A never talks to the DB directly; all writes go through B's command layer" |
| `decision` | "we rejected soft-config X because …" — the *why* that code can't show |
| `gotcha` | "config values must not be quoted in <tool> — quoted values broke prod once" |
| `map` | a code map of a repo/module: entry points, key files, how to run tests |
| `env` | environment facts (**never secrets/credentials** — names and shapes only) |

## What does NOT belong

- Progress → `status/` (now) and `tasks/` (work). Memory is what stays true after the task is forgotten.
- Design & intent → `plan/`; interface shapes → `contract/`.
- Anything you'd have to redact before showing a new teammate.

## Format

One fact per file in `notes/`, kebab-case slug:

```yaml
---
slug: <kebab-slug>
kind: architecture | decision | gotcha | map | env
added: YYYY-MM-DD          # UTC
by: <handle>
---
<the fact, self-contained; link related notes as [[slug]]>
```

Then add one line to `INDEX.md`: `- [<slug>](notes/<slug>.md) — <hook, one line>`. The index is what sessions actually read — keep hooks sharp.

## Hygiene (memory that lies is worse than no memory)

1. **Search before you add** — update the existing note instead of duplicating.
2. **Supersede, don't accumulate** — a fact that changed gets edited; a fact proven wrong gets deleted (git remembers).
3. **Verify before you rely** — a note reflects when it was written; if it names a file, flag, or command, check it still exists before acting on it.
4. Memory is communal: anyone may add or correct any note (unlike status boards). Correcting beats politely ignoring a stale note.
5. Keep it small. Ten sharp notes beat a hundred stale ones; if `INDEX.md` stops fitting on a screen, prune.
