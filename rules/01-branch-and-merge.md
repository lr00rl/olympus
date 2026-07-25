# rules/01 · Branching, checkout & merging

Applies to all code repos `{{CODE_REPOS}}`. The Olympus repo itself commits straight to `main` (`AGENTS.md §4`).

---

## 1. Branch model

```
main                        ← stable baseline (release merges only; Integrator's hands)
└─ {{INTEGRATION_BRANCH}}   ← ★ the ONE integration branch: all task branches land here
     ├─ feat/<handle>-task<NNNN>-<slug>
     ├─ fix/<handle>-task<NNNN>-<slug>
     └─ chore/<handle>-...
```

- One integration branch name across all code repos. Legacy branches get merged or declared dead at setup — never two live integration lines.
- One task (TASK-NNNN) = one same-named branch in every repo it touches.

## 2. Checkout (starting a task)

```bash
git fetch origin
git checkout -b feat/<handle>-task<NNNN>-<slug> origin/{{INTEGRATION_BRANCH}}
```

- Always branch from the **fresh remote integration tip** — never from stale local branches or someone's feature branch.
- Need someone's unmerged work? Branch from integration anyway, then merge their branch (§6) and record the dependency in both task files.
- Rework returns to the original branch; never open a second branch for the same task.
- **Queued-resource dependencies**: if your `contract/shared-resources.md` claim builds on earlier *unmerged* numbers, don't develop on top of them in parallel — split the task so the dependent slice branches after its predecessors merge, or negotiate an earlier slot. Budget for exactly one final rebase (rules/02 §3.5); the field cost of ignoring this was four review rounds on a single task.

## 3. Push / pull rhythm

- **Push** your own task branch freely (backup + visibility); at least once per working day.
- **Pull** integration mid-task only when: a contract change lands · you're about to touch a shared file · the task exceeds 3 working days.
- **Never** rebase or force-push a branch that's been pushed.

## 4. Merge preconditions (all required)

1. `git fetch origin && git merge origin/{{INTEGRATION_BRANCH}}` — resolve all conflicts **on your branch**;
2. Full tests green (`{{TEST_COMMANDS}}`) — report **real numbers**;
3. Task file updated + finish letter drafted (pushed together with the merge);
4. **Acks collected** (letter `[ack]` on record; word of mouth doesn't count) when touching:
   - anything in `contract/` → Contract Steward
   - files listed as someone's **exclusive** in their profile → that owner
   - shared files (profiles' shared lists) → the affected owner(s)
   - resources in `contract/shared-resources.md` → per the ledger
   - auth / permission / security semantics → Integrator
   - code you wrote inside someone else's authority area → that owner's review

## 5. The merge (task owner executes; multi-repo in {{RELEASE_ORDER}} order)

```bash
git checkout {{INTEGRATION_BRANCH}}
git pull --ff-only origin {{INTEGRATION_BRANCH}}   # fails ⇒ polluted local branch → conflict prompt §3; NEVER force-push
git merge --no-ff feat/<handle>-task<NNNN>-<slug>  # --no-ff keeps the task boundary
# quick regression: run the repo's test entry once
git push origin {{INTEGRATION_BRANCH}}
git push origin feat/<handle>-task<NNNN>-<slug>    # keep the branch for the record; prune periodically
```

Then push the Olympus side: finish letter + task status + status board.

## 6. Pulling someone's progress

| Case | Do |
|---|---|
| Already merged to integration (normal) | `git fetch origin && git merge origin/{{INTEGRATION_BRANCH}}` |
| Need their **unmerged** branch | `git fetch origin feat/<them>-taskXXXX-* && git merge origin/feat/<them>-...` — **merge, never cherry-pick**; record dependency + send a letter |
| Just looking | `git fetch` then `git log/diff`, or a throwaway `git worktree add` |

## 7. Conflicts (procedure in prompts/conflict-and-integration.md)

1. Whoever merges, resolves.
2. Authority order: `contract/` > `plan/` & pantheon ownership > their task file & letters > code comments.
3. Conflict inside **someone else's exclusive area** → don't decide for them: keep their version, ask by letter; no ack, move your change elsewhere.
4. **Never** delete or comment out someone's tests/assertions to make a conflict go away.
5. Shared-resource collisions (migration numbers etc.): later merger renumbers and updates the ledger.
6. Record in the finish letter: conflicting files + whose semantics won + why.

## 8. Releases & main (Integrator / ops owner only, always by hand)

- Release from the integration branch; order `{{RELEASE_ORDER}}`, rollback in reverse; data migrations additive only.
- CI triggers / deploy commands / infra: **the ops owner's hands**. Agents output a checklist ending with "Run this yourself".
- Verify by real use, not by "build passed". Broadcast the result in a letter; leftovers become tasks.
- At milestones the Integrator merges integration → `main` and tags.

## 9. Cheat sheet

```bash
# start
git fetch origin && git checkout -b feat/<handle>-task<NNNN>-<slug> origin/{{INTEGRATION_BRANCH}}
# backup
git push origin HEAD
# absorb integration
git fetch origin && git merge origin/{{INTEGRATION_BRANCH}}
# finish (tests green + acks in hand)
git checkout {{INTEGRATION_BRANCH}} && git pull --ff-only origin {{INTEGRATION_BRANCH}} \
  && git merge --no-ff <task-branch> && git push origin {{INTEGRATION_BRANCH}}
```
