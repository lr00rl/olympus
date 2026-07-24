# Oracle · Start a task

> Work-loop step ③. Each step shows its result to the human.

---

Starting **TASK-____**:

1. **Touch** the mountain; report anything affecting this task (contract changes / shared files in motion / blockers).
2. **Task file**: open `tasks/TASK-____*.md` (or create from `_template.md`, owner = me). Confirm goal, repos, DoD, deps — deps not ready and un-mockable → switch tasks.
3. **Claims** (if applicable): shared resources → register in `contract/shared-resources.md`; new interfaces → shape must exist in `contract/api-contract.md` first (Steward drafts / others request by letter).
4. **Branch** (each repo touched):
   ```bash
   git fetch origin && git checkout -b feat/<handle>-task____-<slug> origin/{{INTEGRATION_BRANCH}}
   ```
5. **Register** (one Olympus commit+push): task → `in_progress` + branch; status board; letters for anything I'll need from others — **sent now, not when stuck**. `[<handle>] task: TASK-____ started`.
6. **Plan the build**: verifiable small steps (one commit each) + test strategy; confirm with the human, then build.

While building: small commits · Touch after each · stay inside ownership · (⚡ side) draft-only for danger · prose ≠ done.
