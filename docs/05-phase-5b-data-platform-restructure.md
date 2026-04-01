# Phase 5.b — Data platform restructure (analysis and implementation plan)

**Status:** `planned` (execute **before** treating server DDL as final and before **5.4** sync API hardening).  
**Language:** English (project standard).  
**Companion tracker:** [`05-implementation-phase-5-plan.md`](05-implementation-phase-5-plan.md).  
**Normative contract (to revise after 5.b decisions):** [`05-sync-spec.md`](05-sync-spec.md).  
**Product intent:** [`PROJECT_MASTER_PLAN.md`](PROJECT_MASTER_PLAN.md) §5–§6, Phase 5 bullet.

---

## 1. Purpose

Pause between **connecting to SQL Server** and **applying migrations** to align:

- **User ↔ book** modeling on the server (and how it maps to the client).
- **Category taxonomy:** system defaults vs user-created rows (already true on device; formalize for server + seed).
- **Ownership of persistence:** what the **backend** must own vs what stays **local-first** in Flutter.
- **Operational endpoints** (reset + seed) for **development and controlled test** environments only.

This document is the **analysis + ordered implementation plan**. It does **not** change code by itself; it drives subsequent migrations and API work in `expense-app-backend` and coordinated updates in `expense-app`.

---

## 2. Relationship to existing phase plans

| Doc / phase | Relevance |
|-------------|-----------|
| **5.1 / [`05-sync-spec.md`](05-sync-spec.md)** | Already: **one logical book per authenticated `user_id`**, snapshot-first sync, Drift as on-device store after bootstrap. **5.b** refines **how** “book” appears in SQL (implicit vs explicit row) and seed semantics—must stay compatible unless the spec is explicitly amended. |
| **5.3 (done)** | In the **`expense-app-backend`** repository, `ExpenseTracker.Migrations/Scripts/20260401120000_CreateBookSchema.sql` is a **baseline**. **5.b** may add tables/columns or a new migration; treat current DDL as **revocable** until applied to a shared or production environment (a fresh local DB not yet migrated is ideal for restructuring). |
| **5.4 (pending)** | REST sync implementation **depends** on finalized schema + auth story. **5.b** completes first. |
| **5.5 (pending)** | Flutter MSAL + `BookSyncGateway`: consumes whatever 5.4 exposes; local Drift shape may need a migration if server book model changes. |
| **Phases 0–4** (`01`–`04` implementation plans in `docs/`) | Domain, Drift, repositories, backup JSON, seeds **on device** (`category_seed.dart`, `income_category_seed.dart`, etc.). **5.b** defines how that logic **mirrors or moves** for server-side seed and tests—not a rewrite of Phases 0–4 deliverables. |
| **Phase 6** ([`06-implementation-phase-6-plan.md`](06-implementation-phase-6-plan.md)) | Alerts target an **authoritative synced book** after Phase 5; unchanged order. |
| **Phase 8** ([`08-implementation-phase-8-plan.md`](08-implementation-phase-8-plan.md)) | Optional **multi-book / profiles** later; **v1 stays one book per user** per master plan and sync spec. |

---

## 3. Product model (target)

### 3.1 Users and books

- **Identity:** `user_id` from **Entra External ID** (`oid` / `sub` mapping)—unchanged from sync spec.
- **Book:** All categories, subcategories, instruments, series, installments, expenses, and income entries for that user constitute **one book** (v1).
- **Schema options** (pick one in 5.b and document in `05-sync-spec.md` if the choice affects the contract):
  - **A — Implicit book (current DDL style):** No `books` table; every row carries `user_id`; optional `book_revision` / metadata in a small `user_book_metadata` table keyed by `user_id`.
  - **B — Explicit `books` table:** `book_id` + `user_id` (unique per user in v1); foreign keys include `book_id` or remain `(user_id, id)` only—engineering trade-off for Azure SQL and queries.

### 3.2 Categories and subcategories (defaults + customization)

Aligned with [`PROJECT_MASTER_PLAN.md`](PROJECT_MASTER_PLAN.md) §5.1 and §7:

- **Template:** A **versioned taxonomy template** in the repo (data file or code shared by Flutter seed + backend seed)—Excel-derived names, English in DB, **Other** subcategory per category with `is_system_reserved`.
- **Per user:** On **first provisioning** (signup or first sync), the server **materializes** rows for that user from the template; the user may **add** categories/subcategories and **soft-delete/deactivate** user-created rows per existing product rules (`is_active`, etc.).
- **Uncertainty called out:** Whether **default template rows** are copied once (independent rows per user) vs references to global template rows—**recommendation for v1:** **copy-once per user** (simpler isolation, matches current Drift behavior and backup round-trips).

### 3.3 “Reports” in the database

Today, **reports** in Phases 2–4 are **aggregations over expenses/income** in the app (and export CSV), not separate persisted “report tables.” Unless the product owner adds a requirement for **materialized reports** or **server-side reporting tables**, **5.b** should **not** add report-specific tables; server stores **facts** (expenses, income, taxonomy); reports remain **computed** in Flutter or future server endpoints as **read models** over the same tables.

---

## 4. Architecture: backend vs Flutter (clarify “move DB to backend”)

The master plan remains **local-first**: Drift is the **on-device working set**; the server is **durable and multi-device**.

| Concern | Backend (`expense-app-backend`) | Flutter (`expense-app`) |
|---------|--------------------------------|-------------------------|
| **Authoritative persistence for signed-in sync** | Yes: Azure SQL + migrations + repositories | Drift mirrors server after pull / sync |
| **Domain rules** (validation, recurrence expansion, business invariants) | Re-validate on write; optional shared test vectors | Primary implementation today; keep until a shared library or duplicate validation is justified |
| **SQLite / Drift migrations** | No | Yes, for offline and web local DB |
| **JSON backup / export** | Optional: same shape as `BookBackupSnapshot` for API | Source of truth for **import/export file** UX today |
| **Category seed content** | **Source template** for server seed + integration tests | **Current** seed files for offline-first onboarding; must **match** server template after 5.b |
| **UI / Riverpod** | No | Yes |

**Interpretation of “move repositories to backend”:** Implement **server-side data access** (Dapper/EF Core) and **HTTP APIs** for sync, admin seed, and health. Flutter **keeps** repository abstractions that **talk to Drift** locally and to **HTTP** when syncing—not deletion of `lib/data` on day one.

---

## 5. Endpoints: reset DB and repopulate seed

### 5.1 Requirements (from product owner)

- Backend exposes operations to **reset** database state and **repopulate** from seed **reflecting all taxonomy/product rules** after 5.b.

### 5.2 Safety and placement

- **Never** expose unauthenticated reset in production.
- **Recommended tiers:**
  - **Local / CI:** environment flag + optional **shared dev secret** header, or **test-only** `WebApplicationFactory` that calls internal services without HTTP.
  - **Azure Dev:** behind **admin role** or **pipeline identity** only—not public client apps.
- **Prod:** **no** full DB reset endpoint; use **migrations**, **support runbooks**, and **per-user data deletion** (compliance / 5.10) instead.

### 5.3 Behavioral definition (to implement in 5.b/5.4)

- **Reset:** Drop or truncate **application tables** (preserve `schemaversions` if using DbUp, or rerun from clean DB per environment policy); must be **documented** and **idempotent** for dev.
- **Seed:** Apply taxonomy template + optional **demo** expenses/income **only** when explicitly requested (separate from minimal empty book).
- **Tests:** Backend integration test: migrate → seed user A → assert rows → reset → seed user B → no cross-user leakage.

---

## 6. Other considerations (g + i)

1. **`05-sync-spec.md` amendment:** After schema decisions (§3.1–3.2), update §2–§3 if table list or bootstrap order changes.
2. **Backup JSON version:** If server book shape diverges from `BookBackupSnapshot`, bump **`currentSchemaVersion`** and coordinate Flutter + API; prefer **one** canonical DTO for snapshot PUT/GET.
3. **Materialization (recurring):** Today materialized expenses are created **in the app**; for server-authoritative sync, define whether **server** stores only series and **client** materializes, or **server** also materializes—**5.4** design choice; 5.b should leave columns compatible with either (current expense rows already support `recurring_series_id`).
4. **Performance:** Pagination for future list APIs; snapshot size limits per sync spec and **`expense-app-backend`** `.cursor/rules/expense-backend-architecture.md`.
5. **Phase 5 Local MVP gate:** Item 1 (schema + migrations) and item 3 (isolation) must still pass after 5.b DDL changes.

---

## 7. Implementation sequence (ordered)

1. **Decisions (short ADR or checklist in this doc):** Implicit vs explicit book table (§3.1); copy-once taxonomy (§3.2); confirm no report tables unless new requirement.
2. **Single source of truth for taxonomy template:** Extract from Flutter seeds into a **shared artifact** (e.g. JSON in backend repo consumed by tests + seed service; Flutter imports or duplicates with CI check for drift).
3. **Revise SQL migrations** in `expense-app-backend` (new script or alter migration before first apply): `users` linkage if needed beyond `user_id` string, `user_book_metadata`, optional `books`, template version column on book metadata, etc.—**exact DDL in implementation PR**.
4. **Backend domain/services:** `BookProvisioningService` (create empty book + template categories), `DevelopmentDatabaseService` (reset + seed)—behind interfaces.
5. **Endpoints:** `POST /api/dev/reset` + `POST /api/dev/seed` (or single `POST /api/dev/reset-and-seed`) **only** when `IHostEnvironment.IsDevelopment()` or explicit opt-in env—document in backend `README.md`.
6. **Flutter:** Adjust local seed paths only if template is shared; ensure backup/import still round-trip; plan **5.5** sync apply order per updated `05-sync-spec.md` §3.
7. **Re-run** [`05-implementation-phase-5-plan.md`](05-implementation-phase-5-plan.md) **5.3 acceptance** (migrations apply + `EXPENSE_TRACKER_TEST_SQL` isolation) on revised schema.
8. **Close 5.b** in tracker; proceed to **5.4** sync REST contract implementation.

---

## 8. Open questions (resolve during 5.b)

1. Explicit **`books`** row vs metadata-only for `book_revision` / optimistic concurrency?
2. Should **server** run **the same** recurrence **materialization** as Flutter, or only store series until a later phase?
3. **Demo seed** (example year of expenses): available only in dev API or also as optional “Reset demo data” in app for local-only users?

---

## 9. References

- [`05-sync-spec.md`](05-sync-spec.md)  
- [`05-implementation-phase-5-plan.md`](05-implementation-phase-5-plan.md)  
- [`05-azure-hosting-strategy.md`](05-azure-hosting-strategy.md)  
- [`PROJECT_MASTER_PLAN.md`](PROJECT_MASTER_PLAN.md)  
- [`04-implementation-phase-4-plan.md`](04-implementation-phase-4-plan.md)  
- Backend (sibling repo): `expense-app-backend` → `README.md`, `ExpenseTracker.Migrations/`
