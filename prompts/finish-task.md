# Oracle · Finish a task (merge + communicate)

> Work-loop step ⑥. Any step fails → stop and report; no skipping. **This is not the end of the session — loop back after.**

---

Finishing **TASK-____**:

## 1. Preconditions (rules/01 §4)

1. Each repo: `git fetch origin && git merge origin/{{INTEGRATION_BRANCH}}`; resolve everything on my branch (authority: contract > plan/pantheon > their files > comments; cross-ownership → letter first).
2. **Boundary check** (mechanical): `git diff --name-only $(git merge-base origin/{{INTEGRATION_BRANCH}} HEAD)..HEAD` — every file must match the task's Allowed paths. Out-of-bounds files → stop: either move the change to its own task, or record the boundary amendment in the task log (and letter the owner if it crosses ownership).
3. Full tests `{{TEST_COMMANDS}}` — report **real numbers**; DoD criteria are proven by their **named tests**, not by "suite green".
4. **Acks**: touching contract / others' exclusive / shared files / shared resources / auth / someone's authority area? Confirm their `[ack]` is on record — missing → send/chase the letter, park this task, **switch tasks and keep looping**.

## 2. Merge (owner's hands; multi-repo in {{RELEASE_ORDER}} order)

```bash
git checkout {{INTEGRATION_BRANCH}}
git pull --ff-only origin {{INTEGRATION_BRANCH}}    # fails → conflict prompt §3; NEVER force-push
git merge --no-ff feat/<handle>-task____-<slug>
# quick regression, then:
git push origin {{INTEGRATION_BRANCH}} && git push origin feat/<handle>-task____-<slug>
```

## 3. Communicate (one Olympus commit+push)

1. Task file → `merged`; record: scope, conflicts & resolutions, test numbers, docs touched, leftovers ("none" is a valid entry — say it).
2. Status board: move to recent, update next.
3. **Harvest memory** — exactly one op, preferred in this order: **NOOP** (default: most tasks teach nothing durable) / **UPDATE** an existing note / **SUPERSEDE** a now-wrong note / **ADD** (new fact ≤30 lines + index line, `keywords:` carrying paths & verbatim errors). Search `INDEX.md` before adding. (`memory/README.md`)
4. Finish letter to affected members:

```markdown
---
from: <handle> / to: <handle> / date: <date -u, YYYY-MM-DDTHH:MMZ>
re: TASK-____ / needs_reply: no|yes / status: open
---
TASK-____ <title> merged into {{INTEGRATION_BRANCH}}.
- commits: <hash>(repo)…  · tests: <real numbers>
- impact on you: <new interface / contract field / shared file | none>
- action needed: <merge integration / co-sign X | none>
- conflicts: <files + whose semantics | none> · docs: <list> · leftovers: <or none>
```

5. `[<handle>] task: TASK-____ merged` → push.

## 4. Loop back

Release needed? the ops owner's side drafts the checklist ("Run this yourself"); others add "please release when convenient" to the letter. Emit the checkpoint (work-loop §3) and **return to loop step ①**.
