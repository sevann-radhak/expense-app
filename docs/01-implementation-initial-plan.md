# Initial implementation plan — expense app

**Ordered doc:** This file is **`01-`** in the `docs/` implementation-plan series. Add future plans with a **zero-padded** numeric prefix (e.g. `02-…`, `03-…`) so they sort consistently. **Phase 2** in this repo uses **two** `02-` files (spec + tracker) with distinct slugs — see **Next docs** below. For new docs in this series, start from [`docs/_templates/implementation-plan-template.md`](_templates/implementation-plan-template.md).

Progressive, test-after-each-phase workflow aligned with `docs/PROJECT_MASTER_PLAN.md` (Phase 0 → Phase 1). Technical stack: **Flutter**, **Drift**, **Riverpod**, **web first**.

**How to use this file:** Complete phases in order. Set **`Status:`** to **`in progress`** while the phase is actively being implemented (you or the agent). When **Acceptance** is satisfied, set **`done`**. Use **`review`** only if work was already considered complete but needs follow-up adjustments, fixes, or another implementation pass — not as a default “waiting for checks” state. Use **Suggested commit subject** (imperative mood, English, ≤8 words).

**Next docs in this series (Phase 2):** [`02-reports-and-foundations-phase-2.md`](02-reports-and-foundations-phase-2.md) (product/spec and foundations); [`02-implementation-phase-2-plan.md`](02-implementation-phase-2-plan.md) (step tracker and as-built).

---

## Recap — what exists in the repo today (end of Phase 1 scope)

This section cross-checks **`docs/PROJECT_MASTER_PLAN.md`** §6 Phase 0–1 against the codebase. It is the **as-built** summary; phase tables below remain the historical checklist.

### Phase 0 (foundation)

- Flutter **web** target, lints, layered **`lib/`** (`domain` / `data` / `presentation`), **Drift** with **WASM** web options, **i18n** (English ARB + codegen), **responsive shell** (`NavigationRail` / `NavigationBar` via breakpoint), **go_router** `StatefulShellRoute` with **Home** and **Settings** stubs completed as planned; README documents run and codegen.

### Phase 1 (MVP data + categories + expenses) — delivered

- **Categories / subcategories:** Drift tables, domain + repository, **Other** reserved subcategory enforced in domain (`ReservedSubcategoryException`), seed taxonomy from project seed data (`category_seed.dart`), English-oriented labels with i18n where applicable.
- **Expenses:** Date-only **`occurredOn`** (`YYYY-MM-DD`), `amountOriginal`, **`currencyCode`**, **`manualFxRateToUsd`**, computed **`amountUsd`**, `paidWithCreditCard`, `description`; validation that subcategory belongs to category.
- **Home UI:** Month-scoped expense list, **per-currency month totals** (chips) plus **USD** summary, **FAB** create/edit expense dialog, **currency-aware formatting** (`currency_display.dart`).
- **FX helpers:** **Default FX catalog** loaded from **`assets/data/default_fx_rates.json`** with presets in the expense form; user can override per expense.
- **Navigation extension (within Phase 1 product scope):** **Categories** is a **first-class shell destination** (`/categories`) — same pattern as Home and Settings — with **`CategoriesScreen`** listing expandable category cards (no longer embedded at the bottom of Home). Order: **Home → Categories → Settings**.
- **Persistence:** Schema evolved to **version 5** (see `lib/data/local/app_database.dart`); migrations and seeding wired in `AppDatabase`.
- **Tests:** Analyzer-clean project; widget tests cover shell navigation and categories list smoke; additional unit tests (e.g. currency display) as added in repo.

### Known UX / product gaps (intentionally deferred)

- **Internal IDs visible:** Categories screen still surfaces stable keys such as `cat_*` / slug-like identifiers for debugging — **to be replaced** by optional descriptions and color identity per [`02-reports-and-foundations-phase-2.md`](02-reports-and-foundations-phase-2.md).
- **Reports, charts, export:** Not in Phase 1; mapped to **Phase 2** in the master plan and detailed in [`02-reports-and-foundations-phase-2.md`](02-reports-and-foundations-phase-2.md) (tracker: [`02-implementation-phase-2-plan.md`](02-implementation-phase-2-plan.md)).
- **Realized vs future-dated “projected” expenses:** Single `occurredOn` field today; **segregation strategy** is specified in the Phase 2 spec doc (query-time vs future explicit kind).
- **Income, recurring, alerts, third-party import:** Master plan Phase 3+; **initial foundations** only in the Phase 2 spec doc (no commitment to UI in Phase 2).

---

## Phase status legend

Use exactly one of these values in **`Status:`** (under each phase heading):

| Value | When to use |
|--------|-------------|
| `pending` | Not started. |
| `in progress` | Currently implementing or actively working on this phase. |
| `done` | **Acceptance** satisfied; phase accepted for this repo. |
| `review` | Was complete (or near-complete) but needs revisions, tweaks, or a follow-up pass — use only for that rework cycle, not for routine “ready for you to test”. |

---

## Phase overview

| Phase | Status |
|-------|--------|
| 0.1 — Flutter project and web target | `done` |
| 0.2 — Static analysis and formatting | `done` |
| 0.3 — Layered `lib/` structure | `done` |
| 0.4 — Drift + first migration + web | `done` |
| 0.5 — i18n pipeline (English) | `done` |
| 0.6 — Responsive shell and navigation | `done` |
| 0.7 — README runbook and Phase 1 entry | `done` |
| 1.1 — Categories domain and persistence | `done` |
| 1.2 — Expense CRUD and validation | `done` |
| 1.3 — Month-scoped list UI | `done` |
| 1.4 — Multi-currency display, default FX presets, Categories destination | `done` |

---

## Phase 0.1 — Flutter project and web target

**Status:** `done`

**Goal:** Runnable Flutter app in the browser.

**Steps:**

1. Create the Flutter project in this repository (or merge into existing root if you prefer a subfolder—pick one layout and keep it).
2. Enable/configure the **web** platform; ensure `flutter config` does not block web.
3. Use a stable Flutter channel; pin SDK lower bound in `pubspec.yaml` explicitly.
4. Verify default app runs: `flutter run -d chrome` (or your preferred web device).

**Acceptance:**

- `flutter pub get` succeeds.
- `flutter run -d chrome` launches without errors.
- `flutter doctor` shows no blocking issues for web.

**Suggested commit subject:** `Scaffold Flutter app with web enabled`

---

## Phase 0.2 — Static analysis and formatting

**Status:** `done`

**Goal:** Consistent style and a clean `flutter analyze`.

**Steps:**

1. Add or tune `analysis_options.yaml` (Effective Dart–friendly lints; align with team tolerance—fix or ignore explicitly).
2. Run `dart format .` on the project.
3. Resolve all `flutter analyze` issues (no warnings left that you intend to keep).

**Acceptance:**

- `dart format --set-exit-if-changed .` exits 0.
- `flutter analyze` exits 0.

**Suggested commit subject:** `Configure Dart lints for clean analyze`

---

## Phase 0.3 — Layered `lib/` structure (empty shells)

**Status:** `done`

**Goal:** Physical structure matches clean architecture before features grow.

**Steps:**

1. Create folders, for example: `lib/domain/`, `lib/application/` (or `lib/features/…` per feature—choose one style and document it in `README.md`).
2. Add minimal barrel exports or placeholder `README` snippets only if useful; **no** Flutter imports inside `lib/domain/`.
3. Move/replace `main.dart` wiring only as needed to preserve a running app.

**Acceptance:**

- App still runs on web after moves.
- `lib/domain/` contains no `package:flutter` imports.

**Suggested commit subject:** `Add clean architecture lib folder layout`

---

## Phase 0.4 — Drift + first migration + web persistence

**Status:** `done`

**Goal:** Local-first database opens on web with a versioned schema.

**Steps:**

1. Add Drift (and dev `build_runner` / `drift_dev` as required).
2. Define `AppDatabase` (or equivalent) and **migration strategy** `v1` (empty schema or first table stub only if you already want smoke-test data—prefer minimal).
3. Follow project persistence rules: web via supported Drift web strategy (WASM / documented fallback).
4. Open the DB at app startup (infrastructure layer); surface a trivial debug indicator or log in debug mode if helpful.

**Acceptance:**

- Cold start on web: no DB open errors in console.
- Schema version is explicit; migration file(s) are generated and committed.

**Suggested commit subject:** `Integrate Drift with web database bootstrap`

---

## Phase 0.5 — i18n pipeline (English only)

**Status:** `done`

**Goal:** No hardcoded user-visible strings in widgets.

**Steps:**

1. Configure `flutter_localizations` and `intl`; set up ARB + code generation (`l10n.yaml` / `flutter gen-l10n`).
2. Replace at least one visible string (e.g. app title) with an ARB key.
3. Document how to add strings for future locales.

**Acceptance:**

- Generated l10n classes build without manual edits to generated files.
- At least one UI string comes from ARB, not literals in the widget tree.

**Suggested commit subject:** `Add English ARB localization pipeline`

---

## Phase 0.6 — Responsive shell and navigation skeleton

**Status:** `done`

**Goal:** Web-first layout and place holders for upcoming features.

**Steps:**

1. Implement an app **shell** with responsive breakpoints (no mobile-only assumptions).
2. Add navigation (e.g. `go_router` or Navigator 2—pick one and reuse).
3. Stub **two** destinations, e.g. **Home** (future month/expense list) and **Settings** (stub).
4. Optional: empty states with localized copy.

**Acceptance:**

- Resize browser: layout adapts without overflow errors on typical widths.
- Navigation between stubs works on web.

**Suggested commit subject:** `Add responsive shell and route skeleton`

---

## Phase 0.7 — README runbook and Phase 1 entry criteria

**Status:** `done`

**Goal:** Anyone (including future you) can run and know what “done” means for foundation.

**Steps:**

1. Update `README.md`: prerequisites, `flutter pub get`, `flutter run -d chrome`, codegen commands if any (`build_runner`).
2. Link to `docs/PROJECT_MASTER_PLAN.md` as product source of truth (path is local; note it if `docs/` is gitignored in your clone).
3. List **Phase 1** entry criteria in short bullets (categories + expenses MVP).

**Acceptance:**

- Fresh clone + README steps reproduce a running web app (except paths blocked by gitignore policy).

**Suggested commit subject:** `Document run instructions and phase boundaries`

---

## Phase 1 (preview) — MVP data: categories, Other, expenses

**Status:** `done`

Implement only after Phase 0.1–0.7 pass. Split into sub-phases so you can test between commits.

### Phase 1.1 — Categories domain and persistence

**Status:** `done`

- Domain entities + repository **interface**; Drift tables; **Other** subcategory invariant per category.
- Seed taxonomy from master plan §7 (English labels in DB; display via i18n as needed).

**Acceptance:** List categories/subcategories from DB in a debug or simple UI; **Other** cannot be deleted.

**Suggested commit subject:** `Implement category schema with Other subcategory`

### Phase 1.2 — Expense CRUD and validation

**Status:** `done`

- Expense entity: `occurredOn` **date-only**, amounts, manual FX, computed USD, `paidWithCreditCard`; subcategory must belong to category.

**Acceptance:** Create/edit/delete expense; invalid category/subcategory pairing rejected.

**Suggested commit subject:** `Add expense CRUD with date only validation`

### Phase 1.3 — Month-scoped list UI

**Status:** `done`

- Filter expenses by calendar month (local calendar); align with Excel “one month sheet” mental model.

**Acceptance:** Adding expenses in different months shows correct month views.

**Suggested commit subject:** `Add month filtered expense list view`

### Phase 1.4 — Multi-currency display, default FX presets, Categories destination

**Status:** `done`

- **Multi-currency:** Store `currencyCode` and `manualFxRateToUsd` per expense; show **original currency** and **USD** where relevant; month summary chips per currency plus USD.
- **Default FX:** Asset-backed default rates (`default_fx_rates.json`) + loader; expense form suggests rate with override.
- **Formatting:** Shared currency/FX display helpers for lists and forms.
- **Navigation:** Dedicated **`/categories`** shell branch and **`CategoriesScreen`**; Home focuses on month totals + transactions only.

**Acceptance:** Creating expenses in ARS/BRL/USD shows correct formatting and totals; Categories reachable from shell without scrolling Home.

**Suggested commit subject:** `Add FX presets and categories destination`

---

## Reference

- Product phases: `docs/PROJECT_MASTER_PLAN.md` §6.
- Phase 2 spec: `docs/02-reports-and-foundations-phase-2.md`; Phase 2 tracker: `docs/02-implementation-phase-2-plan.md`.
- Agent constraints: `.cursor/rules/expense-app-*.md`.
- New numbered implementation plans: copy [`docs/_templates/implementation-plan-template.md`](_templates/implementation-plan-template.md).
