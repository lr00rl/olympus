# rules/03 · Boundaries (the most important law)

One sentence: **dangerous operations belong to the pantheon's **ops owner**, executed by that human's hands only; no agent ever executes them.** Zeus may write no code — but the lightning never leaves his hand.

---

## 1. Dangerous operations (agents never execute — no exceptions)

| Category | Examples |
|---|---|
| Orchestration | any kubectl / helm / docker subcommand in shared or prod contexts — including "read-only" get/logs; banned wholesale to keep the line bright |
| Releases | CI/CD triggers (UI, API, CLI); image build & push; any deploy job |
| Servers | ssh / scp / rsync; cloud instance start/stop (console or CLI) |
| Network | reverse-proxy config & reload; DNS; certificates |
| Data | write access to shared-environment databases; prod config of search/queue infra; object-storage administration |
| Secrets | creating, editing, rotating, or pasting credentials; env-var injection |
| Irreversible | bulk deletion, migration rollback, force-push, account administration |

Adapt this table to your stack at setup — but keep the principle: **ban wide, never narrow**. Permissions an agent acquires "just to look" become incidents later.

## 2. Per-side rules

**The ops owner's agent:**
- May: draft commands, checklists, release steps, rollback plans; analyze logs the owner pastes in; edit infra *code* as normal code (branch flow; applying stays human).
- Must: stop after every drafted command with, prominently:
  > **Run this yourself** — agent does not execute:
- Never: actually execute, for any reason; never hide a dangerous call inside a script and then run the script.

**Every other agent:**
- **Zero contact**: no executing, no drafting, no editing deploy/CI/infra files.
- Need an environment, a release, logs, a config? → letter to the ops owner (task id, what, why), then switch tasks per rules/02 §4. No idling.

## 3. Release skeleton (the ops owner executes by hand)

1. Integration branch green; relevant TASKs merged;
2. Release in `{{RELEASE_ORDER}}` order; rollback in reverse;
3. Smoke-check by **real use**, not "build passed";
4. Broadcast the result in a letter + update your status board; leftovers become tasks.

## 4. Why this strict

- An agent's failure mode with dangerous ops isn't "error" — it's *quietly succeeding at the wrong thing*;
- The minimal audit unit is "which human approved this execution" — agent-run commands erase it;
- Collapsing execution to one person minimizes coordination: everyone just remembers "ask the ops owner".
