# rules/04 · Documentation

Principle: **docs travel with code, state travels with Olympus, design travels with plan/contract.** Never mix the three.

| Kind | Lives in | Maintainer | When |
|---|---|---|---|
| Code docs (README, module design, API notes) | each code repo | module owner per pantheon | **same branch, same commit** as the code; behavior changed but docs not = merge precondition fails |
| State / progress / letters | this repo: status/ tasks/ messages/ | each their own | task boundaries |
| Design / rules / contract | this repo: plan/ contract/ rules/ | Contract Steward, co-signed | **docs first, then code** |

## Revising plan/

Finalized plans are never edited in place; revisions are new, numbered files stating what they amend. On conflict, **contract/ wins over plan/** — the contract is runtime truth, the plan is a snapshot.

## Per-task doc DoD

The finish letter lists: ① code docs changed ② contract changes triggered (link the changelog row) ③ any doc debt — named explicitly and turned into a chore task, never silent.

## Style for agents

Consistent vocabulary (glossary in plan/); no "should work" / "mostly done" — state did / verified / not verified; verify that every command, path, and endpoint you write actually exists.
