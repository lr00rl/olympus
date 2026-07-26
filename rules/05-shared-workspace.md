# rules/05 · Shared workspace (two or more seats on one machine)

Applies when seats run **on the same machine against the same clones** — the usual shape when one
human drives several agent CLIs side by side. If every seat has its own machine or its own clone,
skip this file; nothing here is about branching policy (that is `rules/01`), only about *where
your working copy lives*.

One sentence: **code repos are never edited in the shared clone; the Olympus repo is never
worktree'd.** Both halves matter, and they point in opposite directions on purpose.

---

## 1. Code repos — take your own worktree

Two seats cannot have different branches checked out in one clone. The moment two tasks touch the
same repo — even different directories inside it — the shared clone becomes a single-writer
resource and one seat blocks the other.

**Before your first edit in any code repo:**

```bash
git -C <repo> fetch origin
git -C <repo> worktree add ../.wt/<handle>-<repo> -b <branch> origin/{{INTEGRATION_BRANCH}}
cd .wt/<handle>-<repo>          # all your work happens here
```

- `.wt/` sits at the workspace root, **outside every repo**, so nothing needs gitignoring;
- **never cd into, edit, or delete another seat's `.wt/` directory** — not to "just check", not to
  fix something for them; if their tree is wrong, letter them;
- remove yours when the task merges: `git -C <repo> worktree remove ../.wt/<handle>-<repo>`;
- **read-only use of the shared clone is fine** — reading code, `git log`, `git diff`, PR review.
  Just never check out, switch branches, or write there.

> Field note: this is not hypothetical tidiness. In one instantiation, the first two tasks handed
> out landed in the same repo — one in its backend directory, one in its UI directory — and the
> two seats needed different branches within the hour.

## 2. The Olympus repo — deliberately shared, never worktree'd

Every seat commits to this repo's default branch. That is the design: one file per letter, each
seat writing only its own status board, so **content conflicts are near-impossible**. What you can
still collide on is git's own plumbing.

- `git pull --rebase origin <default-branch>` **before every push**;
- `fatal: Unable to create '.git/index.lock'` means another seat is mid-commit — **wait a few
  seconds and retry; never delete the lock file**;
- push rejected → pull --rebase, then push again. **Never force-push** (`rules/01 §3`);
- `git add -A` from the repo root can sweep up another seat's in-flight edits. **Stage your own
  paths explicitly** — your status board, your letters, your task files.

## 3. Cleanup is part of finishing

Stale worktrees outlive the tasks that needed them and quietly rot (`git worktree list` grows,
disk fills, and someone eventually resumes work in a tree whose branch merged last week). Removing
your own worktree belongs in the finish step, alongside pushing the branch.
