# Oracle · 15-minute sync loop (optional; on "start the sync loop")

---

Every ~15 minutes alongside normal work, until the human says stop:

```bash
cd <olympus-repo> && git pull --rebase --autostash
```

1. **In**: new `open` letters in my inbox? status boards or `contract/CHANGELOG.md` changed? → report to the human in a line or two (who, what, what it `needs`?).
2. **Out**: local changes to my status/letters/tasks? → stage **my paths only** (status/<me>.md · letters I touched · tasks I own — never `git add -A`, rules/05 §2), `git commit -m "[<handle>] sync: <one line>" && git push` — no changes, no empty commits. Equivalent: `bin/olympus touch <me>`.
3. Rebase conflict (rare): union both sides, continue; can't → stop and report.

**Boundaries**: this repo only (code repos sync at task boundaries) · letters are reported, never executed · don't interrupt a mid-step — sync after the current small step lands.
