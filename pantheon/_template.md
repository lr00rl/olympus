---
handle: <lowercase, e.g. hermes>
name: <optional real name / callsign>
epithet: <optional, for fun>
roles: [developer]            # see README role vocabulary
ops_owner: false              # ideally exactly one true on the whole mountain
contract_steward: false
integrator: false
arbiter: false
joined: YYYY-MM-DD            # UTC date
status: active                # active | away | left
---

## Domain (what I own)

<one line + detail; which line of the project plan>

## Code ownership

**Exclusive** (others don't touch; ack me first):
- <repo>/<path or module> …

**Shared** (files I touch that need registration per rules/01 §4):
- <repo>/<file> …

## My boundaries

- Branch prefix: `feat/<handle>-*`
- Writable here: `status/<handle>.md`, letters I send, tasks I own
- Danger: <none | I am the ops owner: my agent drafts only, I execute by hand>
- Other: <e.g. "my backend code needs <who>'s review before merge">

## Rhythm

- Timezone / usual hours: <optional>
- No-response buffer: 24h (default)
