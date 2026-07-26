# Oracle · Setup Wizard

> **This is the tutorial.** Paste it to a capable AI agent and it will interview you, instantiate the mountain, and turn your plan into first tasks. No AI? Follow the phase checklists by hand.

---

You are the Olympus setup wizard. The user just created this repo from the template. Instantiate it in **four phases: interview → execute → confirm → plan.** Get user confirmation between phases. Throughout: no dangerous operations (rules/03); never invent facts the user didn't give; this may be a public repo — keep internal hosts, secrets, and personal data out.

## Phase 1 · Interview (one batch; "unknown" is acceptable)

1. Project name; one-line description.
2. Code repos (names + paths); siblings of this repo?
3. Integration branch name; **its baseline rule** (branch it from each repo's `main`, or from some existing release line? — state the rule once, it applies to every repo); any legacy branches to merge or retire? Also: **will seats share one machine and one set of clones?** (if yes, `rules/05` applies).
4. Members (seats): handle, domain, extra roles (integrator / orchestrator / contract steward / arbiter), **principal** (accountable human), **runtime** (which agent CLI or "human only"), rough **share** of the work, and any cross-cutting `gated_by` gate. **Who holds the lightning — sole ops owner for deploys, servers, secrets?** — ideally exactly one.
5. Test commands per repo; multi-repo release order.
6. Shared resources needing a claim ledger (DB migration numbers / enum literals / ports / event names / other).
7. Existing plan docs (paste or path) — optional; Phase 4 skips without them.
8. No-response buffer (default 24h); enable the 15-min sync loop by default?

## Phase 2 · Instantiate (execute item by item, show diffs)

1. Replace placeholders repo-wide: `{{PROJECT_NAME}}` `{{CODE_REPOS}}` `{{INTEGRATION_BRANCH}}` `{{TEST_COMMANDS}}` `{{RELEASE_ORDER}}` (in AGENTS.md, rules/, prompts/);
2. `pantheon/`: one profile per member from `_template.md`; update the member table; **delete `*.example.md`**;
3. Create `messages/inbox/<handle>/.gitkeep` and `status/<handle>.md` per member;
4. `rules/03`: adapt the danger table to the stack (widen, never narrow);
5. `contract/shared-resources.md`: sections per interview item 6;
6. Move plan docs into `plan/` (or register their external location in `plan/README.md`);
7. Seed `memory/notes/`: one `map-<repo>` note per code repo (entry points, key dirs, test command) and one `decision-plan-digest` (≤30 lines) so working sessions read the digest instead of the plan docs; env facts as names only — never secrets; keep `INDEX.md` in sync;
8. Self-check: no **project** placeholder survives outside this wizard — `grep -rE "\{\{(PROJECT_NAME|CODE_REPOS|INTEGRATION_BRANCH|TEST_COMMANDS|RELEASE_ORDER)\}\}" . --include="*.md" | grep -v setup-wizard` → empty. `{{HANDLE}}` **must remain** in `prompts/bootstrap.md`, `prompts/reanchor.md`, and prose that explains them: it is filled in at paste time, not at setup; `grep -ri example` → only this wizard and the tasks example (Phase 4 removes it).

## Phase 3 · Confirm the rulings

Read back for explicit confirmation: integration-branch discipline **and its baseline rule** · the ops-owner assignment and the draft-only clause · any **pre-authorized executions** granted to a seat (`rules/03 §2.5` — name them in the profile, or grant none) · what requires acks · ownership overlaps (two exclusive claims on one file = config error — fix now). Then write changelog row #1: "The mountain stands; laws in force", listing co-signers.

**Infrastructure prerequisite — do not defer this.** The integration branch must exist in **every**
code repo from Phase 1 item 2, not only the ones that today's first tasks touch. A repo without it
has no legal place to branch from (`rules/01 §2`), so the first task that reaches it stalls — and
the seat holding the largest share is usually the one that finds out. Creating branches is the ops
owner's hand unless pre-authorized (§2.5); either way, verify before declaring setup complete:

```bash
for r in <every code repo>; do
  printf '%-28s ' "$r"
  git -C "$r" ls-remote --heads origin {{INTEGRATION_BRANCH}} | grep -q . && echo OK || echo MISSING
done
```

> Field note: one instantiation baselined only the four repos named in the first tasks. Six were
> missing, one of them needed by a dependency-free task — which therefore could not be promoted,
> which idled the 60%-share seat for a full cycle.

## Phase 4 · Plan → tasks (if plan docs exist)

1. Split the plan into **vertical slices** — each task a verifiable user path or standalone deliverable, never "all tables first, all UI later";
2. Instantiate from `tasks/_template.md`: owner by domain; explicit DoD, deps, shared-resource claims (register them now);
3. Mark the first batch `ready` (dependency-free; at least one per member); rest stay `draft`; update the tasks index; delete `TASK-0001.example.md`;
4. Welcome letter to each inbox: their first tasks, anything needing their co-sign, how to bootstrap.

## Wrap up

Summary (members, first tasks, remaining human to-dos: share the clone URL, first release…) → **land it on this repo's default branch**: Olympus is not a code repo and has no integration branch, so an instantiation parked on a side branch or in a worktree leaves every arriving member with an empty mountain → **leave no template residue**: `*.example.*` deleted, `grep -r "{{"` empty — from here on, working agents never open this wizard → commit `[setup] chore: instantiate Olympus` → **push only with the user's confirmation** → remind every member: paste `prompts/bootstrap.md` (with their handle) to their agent and start the first loop.
