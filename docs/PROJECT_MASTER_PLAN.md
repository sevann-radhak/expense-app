# Personal Expense Tracker — Master Plan

This document is the **single source of truth** for product intent, phased delivery, technical direction, and parity with the legacy Excel workbook (`docs/Plantilla 2025.xlsx`). Use it together with `docs/Plantilla-2025-agent-prompt.mdc` (OOXML-level spec of the spreadsheet).

**Audience:** You (product owner) and the implementation agent.  
**Language:** English (app UI strings start English; architecture supports additional locales later).

---

## 1. Vision

Replace per-year Excel files with a **unified web + mobile application** for personal expense tracking: monthly and annual views, categories, FX-aware amounts, reports, and progressive feature depth (recurring charges, installments, alerts, future income). **Local-first** remains the on-device UX; **Phase 5** adds **optional signed-in sync and production hosting** behind repository/sync interfaces (see [`05-phase-5-analysis.md`](05-phase-5-analysis.md)).

### Platform delivery order (decided)

**Web first:** ship and harden the **web** target (responsive PWA-style) through the planned web scope for each phase; **then** add and polish **iOS/Android** builds using the same Flutter codebase. Phase 0–2 acceptance runs primarily in **desktop/mobile browsers**; native shells follow once web UX and data path are stable.

---

## 2. Recommended technology stack

**Primary recommendation: Flutter (Dart), single codebase**

| Criterion | Rationale |
|-----------|-----------|
| Mobile + Web | One codebase for iOS, Android, and Web (PWA-style deployment possible). |
| UI/UX | Rich animations, Material 3, strong chart packages (e.g. `fl_chart`). |
| Local data | Mature options: **Drift** (SQLite, relational, migrations) or **Isar** (NoSQL, fast). Prefer **Drift** for relational expenses + joins. |
| i18n | `flutter_localizations` + ARB files; locale from user settings. |
| State | **Riverpod** or **Bloc**; pick one project-wide. |
| DI | `riverpod` providers or `get_it` + interfaces. |

**Second option:** **TypeScript** with **Expo (React Native)** for mobile and **React** (or **Next.js**) for web — two codebases or shared UI via Tamagui; more ecosystem fragmentation for “one team, one product.”

**Not recommended as default:** pure native split (Swift + Kotlin + separate web) for a solo/small team unless you have platform-specific constraints.

**Persistence (Phase 1):** SQLite via **Drift** where available; on **web**, use Drift’s **Web** WASM/SQL.js strategy (or documented fallback) so local-first works in the browser. Versioned migrations. **Export:** JSON or CSV for backup; no mandatory account.

**Persistence (future):** Abstract `ExpenseRepository`, `SettingsRepository`, `SyncGateway` behind interfaces; add remote implementation without rewriting domain logic.

---

## 3. Non-functional goals

- **Clean architecture:** Domain (entities, use cases) independent of Flutter/UI and DB drivers.
- **Testability:** Unit tests for domain and use cases; widget/integration tests for critical flows.
- **Privacy:** No card PAN/CVV; only **metadata** (issuer label, fees, billing cycles).
- **Accessibility:** Semantic labels, contrast, large text support.
- **Performance:** Smooth lists (pagination/virtualization), async I/O off UI isolate.

---

## 4. Parity with Excel (progressive)

| Excel concept | App mapping (conceptual) |
|---------------|---------------------------|
| Sheet per month | **Logical month** views over a single `expenses` store (filter by `occurred_on` month). |
| Table columns | `Expense` fields: category, subcategory, date, detail, local amount, FX rate, USD equivalent, paid with credit card flag, optional `paymentInstrumentId`. |
| `Tipo de Gastos` | **Category** / **Subcategory** CRUD + system subcategory **Other** per category. |
| `Categorías` + `INDIRECT` | Subcategory picker filtered by selected category (same as validation logic). |
| `Reporte` totals / checks | **Monthly/annual aggregations** + **reconciliation rules** (e.g. sum consistency, anomaly flags). |
| `Sheet1`-style block | Optional **secondary “manual FX sheet”** or unified: one global “default FX of the day” with per-expense override. |

Full parity (every Excel edge case) is **not** required in Phase 1; track gaps in a `PARITY_CHECKLIST.md` as you implement.

---

## 5. Domain capabilities (summary)

### 5.1 Categories and subcategories

- User CRUD for categories and subcategories.
- Each category has a **non-deletable** reserved subcategory **Other** (localized label via i18n).
- **Seed data:** Initialize from Excel taxonomy (see `docs/Plantilla-2025-agent-prompt.mdc` / defined names: Formación, Gastos_Fijos, Impuestos, Inversiones, Ocio, Salud, Transporte, Vivienda, etc.) on first launch or via “Reset demo categories” (explicit action).

### 5.2 Expense (transaction)

- `categoryId`, `subcategoryId` (must belong to category; **Other** allowed).
- `occurredOn` (**decided: calendar date only, no time-of-day**). Store as a **date-only** value (e.g. ISO `YYYY-MM-DD` string, or a `DateTime` normalized to UTC noon **only as an implementation detail** — never expose time in UI). Filtering by month uses the user’s **local calendar** interpretation of that date.
- `detail` (description).
- `paidWithCreditCard` (bool).
- `localAmount` (decimal, precision per currency rules).
- `fxRateToUsd` (optional; manual Phase 1; later from API).
- `amountUsd` (computed: `localAmount / fxRateToUsd` when rate present; or store both for audit).
- Optional: `paymentInstrumentId` (credit card profile), `notes`, `attachments` (future).

### 5.3 User configuration (future-proof)

Stored per user profile (single local “profile” until auth exists):

- `locale` (default `en`).
- `defaultCurrency` (default **ARS**).
- **Credit card profiles:** label, issuer/bank name, annual fee, monthly fee, percentage fees (e.g. foreign transaction), billing cycle day, currency — **no** full card numbers.
- **Default payment instrument** when `paidWithCreditCard` is true.
- Optional: theme, first day of week, fiscal year start month.

### 5.4 Installments and scheduled payments

- **Installment plan** entity: total principal, start date, number of payments, frequency, linked category/subcategory, optional link to card profile.
- Generate **planned occurrences** (virtual schedule) and optionally **materialize** expense rows per period or link one expense to a plan.
- **University-style tuition:** same model with irregular schedules supported later (custom dates list).

### 5.5 Fixed / recurring expenses

- **Recurring rule:** frequency (monthly, weekly), **fixed amount** vs **variable** (user enters amount each period or last amount suggested).
- **Next due date** + optional **reminder** integration with alerts (Phase 3+).
- Examples: rent, HOA, utilities, accountant, taxes.

### 5.6 Alerts and data quality

- **Types:** overspend vs budget (when budgets exist), missing FX when USD report requested, duplicate-suspect (same amount + day + merchant), recurring missed, installment due.
- **Severity:** info, warning, error.
- **Presentation:** in-app banner/list; no push until OS permissions phase.

### 5.7 Income (future)

- Reserve **Income** aggregate and **net cashflow** report hooks in architecture; no mandatory UI in early phases.

---

## 6. Phased roadmap

### Phase 0 — Foundation (week 0–1)

- Repo scaffold (Flutter + lint + CI skeleton).
- Core folders: `domain/`, `data/`, `application/` or `features/`.
- Drift setup (including **web** persistence path), first migration (empty or categories only).
- i18n pipeline (EN only), settings model stub.
- **Layout:** responsive **web** shell (breakpoints, no mobile-only assumptions).
- **Deliverable:** runnable **web** app, navigation skeleton, master plan linked from README.

### Phase 1 — MVP data + categories + expenses

- Category/subcategory entities, **Other** enforcement, seed import.
- Expense CRUD, list by month, validation (subcategory belongs to category).
- Fields: date, detail, paidWithCreditCard, local amount, manual FX, computed USD.
- **Deliverable:** user can replicate “one month sheet” behavior digitally.

### Phase 2 — Reports and charts

- Monthly report: total spent, by category/subcategory %, max single expense, count.
- Annual report: YoY-style totals, monthly breakdown chart.
- Basic charts (pie/bar), export month CSV.
- **Deliverable:** Excel `Reporte` partial parity.

### Phase 3 — Configuration depth

- Settings UI: language, currency, credit card profiles, default card.
- Wire `paidWithCreditCard` to default instrument suggestion.
- **Deliverable:** configurable metadata matching your Excel-side “control” ideas.

### Phase 4 — Recurring + installments

- Recurring rules engine (generation + edit/delete series).
- Installment plans + schedule view.
- **Deliverable:** university and card fee scenarios covered at basic level.

### Phase 5 — Cloud, identity, sync, and production

- **Identity:** **Microsoft Entra External ID** (email/password + social as configured); single book per user (v1).
- **Sync:** **Azure SQL** + **ASP.NET Core** API (repo **`expense-app-backend`**); Drift as local cache; **local MVP** on the developer machine **before** **Azure Dev** / **Azure Prod** resources; CI/CD; web + mobile deploy paths.
- **Deliverable:** user can use the app from **web (URL)** and **mobile**, with data tied to an account and **durable** on the server.  
- **Docs:** [`05-phase-5-analysis.md`](05-phase-5-analysis.md), [`05-implementation-phase-5-plan.md`](05-implementation-phase-5-plan.md), [`05-azure-hosting-strategy.md`](05-azure-hosting-strategy.md) (**local** → **Azure Dev** → **Azure Prod**, subscription layout, gates before billable resources).

### Phase 6 — Alerts and reconciliation

- Rule engine for anomalies and consistency checks (missing FX, duplicate suspects, recurring/installment signals, sum checks where applicable).
- Dashboard **issues** section; optional push later once accounts and OS permissions exist.
- **Deliverable:** Excel-style “Ok / Error sumas” style feedback where applicable.  
- **Rationale for order:** runs **after Phase 5** so rules target one **authoritative synced book** and optional server-side scheduling; avoids building alert logic twice (local-only then cloud).  
- **Docs:** [`06-phase-6-analysis.md`](06-phase-6-analysis.md), [`06-implementation-phase-6-plan.md`](06-implementation-phase-6-plan.md).

### Phase 7 — Polish and growth

- Animations, empty states, onboarding, accessibility pass.
- **Deliverable:** product feels **finished** for mainstream use on web and mobile.  
- **Docs:** [`07-phase-7-analysis.md`](07-phase-7-analysis.md), [`07-implementation-phase-7-plan.md`](07-implementation-phase-7-plan.md).

### Phase 8 — Extended integrations (later)

- Optional: bank statement import, FX quote provider, encrypted cloud backup extras, multi-book / profiles if the product owner requests.
- **Deliverable:** deeper automation and external data—only after Phases 5–7 are stable.  
- **Docs:** [`08-phase-8-analysis.md`](08-phase-8-analysis.md), [`08-implementation-phase-8-plan.md`](08-implementation-phase-8-plan.md).

---

## 7. Seed categories (from Excel taxonomy)

Use as **initial seed** (exact labels can be English in DB; display via i18n if desired):

- **Formación** — education/training subcategories  
- **Gastos_Fijos** — fixed-like items as subcategories  
- **Impuestos**  
- **Inversiones**  
- **Ocio**  
- **Salud**  
- **Transporte**  
- **Vivienda**  

Each gets user subcategories from the spreadsheet matrix plus **Other**.

---

## 8. Product decisions (resolved + profiles explained)

| Topic | Decision |
|-------|-----------|
| **Expense date** | **Calendar date only** — no clock time. |
| **Platform order** | **Web first**; mobile (iOS/Android) after web is in good shape for the same phase scope. |
| **Profiles (see below)** | **v1 = single dataset** (one “books” per install/browser storage). Optional `profileId` in schema later only if product asks for split books. |

### What “single profile vs household / several profiles” meant

- **Single profile (what v1 is):** Like **one Excel file**: one set of categories, expenses, and settings. Everyone using that browser/device shares the same data unless you later add accounts/sync.
- **Several profiles:** The same app would let you switch **“Personal” / “Shared home” / “Other”** with **separate** expenses and categories — useful if two people share one phone but want isolated books.

**You did not have to choose a complicated option:** we default to **one book** for v1. If you later want **split profiles**, say so and we add a profile switcher + scoped data.

---

## 9. Related files

- `docs/Plantilla-2025-agent-prompt.mdc` — Excel structure and formulas reference.  
- `docs/Plantilla 2025.xlsx` — original workbook file.  
- `docs/02-implementation-phase-2-plan.md` — Phase 2 execution tracker (reports, export).  
- `docs/03-implementation-phase-3-plan.md` — Phase 3 execution tracker (settings, demo data, configuration depth).  
- `docs/04-implementation-phase-4-plan.md` — Phase 4 execution tracker (recurrence, income, installments).  
- `docs/05-phase-5-analysis.md` / `docs/05-implementation-phase-5-plan.md` / `docs/05-azure-hosting-strategy.md` — Phase 5 (cloud, auth, sync, production, Azure strategy).  
- `docs/06-phase-6-analysis.md` / `docs/06-implementation-phase-6-plan.md` — Phase 6 (alerts, reconciliation).  
- `docs/07-phase-7-analysis.md` / `docs/07-implementation-phase-7-plan.md` — Phase 7 (polish, onboarding, a11y).  
- `docs/08-phase-8-analysis.md` / `docs/08-implementation-phase-8-plan.md` — Phase 8 (integrations, later).  
- `.cursor/rules/expense-app-*.md` — Agent implementation constraints (Markdown + YAML frontmatter; Cursor treats `.md` and `.mdc` in this folder).
