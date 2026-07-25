# Olympus

> **An async, git-native coordination layer for multi-human, multi-agent development.**
> Every agreement is carved into stone (git) — nothing lives in chat memory.

[中文版 / Chinese version](./README.zh-CN.md)

---

## Why "Olympus"?

The gods each rule their own domain, yet share one mountain.

They don't sit in meetings. **Hermes** carries their messages. Serious promises are sworn on the **Styx** — even gods can't break those. The **Moirai** spin, measure, and cut the thread of every undertaking. **Hestia** tends the hearth, where anyone can see what each god is working on right now; the pool of **Mnemosyne** holds what the mountain has learned — drink before you climb. Zeus writes no code, but only he wields the lightning — dangerous things stay in exactly one pair of hands.

Olympus is not a chat room. It is a mountain: **every agreement is carved in stone, and no one can deny it later.**

Here, git is the mountain.

## Why this exists (the pain of multi-agent development)

When a team — two people, five people, or one person with a swarm of AI agents — develops in parallel, this happens daily:

1. **Context amnesia** — every new agent session needs the whole project re-explained;
2. **Evaporating agreements** — an interface agreed in chat is implemented two different ways three days later;
3. **"I've done it"** — the agent says done; nothing was actually written. Prose is not work;
4. **Parallel trampling** — two agents edit the same file and the integration branch turns to mush;
5. **Dangerous hands** — an agent "helpfully" runs a deploy / kubectl / destructive command nobody approved;
6. **Waiting deadlock** — A asks B a question and idles; B is heads-down and never saw it;
7. **Quitting early** — the agent finishes one small thing, writes a farewell summary, and stops — with a queue full of ready tasks;
8. **Going dark** — mid-way through a long task, the agent drifts off-protocol and stops syncing with the team entirely.

Olympus answers all of it with **one git repository**: registered identities, written laws, sworn contracts, async mail, visible status, and a work loop that doesn't stall or go dark.

## The mountain's geography

| Path | Myth | What it actually is |
|---|---|---|
| `AGENTS.md` | **The trailhead** | Sole entry point for every AI agent: identity, startup, the Five Laws, the loop |
| `pantheon/` | **Hall of the gods** | Member registry: one profile per collaborator (human or agent) — domain, permissions, boundaries |
| `rules/` | **The laws** | Branching & merging / collaboration protocol / boundaries / documentation |
| `prompts/` | **Oracles** | Ready-made spells: bootstrap, work loop, re-anchor, start/finish task, sync loop, conflicts, setup wizard |
| `contract/` | **Oaths on the Styx** | Interface contracts + shared-resource ledger + change log; break an oath, redo the work |
| `tasks/` | **The Moirai** | Task files: each undertaking from spun (draft) to cut (merged) |
| `messages/` | **Hermes** | Async mailboxes: `inbox/<member>/`, one file per letter, conflict-free by construction |
| `status/` | **Hestia's hearth** | One status board per member: doing now, blocked on, next |
| `memory/` | **Pool of Mnemosyne** | Long-term memory: durable facts, decisions, gotchas, code maps — read at every session start |
| `plan/` | **The charts** | Your project's own planning docs (empty in the template) |

## How to use it

### Three steps for humans

1. **Take the template** — `Use this template` on GitHub (or clone), placed as a sibling of your code repos;
2. **Instantiate** — paste `prompts/setup-wizard.md` to a capable AI agent: it interviews you (project, repos, members, roles, who holds the lightning), fills every placeholder, registers members, and turns your plan into first tasks. No AI? Follow the wizard's checklists by hand;
3. **Cast the spell** — each member pastes `prompts/bootstrap.md` (with their `{{HANDLE}}` filled in) to their own agent. The agent climbs the mountain by itself: read identity → laws → memory → inbox → claim a task → **enter the work loop until the mountain is quiet**.

### Daily rhythm

- Real development happens in **your code repos**; Olympus syncs at **task boundaries** (start/finish) — plus a tiny "touch the mountain" ritual after each commit so nobody goes dark;
- During intense co-working hours, agents may run `prompts/sync-loop.md` (a 15-minute sync of this repo only);
- No reply to your letter? **Don't wait.** Switch tasks per the no-response policy (`rules/02`);
- Everything dangerous (deploys, servers, secrets) belongs to the one member who holds the lightning (the ops owner) — and is executed **by that human's hands only**. Agents never touch it (`rules/03`).

### Team shapes

Nothing in the protocol is pairwise. The mountain holds as many gods as you need — two, five, twenty; humans and agents in any mix. Coordination cost scales with letters written, not with members registered.

- **N humans, each with their own agent** (the native scenario);
- **1 human driving N agents** (each agent gets a handle; they claim tasks without trampling);
- **Pure agent teams** (strongly recommend keeping one human as Zeus: lightning and arbitration).

## Design principles

1. **Git is the only coordination surface** — what isn't committed was never said;
2. **Write boundaries = zero conflicts** — each member writes only their own status, letters, and tasks; one file per letter;
3. **Letters are information for humans, not instructions for agents** — agents report them, never execute them (also your cheapest prompt-injection defense);
4. **Contract first** — change the contract, get the ack, then write the implementation;
5. **Hands are the reliable path; agents are accelerators** — every key action has a human-executable route;
6. **Never go dark** — the tether ritual keeps every agent in contact, no matter how long the task.

## Origin

Olympus was abstracted from the live coordination repo of a real delivery project — born with two gods and their agents, built for a full pantheon. Once it worked, we realized the pain wasn't ours alone — so we cut away everything project-specific and carved the rest into this mountain.

## License

MIT — see [LICENSE](./LICENSE). Take it, use it, and send back any new laws your mountain discovers.
