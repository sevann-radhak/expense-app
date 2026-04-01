# Phase 5 — cloud, identity, sync, and production (implementation plan)

**Ordered doc:** `[05-implementation-phase-5-plan.md](05-implementation-phase-5-plan.md)` — **execution tracker** for Phase 5. **Product / strategy / review:** `[05-phase-5-analysis.md](05-phase-5-analysis.md)`. **Azure environments & cost habits:** `[05-azure-hosting-strategy.md](05-azure-hosting-strategy.md)`. **Prior phase tracker:** `[04-implementation-phase-4-plan.md](04-implementation-phase-4-plan.md)`.

**Purpose:** Move from **local-only** Drift to **authenticated multi-device** use with **Azure-hosted** persistence, **CI/CD**, and **store-ready** builds—after a **local MVP** is complete on the developer machine.

**Phase 5 status:** `in progress` (**5.1**–**5.3** done; **5.4** next).

**Repositories:** **Flutter** = this repo (`expense-app`). **HTTP API** = separate clone `**expense-app-backend`** (ASP.NET Core, Swagger). On disk, clone both next to each other (e.g. `../expense-app-backend`) and run `dotnet` commands from the API repo root—see its `README.md`.

**Strategic backend (locked):** **Microsoft Azure** — **Azure SQL**, **HTTP API** in `**expense-app-backend`** (deploy to suitable Azure compute later), **Microsoft Entra External ID** for consumers (email/password + Microsoft + Google where enabled). **Flutter:** **MSAL** + sync gateway when auth ships.

**API language:** **C#** / **.NET** (matches product-owner experience; Kestrel locally; economical **consumption** hosting on Azure later).

**Commit prefix:** `**05-`**

---

## Environment model (four names)


| Name           | Where                                                           | Azure bill                    | Use                                                                                                                                                                                     |
| -------------- | --------------------------------------------------------------- | ----------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Local**      | Developer PC                                                    | **$0**                        | Day-to-day implementation: Drift; `**expense-app-backend`** `ExpenseTracker.Api` on localhost (default **[http://localhost:5057](http://localhost:5057)**); optional Docker SQL Server. |
| **Azure Dev**  | Subscription, resource group `rg-expense-tracker-dev` (example) | **Yes** (low SKUs)            | Mirror of prod for integration tests and manual QA — **create only after [Local MVP gate](#local-mvp-gate) passes.**                                                                    |
| **Azure Prod** | Subscription, resource group `rg-expense-tracker-prod`          | **Yes**                       | End-user workloads — **after** Dev smoke + explicit owner approval for recurring cost.                                                                                                  |
| **CI**         | GitHub Actions runners                                          | **$0** for standard OSS usage | `flutter analyze`, `flutter test`, `dotnet build`; no Azure deploy until pipelines are explicitly enabled.                                                                              |


**Subscription (locked recommendation):** **One** Azure subscription for personal/portfolio work; **separate resource groups** per product and per environment (`dev` / `prod`). Add a **second subscription** only for contractual client isolation. Rationale: single invoice, one place for **Cost Management** budgets, less portal friction.

---

## Local MVP gate

**Do not** create **billable** Azure resources (**Azure SQL**, **App Service** / **Functions** in the cloud, **SWA** beyond free tier if it meters) for this app until **all** are true:

1. **Schema:** Versioned **Azure SQL–compatible** schema applied on **local** SQL Server (Docker, LocalDB, or instance); migrations live in repo.
2. **API:** `**expense-app-backend`** exposes the agreed **sync contract** (see `[05-sync-spec.md](05-sync-spec.md)`); `**GET/PUT` book** (or equivalent) works against **local** DB with **test users** (JWT validation can use **dev-only** middleware or test keys documented in that repo).
3. **Isolation:** Second test principal cannot read/write first user’s rows (automated or documented script).
4. **Flutter:** **Web** + one **mobile** target: sign-in flow **or** sync smoke against **localhost API** per interim plan until MSAL is complete; **offline queue** behavior agreed and tested.
5. **Owner:** Explicit “**local MVP complete**” sign-off.

Until then: **Flutter** remains **local-first** (no cloud auth package required); optional `--dart-define=AZURE_API_BASE_URL=http://localhost:…` for early HTTP experiments via `[CloudBackendEnv](../lib/application/cloud_backend_env.dart)`.

---

## Azure provisioning gate (after local MVP)

**Do not** provision **Azure Dev** or **Azure Prod** compute/SQL until **Local MVP gate** passes **and** the product owner approves **spend**.

When approved, order of operations (see `[05-azure-hosting-strategy.md](05-azure-hosting-strategy.md)`):

1. **Budget + alerts** on the subscription.
2. **Azure Dev** resource group + smallest suitable **Azure SQL** + API host + **Entra External ID** app registrations pointing to **dev** URLs.
3. **Smoke test** from Flutter against **Dev**.
4. **Azure Prod** resource group + prod tiers + **Static Web Apps** (or equivalent) for Flutter web.

---

## Phase status legend


| Value         | When to use           |
| ------------- | --------------------- |
| `pending`     | Not started.          |
| `in progress` | Active work.          |
| `done`        | Acceptance satisfied. |
| `review`      | Needs rework pass.    |


---

## Phase overview


| Subphase | Focus                                                                     | Status        |
| -------- | ------------------------------------------------------------------------- | ------------- |
| 5.1      | Product scope: single book per user, `[05-sync-spec.md](05-sync-spec.md)` | `done`        |
| 5.2      | **Local** dev environment: tooling, SQL optional, API skeleton, checklist | `done`        |
| 5.3      | **Azure SQL** schema + migrations (developed & tested **locally** first)  | `done`        |
| 5.4      | Sync **REST** contract + implementation in **ASP.NET Core** API           | `pending`     |
| 5.5      | Flutter: **MSAL** (Entra External ID) + `BookSyncGateway` / offline queue | `pending`     |
| 5.6      | Provision **Azure Dev** + wire CI deploy (optional)                       | `pending`     |
| 5.7      | **Azure Prod**, **Static Web Apps**, TLS, CORS                            | `pending`     |
| 5.8      | **CI/CD**: GitHub Actions (`flutter` + `dotnet`)                          | `pending`     |
| 5.9      | Mobile release track (internal testing)                                   | `pending`     |
| 5.10     | Compliance: privacy policy, account deletion path                         | `pending`     |
| 5.11     | Observability: Application Insights, Sentry, budgets                      | `pending`     |


**Next:** [Phase 6 — Alerts](06-implementation-phase-6-plan.md) starts after Phase 5 **local MVP gate** is satisfied (sync + identity path stable).

---

## Prerequisite decisions

1. **Backend:** Azure SQL + C# API + Entra External ID — documented above.
2. **Sync algorithm v1:** **LWW** + **snapshot-first** per `[05-sync-spec.md](05-sync-spec.md)` §4–§5.
3. **Offline scope:** As in sync spec; Drift remains on-device source of truth during edits.
4. **Identity providers:** **Email/password** + **Microsoft** + **Google** in External ID when product pricing allows; verify current **MAU** free tier before enabling extras.

**Locked by 5.1:** **One book per `user_id` in v1**; entity set = Drift book tables + `BookBackupSnapshot` keys (+ optional user prefs per sync spec §2.8).

---

## Phase 5.1 — Product scope and sync spec

**Status:** `done`

**As-built:** `[05-sync-spec.md](05-sync-spec.md)`

**Suggested commit subject:** `05-Document sync spec and book scope`

---

## Phase 5.2 — Local development environment

**Status:** `done` (verified **2026-04-01** on Windows: `dotnet` + `flutter` CLI)

**Goal:** Every contributor can run **Flutter** + **local API** on one machine with **documented** steps; **no** Azure compute/SQL required.

**Checklist (acceptance):**

- [x] **.NET SDK** installed; in **expense-app-backend**: `dotnet build ExpenseTracker.sln -c Release` succeeds (0 warnings in last verification run).
- [x] **API run:** `dotnet run --project ExpenseTracker.Api` → **Swagger UI** at `/swagger` loads; **GET /api/health** returns JSON `status` **ok**; **GET /api/hello** returns `message` (see that repo’s `README.md`).
- [x] **Flutter:** `flutter pub get`, `flutter analyze`, `flutter test` green (same verification run).
- [x] **`flutter doctor`:** **[√] Flutter** and **Chrome** (web) sufficient for Phase 5 local work per [`PROJECT_MASTER_PLAN.md`](PROJECT_MASTER_PLAN.md) web-first order; **Android SDK** / **Windows desktop C++** workloads are optional until mobile/native-desktop release work (e.g. 5.5 / 5.9). Address those toolchains when you target those platforms.
- [x] **Optional SQL:** Documented in **expense-app-backend** `README.md`: **SQL Server Express** on Windows (step-by-step), plus Docker and LocalDB alternatives; **no** secrets in git. Store real connection strings in **`dotnet user-secrets`** or a **gitignored** local file.
- [ ] **Optional:** Install **Azure Functions Core Tools** only if you migrate the host to Functions (`dotnet new func` requires the Functions worker template). Not required for the current Kestrel API.
- [x] **Docs:** This checklist checked off when 5.2 closed.

**Code anchors:** **expense-app-backend** / `ExpenseTracker.Api`; this repo → [`lib/application/cloud_backend_env.dart`](../lib/application/cloud_backend_env.dart).

**Suggested commit subject:** `05-Add local backend skeleton and dev checklist`

---

## Phase 5.3 — Server schema and authorization

**Status:** `done`

**Goal:** **Azure SQL** schema; **per-user** isolation (API enforces `user_id` from validated JWT in **5.4**; schema uses composite keys `(user_id, id)` and FKs scoped by `user_id`).

**Local engine (documented):** **SQL Server Express** on Windows for first-time setup; same steps work with **Developer** edition. Alternatives: Docker SQL Server image or **LocalDB**. Full walkthrough: **expense-app-backend** [`README.md`](../../expense-app-backend/README.md) section *Local database (Phase 5.3+)*.

**As-built (backend repo):**

- `ExpenseTracker.Migrations/Scripts/` — versioned T-SQL (DbUp journal: `dbo.schemaversions`).
- `ExpenseTracker.DbMigrate` — `dotnet run --project ExpenseTracker.DbMigrate` (+ connection string; see README).
- `ExpenseTracker.Migrations.Tests` — embedded-script smoke test always runs; set `EXPENSE_TRACKER_TEST_SQL` to run tenant isolation check against a real SQL instance.

**Steps completed:** Initial book DDL aligned with [`05-sync-spec.md`](05-sync-spec.md) entity list + `user_preferences` (sync spec §2.8 recommendation A); `updated_at_utc` on book tables for future LWW. **Entra** `oid` / `sub` → `user_id` string at API layer in **5.4**.

**Acceptance:** Schema supports per-user isolation; optional integration test with `EXPENSE_TRACKER_TEST_SQL` validates `user_id` filtering. **API-level** cross-tenant denial is required for [Local MVP gate](#local-mvp-gate) item 3 and is implemented with JWT in **5.4**.

**Suggested commit subject:** `05-Add Azure SQL schema and migrations`

---

## Phase 5.4 — Sync API

**Status:** `pending`

**Goal:** Implement REST endpoints aligned with `[05-sync-spec.md](05-sync-spec.md)`; idempotent writes; JWT validation on routes.

**Acceptance:** Contract tests against **local** API + DB; two-device scenario documented or automated.

**Suggested commit subject:** `05-Implement book sync API`

---

## Phase 5.5 — Flutter: MSAL + sync integration

**Status:** `pending`

**Goal:** **Entra External ID** sign-in (email + Microsoft + Google as configured); `**authSessionProvider`** emits real users; `**BookSyncGateway**`; offline queue.

**Acceptance:** Airplane-mode edit → reconnect → no duplicate ids; `currentAuthUserIdProvider` wired for sync.

**Suggested commit subject:** `05-Add MSAL and Drift sync gateway`

---

## Phase 5.6 — Azure Dev environment

**Status:** `pending`

**Goal:** Resource group **dev**, **Azure SQL** (lowest suitable SKU), API published, Entra apps updated with dev redirect URIs.

**Gate:** [Azure provisioning gate](#azure-provisioning-gate-after-local-mvp)

**Suggested commit subject:** `05-Provision Azure Dev environment`

---

## Phase 5.7 — Azure Prod + web hosting

**Status:** `pending`

**Goal:** **Prod** RG; **Static Web Apps** (or chosen host); TLS; CORS; Flutter `build/web` deploy pipeline documented.

**Suggested commit subject:** `05-Deploy web to Azure prod`

---

## Phase 5.8 — CI/CD pipelines

**Status:** `pending`

**Goal:** PR: `flutter analyze`, `flutter test`, `dotnet build`. Optional: deploy to **Azure Dev** with secrets.

**Suggested commit subject:** `05-Add CI for Flutter and API`

---

## Phase 5.9 — Mobile store track

**Status:** `pending`

**Goal:** Internal testing on Play + TestFlight; login + sync smoke against **Dev** or **Prod**.

**Suggested commit subject:** `05-Configure mobile internal distribution`

---

## Phase 5.10 — Compliance and store metadata

**Status:** `pending`

**Goal:** Privacy policy URL; account deletion story; store listing drafts.

**Suggested commit subject:** `05-Add privacy policy and store draft`

---

## Phase 5.11 — Observability and cost controls

**Status:** `pending`

**Goal:** Application Insights, Sentry (Flutter), **budget alerts** on subscription.

**Suggested commit subject:** `05-Add observability and budget alerts`

---

## Reference

- `[PROJECT_MASTER_PLAN.md](PROJECT_MASTER_PLAN.md)` §6  
- `[05-azure-hosting-strategy.md](05-azure-hosting-strategy.md)`  
- `[05-sync-spec.md](05-sync-spec.md)`  
- `[05-phase-5-analysis.md](05-phase-5-analysis.md)`  
- `[06-implementation-phase-6-plan.md](06-implementation-phase-6-plan.md)` / `[06-phase-6-analysis.md](06-phase-6-analysis.md)`  
- `.cursor/rules/expense-app-project-context.md`  
- `[04-implementation-phase-4-plan.md](04-implementation-phase-4-plan.md)`

