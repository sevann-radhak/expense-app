# Sync specification — Phase 5 v1 (document only)

**Status:** Normative for Phase 5 implementation. **Scope:** One **book** per authenticated **user** in v1 (aligned with [`PROJECT_MASTER_PLAN.md`](PROJECT_MASTER_PLAN.md) §6 and [`05-phase-5-analysis.md`](05-phase-5-analysis.md) §5). **Non-goals here:** concrete SQL, RPC names, or Flutter commits — those belong to subphases 5.3–5.5. **Restructure / deeper data design:** [`05-phase-5b-data-platform-restructure.md`](05-phase-5b-data-platform-restructure.md) may amend this document after decisions (book row, seed, boundaries).

**Code anchors (as-built):**

- Drift tables: [`lib/data/local/app_database.dart`](../lib/data/local/app_database.dart) — `schemaVersion` **16**.
- Export shape: [`lib/application/book_backup_snapshot.dart`](../lib/application/book_backup_snapshot.dart) — JSON `schemaVersion` **9** via [`lib/application/book_backup_codec.dart`](../lib/application/book_backup_codec.dart).
- Server DDL (separate repo): `expense-app-backend` → `ExpenseTracker.Migrations/Scripts/` — book tables + `user_id` + `user_preferences`; applied via `ExpenseTracker.DbMigrate` (see that repo’s `README.md`).

---

## 1. Product scope (v1)

| Rule | Detail |
|------|--------|
| Books | **Exactly one logical book per `user_id`.** No multi-book UI or server model in v1. |
| Identity | All remote rows are scoped by authenticated user (e.g. Entra External ID `oid` / JWT `sub` mapped to `user_id`). |
| Local-first UX | After bootstrap, the app keeps **Drift as on-device store**; sync reconciles with the server (see §6). |

---

## 2. Entities and tables in sync v1

Synchronize **book data** that is already modeled in Drift and exported in `BookBackupSnapshot`. Use **stable string primary keys** (`id`) as the global identity for each row across devices.

### 2.1 Taxonomy — expenses

| Drift table | Domain / notes |
|-------------|----------------|
| `categories` | Expense categories (`CategoryRow`). |
| `subcategories` | Expense subcategories; FK `category_id` → `categories.id`. System **Other** rows (`is_system_reserved`) must remain non-deletable per product rules. |

### 2.2 Taxonomy — income

| Drift table | Domain / notes |
|-------------|----------------|
| `income_categories` | Income categories. |
| `income_subcategories` | FK `category_id` → `income_categories.id`. |

### 2.3 Payment instruments

| Drift table | Domain / notes |
|-------------|----------------|
| `payment_instruments` | Card/wallet **metadata only** (no PAN/CVV/PIN). Includes v2 fields: `is_active`, `is_default`, statement/due days, APR, limit, `display_suffix`. |

### 2.4 Recurring series

| Drift table | Domain / notes |
|-------------|----------------|
| `expense_recurring_series` | `recurrence_json`, anchors, amounts, FKs to expense taxonomy / optional `payment_instrument_id`. Dart table class: `RecExpenseSeries` with explicit `tableName` → `expense_recurring_series`. |
| `income_recurring_series` | Same pattern for income taxonomy. Dart: `IncomeRecSeries` → `income_recurring_series`. |

### 2.5 Installments

| Drift table | Domain / notes |
|-------------|----------------|
| `installment_plans` | Plan definition; FKs to expense taxonomy and optional `payment_instrument_id`. |

### 2.6 Transactions

| Drift table | Domain / notes |
|-------------|----------------|
| `expenses` | Includes `recurring_series_id`, `installment_plan_id` / `installment_index`, `payment_expectation_*`, `payment_instrument_id`. |
| `income_entries` | Includes `recurring_series_id`, `expectation_*`. |

### 2.7 Placeholder / not materialized in Phase 4

| Area | Notes |
|------|--------|
| `partial_payments` | `BookBackupSnapshot.partialPayments` is reserved; export uses an empty list today. Include in **payload contract** for forward compatibility; server may accept `[]` until the feature is defined. |

### 2.8 Client preferences (not in `BookBackupSnapshot` today)

| Storage | Contents |
|---------|----------|
| `SharedPreferences` via [`AppUserSettingsStorage`](../lib/data/local/app_user_settings_storage.dart) | `locale` language code, `default_currency_code`. |
| `SharedPreferences` | Last-used `payment_instrument_id` hint for forms. |

**v1 sync decision (to implement in 5.3–5.5):** Either (A) extend the book snapshot / server schema with a small **user_preferences** document keys matching the above, or (B) keep prefs **device-local** until v2. **Recommendation:** (A) so multi-device behavior matches user expectations for language and default currency.

---

## 3. Bootstrap order (load into Drift)

Apply server data in **dependency order** so FKs exist before dependent rows. Recommended **insert/replace** sequence:

1. `payment_instruments` (referenced by expenses, series, plans).
2. `categories` → `subcategories`.
3. `income_categories` → `income_subcategories`.
4. `expense_recurring_series` and `income_recurring_series`.
5. `installment_plans`.
6. `expenses`.
7. `income_entries`.
8. **User preferences** (if syncing): apply after book load.

** Deletes / tombstones:** v1 snapshot exchange can **replace the full book** for the user (see §5), avoiding per-row tombstone logic. If moving to incremental sync later, add **`deleted_at`** or tombstone records per table.

---

## 4. Conflict and versioning policy

| Layer | v1 recommendation |
|-------|-------------------|
| **Primary strategy** | **Last-write-wins (LWW)** on a per-row basis using a monotonic **`updated_at`** (UTC, server-set or trusted client clock per provider conventions). Optional **`source_device_id`** for audit (see [`05-phase-5-analysis.md`](05-phase-5-analysis.md) §3). |
| **Snapshot PUT** | If v1 ships **full snapshot upload/download**, use optimistic concurrency: client sends **`book_revision`** (integer) or **`snapshot_version`**; server rejects stale writes with a conflict code so the client can **pull then merge or retry**. |
| **Tie-break** | If two writes share the same `updated_at`, prefer **higher `book_revision`** or deterministic **id lexicographic** tie-break — pick one rule in the API doc (5.4) and test it. |
| **Domain dates** | Business fields stay **calendar-date-only** (`occurred_on`, `received_on`, etc.); do not use local `DateTime` with time-of-day for sync ordering of those fields. |

**Note:** Full **CRDT** / real-time collaborative editing is **out of scope** for Phase 5 MVP ([`05-phase-5-analysis.md`](05-phase-5-analysis.md) §6).

---

## 5. Sync algorithm — v1 direction

[`05-phase-5-analysis.md`](05-phase-5-analysis.md) §3 compares hosted options; this product uses **Azure SQL** + a first-party HTTP API + **Entra** for identity. **Snapshot vs delta** remains an engineering choice (see below).

| Approach | v1 fit |
|----------|--------|
| **Snapshot-first** | **Recommended for first shippable sync:** one payload shape aligned with `BookBackupSnapshot` (+ prefs). Matches existing backup round-trip tests and reduces row-level sync bugs. |
| **Per-table deltas** | Defer to **v1.1+** when book size or latency requires pagination / cursors (see analysis §6 “Large backup JSON”). |

Implementation subphase **5.4** should lock the **HTTP REST** contract; this spec only requires **compatibility** with the entity list above and the bootstrap order.

---

## 6. Flow: login → pull → Drift

High-level sequence for a cold start after successful authentication:

1. **Authenticate** — Obtain session + stable **`user_id`** (e.g. JWT `sub`).
2. **Resolve book** — v1: implicit single book for `user_id` (no book picker). Server may store `books` with one row per user or embed ownership on all tables.
3. **Pull** — Download current book representation (full snapshot v1.0). If `book_revision` / `If-Match` indicates no change, skip replace.
4. **Transactional apply** — Inside a single Drift transaction: **delete or overwrite** existing book tables for this user’s local DB (v1 local DB remains single-tenant) **or** clear-all then insert in §3 order. Prefer **replace** strategy documented in 5.5 to avoid orphan rows.
5. **Apply preferences** — If syncing prefs, persist to `SharedPreferences` (or migrate prefs into Drift later).
6. **Present UI** — Navigate to app shell; background worker may **push** pending local changes if offline edits occurred before login (edge case: define whether pre-login local data merges or is discarded — **default:** prompt once or backup file before replace).

**Logout (optional v1 behavior):** Documented in 5.5 — wipe local Drift + prefs toggle vs keep offline cache; must not leak another user’s data on shared device.

---

## 7. References

- [`05-phase-5-analysis.md`](05-phase-5-analysis.md) — stack, risks, journey.
- [`05-implementation-phase-5-plan.md`](05-implementation-phase-5-plan.md) — subphases 5.2–5.5 execution.
- [`04-implementation-phase-4-plan.md`](04-implementation-phase-4-plan.md) — Phase 4 data scope closed; **verify** backup `schemaVersion` in repo if docs drift from code.
