# contract/ · Oaths on the Styx (the living contract)

Runtime **single source of truth** (plan/ is a snapshot; this wins on conflict). Sworn on the Styx — break an oath, redo the work.

| File | Content | Change process |
|---|---|---|
| `api-contract.md` | shapes of cross-member interfaces (endpoints / enum literals / events / payloads) | Steward drafts; every change gets a `CHANGELOG.md` row and the affected members' `[ack]` by letter; no ack, no implementation merge |
| `shared-resources.md` | claim ledger (migration numbers / enums / ports / event names…) | **claim first, code second**; collisions: later merger renumbers |
| `CHANGELOG.md` | change log (append-only, never deleted) | one row per change |

**Freeze flow**: Steward fills → affected members `[ack]` one by one → tick the row → in force. From then on, **enum literals are the highest-order contract** (shared by every repo and member; changes sync everywhere).
