# memory/ · The Pool of Mnemosyne (long-term memory)

The mountain's durable memory, for large projects maintained over months by rotating humans and agents. **Drink before you climb** (startup reads the index), **harvest before you descend** (task finish asks what was learned).

## The economics (why the protocol looks like this)

A model is stateless: "memory" is nothing but *choosing what enters the context window*. Three costs, in order of importance:

1. **Read cost is paid every session** — it dominates. So the always-loaded part must be tiny: the index, never the bodies.
2. **Irrelevant context is worse than free** — it dilutes attention and invites drift. Precision beats completeness in what you *load*; completeness lives in cheap *pointers* (index lines) you can follow.
3. **Write cost is paid once** — and is near zero if you harvest at the moment the evidence is already in context (task finish), instead of running a separate "remember things" pass. Never run that pass.

## Two-tier protocol

- **Tier 0 — `INDEX.md`** (always loaded at startup): one line per note — `- [slug](notes/slug.md) — hook`. Hard budget: **≤ 50 lines**; hooks ≤ 100 chars. When it overflows, consolidate (below), don't grow.
- **Tier 1 — `notes/*.md`** (loaded on demand): one durable fact per file, **≤ 30 lines**.

### Recall (at task start — see prompts/start-task.md)

1. Scan `INDEX.md` (already in context) for entries matching the task's terms;
2. `grep -ril "<term>" memory/notes/` with distinctive terms: file paths, component names, **verbatim error strings**;
3. Open **at most 3 notes**. More seem relevant? Your notes are too fragmented — load the top 3 now, consolidate later.

### Harvest (at task finish — see prompts/finish-task.md)

Choose exactly one operation, in this order of preference:

| Op | When |
|---|---|
| **NOOP** | the default. Most tasks teach nothing durable — skip *consciously*, don't invent memories |
| **UPDATE** | the fact refines an existing note → edit it (search the index first) |
| **SUPERSEDE** | an existing note is now wrong → correct or delete it (git remembers) |
| **ADD** | a genuinely new durable fact → new note + index line |

## What belongs (durable facts only)

`architecture` (invariants code can't show) · `decision` (the *why*, incl. rejected options) · `gotcha` (trap + workaround, **keyed by the verbatim error message**) · `map` (per-repo orientation: entry points, key files, how to run tests) · `env` (environment facts — **never secrets**).

Not here: progress (→ `status/`, `tasks/`), design (→ `plan/`), interface shapes (→ `contract/`). The promotion pipeline: task log (episodic) → memory note (semantic) → rule/contract (procedural; rare, co-signed).

## Write for your future recall (grep is the retrieval engine)

No embeddings here — recall is lexical. Write the strings a future session will actually search:

- `keywords:` front-matter with aliases, file paths, command names;
- gotchas quote the **exact error text**;
- predictable slugs: `map-<repo>` · `gotcha-<symptom>` · `decision-<topic>` · `arch-<area>` · `env-<name>`.

## Hygiene

1. **Read-repair**: used a note and found it stale? Fix it *now* — memory that lies is worse than none.
2. Notes carry `added:`/`verified:` UTC dates; trust decays — verify old notes that name files or flags before acting on them.
3. Memory is communal: anyone may correct any note (unlike status boards).
4. **Consolidation sweep** (a chore task, when INDEX nears 50 or recall keeps returning >3 hits): merge overlapping notes, delete dead ones, sharpen hooks. Ten sharp notes beat a hundred stale ones.
