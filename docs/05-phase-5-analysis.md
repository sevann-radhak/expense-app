# Phase 5 — Cloud platform, auth, and production (analysis)

**Ordered doc:** **`05-phase-5-analysis.md`** — specification, **code review of Phase 4**, and **strategic analysis** for taking the app from **local-first** to **signed-in multi-device** use with **hosted persistence** and **deployed clients**. **Execution tracker:** [`05-implementation-phase-5-plan.md`](05-implementation-phase-5-plan.md).

**Purpose:** Answer whether a **full production stack** (web + mobile + API + DB + pipelines + stores) is **viable**, what to **use** in each layer, how **Azure vs AWS** compare for your goals, and what **“free”** realistically means—without implementing here.

**Commit prefix for implementation:** **`05-`**

---

## 0. Roadmap alignment (resolved)

[`PROJECT_MASTER_PLAN.md`](PROJECT_MASTER_PLAN.md) §6 is **renumbered** so there is a **single** Phase 5:

| Phase | Scope | Paired docs |
|-------|--------|-------------|
| **5** | **Cloud, identity, sync, production** (this doc) | [`05-implementation-phase-5-plan.md`](05-implementation-phase-5-plan.md) |
| **6** | **Alerts and reconciliation** (former master-plan Phase 5) | [`06-phase-6-analysis.md`](06-phase-6-analysis.md), [`06-implementation-phase-6-plan.md`](06-implementation-phase-6-plan.md) |
| **7** | **Polish and growth** | [`07-phase-7-analysis.md`](07-phase-7-analysis.md), [`07-implementation-phase-7-plan.md`](07-implementation-phase-7-plan.md) |
| **8** | **Extended integrations** (bank import, FX API, etc.) | [`08-phase-8-analysis.md`](08-phase-8-analysis.md), [`08-implementation-phase-8-plan.md`](08-implementation-phase-8-plan.md) |

**Why Phase 5 is cloud first (not alerts first):** Multi-device users need **one authoritative book** and **identity** before investment in **cross-device** alert delivery, server-side schedules, and reconciliation that matches “production” data. Building alerts only on local Drift first risks **duplicate work** when sync changes conflict handling and data shape. Alerts remain **high priority** immediately **after** sync MVP → **Phase 6**.

---

## 1. Phase 4 — retrospective and code review

### 1.1 What Phase 4 delivered (baseline)

- **Recurring expenses:** sealed `RecurrenceRule`, materialized rows, horizon rematerialization, expectation status (confirm / skip / waive / paid early).
- **Income:** parallel taxonomy + entries + recurring income series, cashflow-aware reporting hooks.
- **Payment instruments v2:** active/default, statement/interest metadata, integration with expenses and installments.
- **Installments:** plans linked to card-paid expenses, domain + Drift + form UX.
- **Backup / restore:** book snapshot JSON with versioning; importer handles legacy schema.
- **Presentation:** shell, reports, settings, Phosphor icons, searchable pickers, settlement UX.
- **Quality:** broad `flutter test` coverage; domain kept free of Flutter/SQLite per project rules.

**As-built snapshot (verify in repo):** Drift `schemaVersion` in [`lib/data/local/app_database.dart`](../lib/data/local/app_database.dart); book backup `BookBackupSnapshot.currentSchemaVersion` in [`lib/application/book_backup_snapshot.dart`](../lib/application/book_backup_snapshot.dart). Keep **implementation plan** [`04-implementation-phase-4-plan.md`](04-implementation-phase-4-plan.md) in sync with these numbers when closing phases.

### 1.2 Strengths

- **Clear layering:** `domain/*_repository.dart` interfaces, Drift implementations, Riverpod wiring—matches the master plan’s “swap local for remote behind interfaces.”
- **Serialization boundary:** `book_backup_codec`, DTOs (`expense_api_dto.dart`), and `mock_expense_remote_api.dart` already suggest a **network-shaped** export; extending to a sync payload is natural.
- **Date-only policy** and **local calendar** semantics are consistently documented in domain helpers—critical for sync timestamps and conflict rules.
- **Tests** on recurrence expansion, settlement, reports, backup round-trip reduce regression risk when adding a remote layer.

### 1.3 Improvements worth scheduling (non-blocking)

| Area | Observation | Suggested direction |
|------|-------------|---------------------|
| **Sync seam** | Master plan mentions `SyncGateway`; not yet a first-class interface. | Introduce `abstract class BookSyncGateway` (or split read/write ports) in **domain** or **application**, implemented by `NoOpSyncGateway` until Phase 5. |
| **Repository granularity** | Large `AppDatabase` and many tables. | Keep **monolith DB** on device; for **server**, start with **one Postgres schema per user/book** or `user_id` + RLS—not microservices. |
| **Feature folders** | `presentation/` is flat-ish. | Optional refactor: `lib/presentation/features/expenses/...` when touch frequency justifies it; not urgent. |
| **Partial payments** | Stubbed for 4.8. | Either promote to a small epic after cloud MVP or remove from export surface until defined. |
| **i18n** | Technical debt if new strings accumulate only in EN. | Any **auth** and **sync error** copy should go through ARB from day one of Phase 5. |
| **Secrets** | Future API keys / Supabase URL. | `flutter_dotenv` + `--dart-define` CI pattern; never commit keys (already a global rule). |

### 1.4 Security note (unchanged, still mandatory)

- **No PAN/CVV/PIN**; card **metadata** only. Cloud phase must **not** widen storage to sensitive card data. Encrypt **transit** (TLS) and **at rest** (DB/provider defaults); consider **client-side encryption** for descriptions/amounts only if threat model requires it (adds complexity).

---

## 2. Is “full infrastructure” viable?

**Yes**, with the caveat that **microservices on day one** are usually **not** recommended for a personal expense app until you have **scale or team** pain.

| Layer | Viable? | Notes |
|-------|---------|--------|
| **Flutter web + iOS + Android** | **Yes** | Same codebase; web build hosted as static assets + API calls; mobile via store binaries. |
| **Backend HTTP API** | **Yes** | Prefer **one modular service** (or **BaaS**: Supabase/Firebase) before splitting microservices. |
| **Database** | **Yes** | **Postgres** is the default sweet spot for relational expenses; matches mental model of Drift/SQLite. |
| **CI/CD pipelines** | **Yes** | GitHub Actions (or GitLab CI) for analyze/test/build; deploy web artifact; later **fastlane** for stores. |
| **Multi-environment** | **Yes** | `dev` / `staging` / `prod` with separate DB + API keys; feature flags optional. |
| **Play Store + App Store** | **Yes** | **Costs:** Google one-time fee; Apple **annual** developer program. Review guidelines apply (privacy policy URL, data handling). |
| **Microservices** | **Optional / later** | Justified when teams or domains split (e.g. billing vs analytics). For v1: **monolith API** or **managed BaaS**. |

---

## 3. Recommended stack (concise) — **Azure product lock-in**

| Concern | Recommendation for this repo | Alternatives |
|---------|------------------------------|--------------|
| **Auth** | **Microsoft Entra External ID** (CIAM): **email/password** + **Microsoft** + **Google** social sign-in where free tiers allow | Fewer IdPs on day one |
| **API + DB** | **Azure SQL Database** + **ASP.NET Core** HTTP API in **`expense-app-backend`** (local Kestrel first; deploy to **Azure App Service** or **Functions** later) | Container Apps consumption |
| **Flutter client** | **Riverpod** + `BookSyncGateway` + **MSAL** when auth ships; **Drift** local-first | — |
| **Conflict handling** | **LWW** + `updated_at` (+ optional `source_device_id`); snapshot-first v1 | CRDT only if required later |
| **Web hosting** | **Azure Static Web Apps** (Free SKU while sufficient) | Storage static + CDN |
| **API hosting (Azure)** | **Consumption** Functions or small **App Service** / **Container Apps** | Dedicated plans only if needed |
| **CI/CD** | **GitHub Actions** + optional Azure deploy jobs | Azure DevOps |
| **Secrets** | **Key Vault** + managed identity in Azure; `--dart-define` / CI secrets for Flutter | — |
| **Observability** | **Application Insights** + **Sentry** (Flutter) | OpenTelemetry later |

**Delivery order:** Complete **local MVP** (local SQL + local API + Flutter) before provisioning **Azure Dev** or **Azure Prod** resources—see [`05-implementation-phase-5-plan.md`](05-implementation-phase-5-plan.md) and [`05-azure-hosting-strategy.md`](05-azure-hosting-strategy.md).

**Subscription layout (recommended):** **One** Azure **subscription** for your personal/portfolio work, with **separate resource groups** (e.g. `rg-expense-tracker-dev`, `rg-expense-tracker-prod`, and later `rg-<other-product>-dev`). This keeps **one bill** and **shared budgets**, while **isolating** environments. Use a **second subscription** only when you need hard billing separation (e.g. a paying client contract).

---

## 4. Azure vs AWS (deploy vs publish)

### 4.1 What “deploy” usually means here

- **Deploy backend:** run container or serverless function with a public URL, env vars, scaling policy.
- **Deploy frontend:** upload Flutter **web** build (`build/web`) to a static host or CDN; configure SPA routing.
- **Deploy database:** managed Postgres/MySQL; backups, networking, TLS.
- **Publish mobile:** **binary upload** to Google Play / Apple App Store Connect **after** you already built signed `.aab` / `.ipa`—hosting provider is irrelevant to that step except for **OTA** updates (not typical for Flutter store apps).

### 4.2 Azure vs AWS (high level)

| Topic | **Azure** | **AWS** |
|-------|-----------|---------|
| **Free tier** | Some services always-free (limited); many are **12-month trial** for new accounts. **SQL managed DB** is generally **not** sustainably free for production. | **Free tier** often **12 months** for new accounts; after that pay-as-you-go. **RDS** rarely “free” long term. |
| **Static web** | Static Web Apps (generous free SKU for hobby), Storage static website | S3 + CloudFront, Amplify Hosting |
| **Containers** | Container Apps, App Service | ECS Fargate, App Runner, Lambda |
| **Auth** | Entra ID (overkill for solo app unless you want Microsoft login) | Cognito |
| **DX for solo dev** | Good if you already use Microsoft 365 / Azure credits | Good if you already use AWS; broader examples online |

### 4.3 Can you get DB + backend + frontend connected **for free** in production?

**Honestly: not reliably forever at production quality.**

- **Truly $0 forever** with **durable Postgres + always-on API + custom domain TLS** is rare; providers change limits.
- **Closest to free** for this repo’s **Azure path:** **$0** while everything runs **locally**; after provisioning, target **serverless/consumption** SKUs + **SQL serverless/auto-pause** so a **personal** deployment often lands in a **low tens USD/month** band depending on uptime and tier (use the [pricing calculator](https://azure.microsoft.com/pricing/calculator/)).

**Recommendation:** Keep **local development** until the **local MVP gate** is green; then add **budget alerts** before creating **Azure SQL** or always-on compute.

**If forced to pick Azure vs AWS** for this Flutter + relational-server shape: third-party **BaaS** (e.g. Supabase) can be cheaper for a **single** hobby app. Choose **Azure** when you optimize for **one portfolio**, **SQL Server skills**, **reuse across clients**, and **consistent governance** (budgets, naming, IaC)—as locked for this project in [`05-azure-hosting-strategy.md`](05-azure-hosting-strategy.md).

---

## 5. User journey (MVP)

1. User opens **web URL** or **mobile app** → **Sign up / Sign in**.
2. Server creates **`user_id`** and default **book** (or single book v1).
3. Client pulls **snapshot** or **delta** since `cursor` into **Drift**; app remains **usable offline** (read + queue writes).
4. Sync worker pushes **mutations** with idempotency keys; server validates RLS.
5. Second device logs in → same book converges after sync.

**v1 simplification:** single book per user (aligns with current “single profile” product rule).

---

## 6. Risks and non-goals for Phase 5 MVP

| Risk | Mitigation |
|------|------------|
| Conflict corruption | LWW + audit log or version column; expose “resolve conflict” only if needed |
| Large backup JSON | Move to **paginated sync** or **per-table cursors** early |
| Store rejection | Privacy policy, data deletion, account deletion flow |
| Cost drift | Budget alerts on cloud console; use serverless/static where possible |

**Non-goals for first slice:** full microservices mesh, multi-region HA, bank aggregation, real-time collaborative editing.

---

## 7. References (external patterns)

- [Supabase — Row Level Security](https://supabase.com/docs/guides/auth/row-level-security)
- [Firebase — Authentication](https://firebase.google.com/docs/auth)
- [Flutter — deployment](https://docs.flutter.dev/deployment)
- [OWASP — Mobile Application Security](https://owasp.org/www-project-mobile-security-testing-guide/)

---

## 8. Next step

Use [`05-implementation-phase-5-plan.md`](05-implementation-phase-5-plan.md) for **ordered work packages**, acceptance criteria, and suggested commits. Then [**Phase 6**](06-phase-6-analysis.md) (alerts and reconciliation).

**Sync spec (v1, normative):** [`05-sync-spec.md`](05-sync-spec.md) — entities aligned with Drift + `BookBackupSnapshot`, bootstrap order, conflict/LWW notes, snapshot-first vs deltas, login → pull → Drift.
