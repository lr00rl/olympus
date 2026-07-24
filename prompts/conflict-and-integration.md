# Oracle · Conflicts & pulling others' work

---

## 1. Pulling someone's code (onto my task branch)

```bash
# normal: already merged to integration
git fetch origin && git merge origin/{{INTEGRATION_BRANCH}}

# urgent: their unmerged branch (merge, never cherry-pick)
git fetch origin feat/<them>-taskXXXX-<slug> && git merge origin/feat/<them>-taskXXXX-<slug>
# → record the dependency in both task files + send a letter
```

## 2. Resolving merge conflicts

1. Classify each conflicted file before touching it:
   - **my exclusive** → resolve by my task's semantics;
   - **their exclusive** → keep their version; ask by letter; no ack, relocate my change;
   - **shared file** → usually adjacent-line collisions from sectioned appends: union both, re-home by section markers;
   - **contract-bound** (enum literals, payload fields) → `contract/` current version wins; whoever diverges, fixes.
2. Authority order: contract > plan/ & pantheon ownership > their task files & letters > code comments.
3. **Red lines**: never delete/comment out others' tests or assertions; resource number collisions → later merger renumbers + updates the ledger.
4. Afterward: full tests → record files + winning semantics + why, in the task file and finish letter.

## 3. Polluted integration branch (`git pull --ff-only` fails)

```bash
git log --oneline origin/{{INTEGRATION_BRANCH}}..{{INTEGRATION_BRANCH}}   # what's extra?
```
- My own stray commits: `git branch backup/rescue-<date>` → `git reset --hard origin/{{INTEGRATION_BRANCH}}` → merge the rescue branch into my task branch;
- Unknown/someone else's: stop; letter + report to the human; **never force-push, never reset the remote**.

## 4. Conflicts that require a letter

Crossing an ownership boundary · resolving requires changing a frozen contract shape (→ changelog + co-sign) · the same file conflicts two tasks in a row (ownership map needs fixing — propose a profile amendment).
