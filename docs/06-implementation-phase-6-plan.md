# Phase 6 — alerts and reconciliation (implementation plan)

**Ordered doc:** [`06-implementation-phase-6-plan.md`](06-implementation-phase-6-plan.md). **Analysis:** [`06-phase-6-analysis.md`](06-phase-6-analysis.md). **Previous phase:** [`05-implementation-phase-5-plan.md`](05-implementation-phase-5-plan.md).

**Phase 6 status:** `pending` (starts after Phase 5 [**local MVP gate**](05-implementation-phase-5-plan.md#local-mvp-gate) — synced book + identity path stable.)

**Commit prefix:** **`06-`**

---

## Phase status legend

| Value | When to use |
|--------|-------------|
| `pending` | Not started. |
| `in progress` | Active work. |
| `done` | Acceptance satisfied. |
| `review` | Needs rework pass. |

---

## Phase overview

| Subphase | Focus | Status |
|----------|--------|--------|
| 6.1 | Domain: `AlertIssue` model, severities, rule interface | `pending` |
| 6.2 | Rules v1: missing FX, duplicate suspect, sum sanity (optional) | `pending` |
| 6.3 | Rules v2: recurring / installment expectation hints | `pending` |
| 6.4 | UI: Issues list / dashboard section + month badges | `pending` |
| 6.5 | Dismiss / snooze persistence + tests | `pending` |
| 6.6 (optional) | Push or email digest (after Phase 5 Azure/mobile infra) | `pending` |

---

## Phase 6.1 — Alert domain model

**Status:** `pending`

**Goal:** Immutable issue DTO + rule runner contract; no Flutter in domain.

**Acceptance:** Unit tests for model + fake rule returning issues.

**Suggested commit subject:** `06-Add alert issue domain model`

---

## Phase 6.2 — Core rules

**Status:** `pending`

**Goal:** Implement at least **missing FX** and **duplicate suspect** against month-scoped expense lists.

**Acceptance:** Table-driven tests; rules run &lt; 100ms on demo book size.

**Suggested commit subject:** `06-Implement core alert rules`

---

## Phase 6.3 — Recurring / installment rules

**Status:** `pending`

**Goal:** Surface “expected but not confirmed” or “installment due” hints using existing expectation fields.

**Acceptance:** Tests with materialized recurring rows from Phase 4 schema.

**Suggested commit subject:** `06-Add recurring installment alert rules`

---

## Phase 6.4 — UI

**Status:** `pending`

**Goal:** User can see open issues and navigate to relevant month/category.

**Acceptance:** Widget test or golden for Issues section; a11y labels.

**Suggested commit subject:** `06-Add issues dashboard UI`

---

## Phase 6.5 — Dismiss and persistence

**Status:** `pending`

**Goal:** User can dismiss/snooze; state survives restart.

**Acceptance:** Drift or settings persistence tested.

**Suggested commit subject:** `06-Persist dismissed alert keys`

---

## Phase 6.6 (optional) — Notifications

**Status:** `pending`

**Goal:** OS push or weekly digest — only if Phase 5 auth and device tokens exist.

**Acceptance:** Documented feature flag; off by default.

**Suggested commit subject:** `06-Optional push digest for alerts`

---

## Reference

- [`PROJECT_MASTER_PLAN.md`](PROJECT_MASTER_PLAN.md) §6  
- [`06-phase-6-analysis.md`](06-phase-6-analysis.md)  
- [`07-implementation-phase-7-plan.md`](07-implementation-phase-7-plan.md) — next phase  
