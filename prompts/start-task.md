# Oracle · Start a task

> Work-loop step ③. Each step shows its result to the human.

---

Starting **TASK-____**:

1. **Touch** the mountain; report anything affecting this task (contract changes / shared files in motion / blockers).
2. **Recall**: scan `memory/INDEX.md` for entries matching this task; `grep -ril` its distinctive terms (paths, components, verbatim error strings) in `memory/notes/`; open **at most 3** notes.
3. **Task file**: open `tasks/TASK-____*.md` (or create from `_template.md`, owner = me). Confirm goal, repos, **boundaries (Allowed paths)**, DoD (criteria bound to named tests), deps — deps not ready and un-mockable → switch tasks.
4. **Claims** (if applicable): shared resources → register in `contract/shared-resources.md`; new interfaces → shape must exist in `contract/api-contract.md` first (Steward drafts / others request by letter).
5. **Branch** (each repo touched):
   ```bash
   git fetch origin && git checkout -b feat/<handle>-task____-<slug> origin/{{INTEGRATION_BRANCH}}
   ```
6. **Register** (one Olympus commit+push): task → `in_progress` + branch; status board; letters for anything I'll need from others — **sent now, not when stuck**. `[<handle>] task: TASK-____ started`.
7. **Plan the build**: verifiable small steps (one commit each) + test strategy; confirm with the human, then build.

While building: small commits · Touch after each · stay inside ownership · (ops-owner side) draft-only for danger · prose ≠ done.
