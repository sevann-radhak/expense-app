# Phase 4 — detailed implementation plan and tracker

**Ordered doc:** **`04-implementation-phase-4-plan.md`** — Phase 4 **execution tracker** following [`03-implementation-phase-3-plan.md`](03-implementation-phase-3-plan.md). **Product / domain spec:** [`04-phase-4-analysis.md`](04-phase-4-analysis.md). **Product source:** [`PROJECT_MASTER_PLAN.md`](PROJECT_MASTER_PLAN.md) §6 (expanded scope per analysis).

**Purpose:** Ordered checklist for **recurrence, income, installments, payment instruments v2, and UX polish**. Update **`Status:`** and **As-built** when slices ship.

**Phase 4 status:** **Complete and signed off.** Current code snapshot: Drift **`schemaVersion` 15** (`lib/data/local/app_database.dart`); book backup JSON **`BookBackupSnapshot.currentSchemaVersion` 8** (`lib/application/book_backup_snapshot.dart`).

**Commit prefix:** use **`04-`** on commits for this phase.

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
| 4.1 | Domain + Drift: recurrence rule types, series entity, migration; materialize future expenses | `done` |
| 4.2 | UI: create/edit series; series management; confirm / paid-early on generated rows | `done` |
| 4.3 | Income: schema, repository, shell route, CRUD + recurrence reuse | `done` |
| 4.4 | Payment instruments v2: active/default, statement/interest fields, Settings UX | `done` |
| 4.5 | Installments: plan + linked expenses, form UX when paying by card | `done` |
| 4.6 | Home/Reports UX: future-row styling, card label, hide card toggle, searchable pickers | `done` |
| 4.7 | Visual polish pass (typography, spacing, shell) | `done` |
| 4.8 (optional) | Partial payments: stub interfaces or spike | `done` |

---

## Phase 4.1 — Recurrence schema and materialization

**Status:** `done`

**Goal:** `RecurrenceRule` (sealed domain), `ExpenseRecurringSeries` (or equivalent), Drift tables + migration, service to **materialize** `Expense` rows with future `occurredOn` into a defined horizon.

**Target areas:** `lib/domain/`, `lib/data/` (Drift), `test/`.

**Steps:**

1. Define **domain** `RecurrenceRule` variants + validation (anchor date-only, end condition).
2. Define **series** entity: links to category/subcategory, amounts, optional `paymentInstrumentId`, `active`, `horizonMonths` or app constant.
3. Drift: `expense_recurring_series` table + FK from `expenses` → `seriesId` (nullable).
4. **Materialization** use case: idempotent generation; policy on **series edit** (e.g. delete future unrealized children and regenerate).
5. Unit tests for rule expansion (month boundaries, leap year, weekday ordinal).
6. Backup JSON: extend `schemaVersion` + serialize rule (see analysis).

**Acceptance:**

- New series creates **N** future expenses visible on the monthly **Expenses** screen for the horizon.
- Existing expenses without series unchanged.
- Analyzer clean; `flutter test` green for new tests.

**Suggested commit (subphase close):** `04-4.1-recurrence-schema-and-materialization`

**As-built notes:** Sealed `RecurrenceRule` + `RecurrenceEndCondition` in `lib/domain/recurrence_rule.dart`; entity `ExpenseRecurringSeries` + `expandRecurrenceOccurrences` / horizon helper in `recurrence_expansion.dart`. Drift **schema 9**: table `expense_recurring_series` (`RecExpenseSeries`), nullable `expenses.recurring_series_id` (FK, `ON DELETE CASCADE`), partial unique index `(recurring_series_id, occurred_on)`. `DriftRecurringExpenseSeriesRepository` + `recurringExpenseSeriesRepositoryProvider`; idempotent inserts (`InsertMode.insertOrIgnore`) with deterministic ids `sr_{seriesId}_{YYYY-MM-DD}`. **Edit policy:** `rematerializeForward` deletes generated rows with `occurred_on` strictly after local calendar today, then refills through rolling `horizonMonths`. JSON backup **schemaVersion 2** (`expenseRecurringSeries` + optional `recurringSeriesId` on expenses); **v1 imports** still accepted. Tests: `test/recurrence_expansion_test.dart`, `test/recurring_expense_series_test.dart`. **UI to create/manage series** deferred to **4.2**; materialized rows appear in existing month queries once `upsertAndRematerialize` (extension on `RecurringExpenseSeriesRepository`) is invoked.

---

## Phase 4.2 — Recurrence UI and confirmation

**Status:** `done`

**Goal:** User can create/edit/deactivate series; on each **materialized** future expense, actions: **Confirm paid**, **Skip**, **Paid early** (dates per [`04-phase-4-analysis.md`](04-phase-4-analysis.md) §4.4).

**Target areas:** `lib/presentation/`, Riverpod providers, ARB.

**Steps:**

1. Form flow: “Make recurring” from expense or dedicated **Series** screen.
2. List or settings section: active series with edit/stop.
3. Persist **`PaymentExpectationStatus`** (or side table) on expense row.
4. Wire actions from list tile overflow or detail screen.
5. i18n all new strings (`en` first).

**Acceptance:**

- User can complete full loop: create series → see future rows → confirm one.
- No crash on web; state survives reload (Drift persistence).

**Suggested commit:** `04-4.2-recurrence-ui-and-confirmation`

**As-built notes:** `PaymentExpectationStatus` + optional `paymentExpectationConfirmedOn` on `Expense`; materialized inserts set `expected`. **Add expense:** “Make repeating expense” (monthly same calendar day or weekly same weekday) + horizon months → creates series + `upsertAndRematerialize`. **Monthly Expenses list:** overflow menu on **strictly future** recurring rows still `expected` — Confirm paid (on schedule), Paid early (date picker), Skip, Waive; when the inline Paid/Expected control is shown, the redundant status chip is hidden. **Settings → Recurring expenses:** list, edit amount/horizon/note (rule read-only), stop series (`deactivateSeries`). Banner on edit dialog when row is series-generated. Backup carries optional expense expectation fields from **schemaVersion 3** onward. ARB `en`. `recurringExpenseSeriesListProvider`.

---

## Phase 4.3 — Income

**Status:** `done`

**Goal:** **`IncomeEntry`** table + repository + **`/income`** (or agreed route) CRUD; optional **`IncomeRecurringSeries`** reusing `RecurrenceRule`.

**Target areas:** `lib/domain/`, Drift, `lib/presentation/`, shell `NavigationRail` / router.

**Steps:**

1. Drift `income_entries` + optional `income_recurring_series`.
2. `IncomeRepository` + Riverpod.
3. List + add/edit screens (mirror expense patterns: date, amount, currency, FX).
4. If series: reuse materialization pattern from 4.1 (income-dedicated generator).
5. Reports (optional in 4.3): “Income this month” summary line — or defer to 4.6 if tight.

**Acceptance:**

- User can record income and see it on Income screen.
- Backup/export includes income tables if present.

**Suggested commit:** `04-4.3-income-schema-and-ui`

**As-built notes:** `IncomeEntry` + `IncomeSourceKind` in `lib/domain/income_entry.dart`; `IncomeRepository` + `DriftIncomeRepository`; `income_entries` + income taxonomy tables; **`IncomeRecurringSeries`** + Drift `income_recurring_series`, FK on entries, `DriftRecurringIncomeSeriesRepository`, rematerialize policy (see `recurring_income_series_rematerialize_test.dart`), form + settings flows, backup keys. **Shell route order:** **Expenses** (`/expenses`, redirect from `/home`), **Income** (`/income`), Reports, Categories, Settings — **shared month** with Expenses via `selectedMonthProvider`. UI: `lib/presentation/income/income_screen.dart`, `income_form_dialog.dart` with **SearchAnchor** + chips. Reports “By month” shows USD income line when data exists (`incomeForReportDetailMonthProvider`).

---

## Phase 4.4 — Payment instruments v2

**Status:** `done`

**Goal:** `isActive`, **`isDefault`** (single enforced), statement/due days, optional APR/limit/suffix label; Settings list + detail; **single source of truth** for default (prefer DB over prefs for default card).

**Target areas:** Drift `payment_instruments`, `lib/presentation/settings/`, `expense_form_dialog.dart` / providers.

**Steps:**

1. Migration add columns; backfill `isActive = true`, first instrument `isDefault` if none.
2. Settings: toggles, default radio, validation (“at least one active default” rule).
3. Expense form: filter pickers to **active** only; apply default when “paid with card”.
4. Remove or narrow SharedPreferences default if redundant (document in As-built).

**Acceptance:**

- Inactive cards never appear in expense form picker.
- Exactly one default when ≥1 active instrument (or documented edge case for zero instruments).

**Suggested commit:** `04-4.4-payment-instruments-v2`

**As-built notes:** Drift **schema 12** columns on `payment_instruments`: `is_active`, `is_default`, `statement_closing_day`, `payment_due_day`, `nominal_apr_percent`, `credit_limit`, `display_suffix`. `PaymentInstrument` domain + codec keys. `DriftPaymentInstrumentRepository` **normalizes** a single default among active instruments after create/update/delete; first-ever instrument forced default. `ensurePaymentInstrumentV2Columns` + `backfillPaymentInstrumentDefaultsIfNeeded` in `app_database.dart`. **Settings:** extended `PaymentInstrumentFormDialog`; list in `settings_card_profiles_section.dart` with inactive/default chips and “Set as default”. **Expense form:** `activePaymentInstrumentsStreamProvider`; **paid with card** switch hidden when no active instruments; suggestion order: **DB default** → SharedPreferences last → single card. Prefs still store **last used** id for convenience when no default.

---

## Phase 4.5 — Installments

**Status:** `done`

**Goal:** `InstallmentPlan` + generated **linked expenses** (or legs); UX when **paid with credit card** to create plan; optional APR pre-fill from instrument.

**Target areas:** Domain, Drift, expense form / wizard, ARB.

**Steps:**

1. Schema: `installment_plans` + `expenses.installmentPlanId` + `installmentIndex`.
2. Use case: create plan from principal, count, start date, interval (monthly default).
3. Form: “Split into N payments” with preview dates.
4. Document interest handling: **manual per payment** or simple disclosed formula.

**Acceptance:**

- User creates 12-month plan; 12 rows appear with correct dates and labels.
- Reports include installment rows like normal expenses.

**Suggested commit:** `04-4.5-installment-plans`

**As-built notes:** `InstallmentPlan` domain; table `installment_plans` (Drift **schema 13**); `expenses.installment_plan_id` / `installment_index`. `InstallmentPlanRepository` + `DriftInstallmentPlanRepository` transactional **plan insert + N `Expense` creates**. **Expense form** (new only): “Split into installment plan” + count 2–60; **mutually exclusive** with recurring; requires card + active instrument. Leg dates via `ExpenseDates.addCalendarMonths` (monthly interval = 1). Descriptions suffixed `(k/N)`. Interest remains **manual** per payment (no auto APR amortization in UI).

---

## Phase 4.6 — Home, Reports, and form UX

**Status:** `done`

**Goal:** Future-row **styling**; **card label** on list tile; **hide** card switch when no active instruments; **searchable** category/subcategory pickers with **color chips**.

**Target areas:** [`expense_summary_list_tile.dart`](lib/presentation/expenses/expense_summary_list_tile.dart), [`expense_form_screen.dart`](lib/presentation/home/expense_form_dialog.dart), [`expense_inclusion.dart`](lib/domain/expense_inclusion.dart) consumers, Reports tiles if needed.

**Steps:**

1. Pass **resolved** `PaymentInstrument` label into list tile; ARB with placeholder.
2. `Theme` / `Opacity` / `Container` for `!isRealized` rows; test contrast.
3. `paymentInstrumentsStreamProvider` → hide `SwitchListTile` when empty or no active.
4. Replace or wrap dropdowns with `SearchAnchor` + chips using `categoryAccentColor` / `categoryFillArgb`.

**Acceptance:**

- Scheduled rows visually distinct; screen reader still gets clear labels (Semantics).
- Category search works with 50+ subcategories (performance acceptable on web).

**Suggested commit:** `04-4.6-home-reports-form-ux`

**As-built notes:** `ExpenseSummaryListTile` / `IncomeSummaryListTile`: optional `paymentInstrumentLabel` (expense), `emphasizeAsScheduled` (opacity **0.82** for future dates). **Expenses** + **Reports By month** pass instrument label map + `isRealizedOnLocalCalendar`. **Expense** + **Income** forms: `SearchAnchor` + `SearchBar` with category/subcategory **color chips** (`categoryAccentColor`, `subcategoryTonalColor`). Card switch hidden per 4.4 when `activeInstruments` empty. Shared layout pieces: `lib/presentation/widgets/cashflow_summary_list_row.dart` (`ListRowCategoryLeadingAccent`, `CashflowSummaryTrailing`, overflow menu icon); `lib/presentation/widgets/list_row_settlement_segmented.dart` for Paid/Expected and Received/Expected.

---

## Phase 4.7 — Visual polish pass

**Status:** `done`

**Goal:** Consistent **typography**, **spacing**, **dialogs**, and **empty states** for screens touched in 4.1–4.6 (no repo-wide unsolicited redesign).

**Target areas:** Same routes as Phase 4 features; `app_theme.dart` if token tweaks are justified.

**Steps:**

1. Audit Income, Series, Installment, Settings instrument screens.
2. Align padding with `Theme.of(context).spacing` / existing constants.
3. Empty states with short ARB copy.

**Acceptance:**

- No new analyzer issues; UX review checklist (self) passes on web + one mobile size.

**Suggested commit:** `04-4.7-phase-4-visual-polish`

**As-built notes:** **Income** empty state uses `incomeEmptyTitle` / `incomeEmptyBody` in a **Card**. **Settings** card list uses structured **Card** + **Chip** row instead of plain `ListTile` for clearer hierarchy. **Navigation:** first tab labeled **Expenses** (ARB `navHome` / `homeTitle`), icons `receipt_long`; **`popShellBranchOverlayRoutes()`** in `app_router.dart` clears branch-local overlay routes when switching shell tabs so `PopupMenuButton` menus do not reappear after leaving a branch (`AppShell` calls it before `goBranch`). **PopupMenuButton** must not set `constraints` (that limits the menu panel in Material 3); use a fixed-size `child` for the more_vert control. No global `app_theme.dart` token changes (scoped to Phase 4 surfaces only).

---

## Phase 4.8 (optional) — Partial payments

**Status:** `done`

**Goal:** **`PartialPayment`** domain type + **repository interface** + backup key **or** time-boxed spike (1–2 days).

**Target areas:** `lib/domain/`, optional Drift stub table.

**Steps:**

1. Document in code comments linking to [`04-phase-4-analysis.md`](04-phase-4-analysis.md) §8.
2. If spike: one screen or debug-only flow; else **no UI**.

**Acceptance:**

- Interfaces compile; no regression in tests; scope clearly labeled optional.

**Suggested commit:** `04-4.8-partial-payments-stub`

**As-built notes:** `lib/domain/partial_payment.dart`: `PartialPayment` + `PartialPaymentRepository` (watch/upsert/delete). **No Drift table / UI.** Backup includes `partialPayments` array (export **[]** when unused). Test: `test/partial_payment_domain_test.dart`.

---

## Phase 4 — chat / close-out recap (what landed beyond subphase bullets)

- **Monthly expenses screen:** `ExpensesScreen` at `/expenses`; `/home` redirects; list heading and nav copy use **Expenses** (not “Home”).
- **List rows:** compact Paid/Expected (or Received/Expected) control with strong **primary** fill when settled; vertical alignment of trailing block; duplicate status **chip** suppressed when the segmented control is visible; **overflow menus** use a small `child` trigger (never `PopupMenuButton.constraints`).
- **Shell:** per-branch `navigatorKey` list + **`popShellBranchOverlayRoutes()`** on tab change.
- **Refactor:** shared **`cashflow_summary_list_row.dart`** to DRY expense/income summary cards; trimmed redundant comments in touched domain/widgets.

---

## Phase 5 considerations (do not implement in Phase 4 tracker)

**Status:** `out of scope` (this document tracks Phase 4 only)

Defer to **Phase 5** per master plan:

- **Alert engine:** local notifications or hooks for “due soon / overdue” recurring and installments.
- **Reconciliation** dashboard and **duplicate** detection.
- **Push** notification channel setup (mobile).
- **Bank import** / OFX (later phase).

Keep **data model** in Phase 4 compatible: `PaymentExpectationStatus`, `statementClosingDay`, `paymentDueDay` feed Phase 5 scheduling.

---

## Changelog (this document)

| Date (UTC) | Change |
|------------|--------|
| 2026-03-29 | Initial Phase 4 tracker: subphases 4.1–4.8, commits, Phase 5 bridge. |
| 2026-03-29 | Status line under each Phase 4.x heading; 4.2 shipped (recurrence UI + `PaymentExpectationStatus` + backup v3). |
| 2026-03-29 | Phase 4 complete: 4.3 income + schema 11; 4.4 instruments v2 + schema 12; 4.5 installments + schema 13; 4.6–4.7 UX; 4.8 partial-payment stub; backup **schemaVersion 6**; Drift **schemaVersion 13**. |
| 2026-03-29 | Sign-off pass: plan aligned with **income recurring series** in code; Drift **15** + backup **8** called out at top; Expenses route/shell popups/shared list row widgets documented; `partial_payment` / router comment noise reduced. |
