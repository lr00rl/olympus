# API Contract (state: template shell — Steward drafts, affected members co-sign)

Granularity bar: **another member can write a correct caller or mock from this file alone, without reading your implementation.**
Suggested conventions (adapt per project): idempotency key + optimistic version on writes; 404 (not 403) for unauthorized resources; cursor pagination; one error-body shape.

---

## 0. Enum literals (highest-order contract)

```
<object>.<field> ∈ value_a | value_b | value_c
…
```

## 1. <endpoint or interface> (owner: <handle>; consumers: <handles>)

- Method & path / trigger:
- Permissions:
- Request (JSONC, nullability marked):
- Response (JSONC):
- Error semantics:
- Idempotency / concurrency:

## 2. … (one section per cross-member interface)

## N. Events / message formats (if any)

- event name (enum!), payload shape, delivery semantics (at-least/exactly-once), consumers
