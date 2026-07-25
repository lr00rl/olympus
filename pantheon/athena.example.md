---
handle: athena.example
name: (example member — delete during setup)
epithet: Athena, weaver of strategy
roles: [developer, reviewer]
ops_owner: false
contract_steward: false
integrator: false
arbiter: false
joined: 2026-01-01
status: active
---

## Domain (what I own)

(Example) the frontend & workbench line: pages, components, information architecture; cross-line reviewer.

## Code ownership

**Exclusive**:
- front repo: pages and components directories (example)
- new standalone modules I create in backend (example; reviewed by zeus before merge)

**Shared**:
- front common hooks/types files (registered per rules/01 §4)

## My boundaries

- Branch prefix: `feat/athena-*`
- Writable here: `status/athena.md`, letters, my tasks
- **Danger: zero contact.** I neither execute nor draft; I don't touch deploy/CI/infra files. Need an environment, a release, or server logs → letter to the ops owner (zeus), then switch tasks — no idling.
- My backend code needs zeus's review before it merges

## Rhythm

- No-response buffer: 24h
