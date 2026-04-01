# Phase 2 — detailed implementation plan and tracker

**Ordered doc:** **`02-implementation-phase-2-plan.md`** — Phase 2 **execution tracker** in the `docs/` implementation-plan series. **Product/spec and foundations:** [`02-reports-and-foundations-phase-2.md`](02-reports-and-foundations-phase-2.md).

**Purpose:** Executable checklist for **Phase 2** (Reports through export stub), aligned with **`docs/PROJECT_MASTER_PLAN.md`** §6 and the product intent in [`02-reports-and-foundations-phase-2.md`](02-reports-and-foundations-phase-2.md). This document adds **step-level detail**, **as-built pointers** (files, providers, tests), and **explicit gaps / deferrals**. Update **`Status:`** and the **Phase overview** table whenever a slice ships or scope changes.

**How to use:** Set **`in progress`** only while actively implementing a phase. Set **`done`** when **Acceptance** is satisfied in this repo. Use **`review`** when work was considered complete but needs a focused rework pass. After each merge, refresh the **As-built (this repo)** bullets under completed phases so the next session does not re-discover work. **Suggested commit subject** lines use the plan’s numeric prefix (**`02-`**) so commits sort and scan with Phase 2 work.

**Spec source (unchanged product narrative):** [`02-reports-and-foundations-phase-2.md`](02-reports-and-foundations-phase-2.md).

---

## Phase status legend

| Value | When to use |
|--------|-------------|
| `pending` | Not started. |
| `in progress` | Currently implementing or actively working on this phase. |
| `done` | **Acceptance** satisfied; phase accepted for this repo. |
| `review` | Near-complete or complete but needs revisions, tweaks, or a follow-up pass. |

---

## Phase overview

| Phase | Status |
|-------|--------|
| 2.1 — Reports shell and annual hub | `done` |
| 2.2 — Aggregations, filters, percentages | `done` |
| 2.3 — Charts | `done` |
| 2.4 — Realized vs scheduled (projected) expenses | `pending` |
| 2.5 — Taxonomy UX: hide internal IDs, optional descriptions, color identity | `pending` |
| 2.6 — Report export stub (CSV / future PDF) | `pending` |

---

## Recap — Phase 2 intent vs this tracker

| Theme | In spec (`02-reports-and-foundations-phase-2`) | In this repo (high level) |
|-------|------------------------------------------------|---------------------------|
| Reports as shell destination | `/reports`, order Home → Reports → Categories → Settings | **Done** (2.1). |
| Annual hub + 12-month USD view | Year selector, totals, FX footnote | **Done** (2.1). |
| Drill-downs | By month, by category, % denominators clear | **Done** (2.2) via tabs; optional **go_router** deep links still **open**. |
| Charts | Bar (monthly), pie/doughnut (category), accessible tables kept | **Done** (2.3). |
| Realized vs scheduled | Query-time filter, toggle, tests | **Pending** (2.4). |
| Taxonomy UX + colors | Hide `cat_*`, descriptions, pastel identity shared with charts | **Pending** (2.5). |
| Export | CSV for report scope on web | **Pending** (2.6). |

---

## Phase 2.1 — Reports shell and annual hub

**Status:** `done`

**Goal:** Fourth shell destination **Reports** (`/reports`) with an **annual** landing: selected **calendar year**, **USD-primary** totals mirroring Home, **original-currency** chips where applicable, and a **12 × month USD** table.

**Steps:**

1. **Routing and shell**
   - [x] Add `StatefulShellBranch` for `/reports` in [`lib/presentation/router/app_router.dart`](../lib/presentation/router/app_router.dart).
   - [x] Insert **Reports** between Home and Categories in [`lib/presentation/shell/app_shell.dart`](../lib/presentation/shell/app_shell.dart) (rail + bar).
   - [x] ARB: `navReports`, titles, year picker tooltips, month table headers, FX footnote — [`lib/l10n/app_en.arb`](../lib/l10n/app_en.arb).

2. **Data**
   - [x] Extend [`ExpenseRepository`](../lib/domain/expense_repository.dart) with `watchForYear(int year)` (local calendar `[Jan 1, Jan 1 next year)` in ISO storage).
   - [x] Implement in [`DriftExpenseRepository`](../lib/data/local/drift_expense_repository.dart).

3. **State**
   - [x] `selectedReportYearProvider`, `expensesForSelectedReportYearProvider` in [`lib/presentation/providers/providers.dart`](../lib/presentation/providers/providers.dart).

4. **UI**
   - [x] Annual hub body: year strip, year totals card (chips + USD block), conditional 12-month table — implemented inside [`lib/presentation/reports/reports_screen.dart`](../lib/presentation/reports/reports_screen.dart) (Annual tab after 2.2 refactor).

5. **Tests**
   - [x] `watchForYear` boundaries — [`test/expense_repository_test.dart`](../test/expense_repository_test.dart).
   - [x] Widget: navigate to Reports, AppBar title, year label — [`test/widget_test.dart`](../test/widget_test.dart) (`pumpExpenseApp` resets `appRouter` to `/home` because `GoRouter` is a singleton).

6. **Deferrals (optional per spec; not required for 2.1 acceptance)**
   - [ ] **Deep links:** `/reports/year/{year}`, `/reports/year/{year}/month/{m}`, `/reports/year/{year}/category/{id}` — not implemented; tabs + local state cover navigation today.

**Acceptance:**

- [x] User opens **Reports** from shell; sees **annual** totals for the selected year from existing expenses.
- [x] **USD** primary + **non-USD** chips when relevant; **12 months** USD totals.
- [x] New UI strings via **ARB** (English).
- [x] `flutter analyze` and `flutter test` clean after the slice.

**Suggested commit subject:** `02-Add reports shell and annual route`

**As-built (this repo):**

- Reports UI now lives in a **tabbed** scaffold (2.2); the **Annual** tab contains the 2.1 hub. Year strip is **shared** above `TabBar` / `TabBarView`.
- Year navigation helper: `bumpReportYear` in `providers.dart` (also resets detail month when year changes — added with 2.2).

---

## Phase 2.2 — Aggregations, filters, percentages

**Status:** `done`

**Goal:** **Drill-downs** inside Reports without new shell items: **by month** (expense list, same month semantics as Home), **by category** (USD totals, **% of period total**), **subcategory** breakdown with **% of category USD**; clear **denominator** copy; period = **full year** or **single month** where applicable.

**Steps:**

1. **Domain (pure Dart)**
   - [x] Add [`lib/domain/report_aggregates.dart`](../lib/domain/report_aggregates.dart): `totalUsd`, `percentOfTotal`, `aggregateUsdByCategory`, `aggregateUsdBySubcategoryForCategory`, small aggregate types.
   - [x] Export from [`lib/domain/domain.dart`](../lib/domain/domain.dart).

2. **Presentation structure**
   - [x] `DefaultTabController` + **Annual | By month | By category** — [`reports_screen.dart`](../lib/presentation/reports/reports_screen.dart).
   - [x] Shared **year** strip above tabs.

3. **State**
   - [x] `selectedReportDetailMonthProvider` (1–12), `ReportCategoryPeriodScope`, `reportCategoryPeriodScopeProvider`.
   - [x] `expensesForReportDetailMonthProvider` — `watchForMonth(selectedYear, selectedMonth)`.
   - [x] `expensesForReportCategoryScopeProvider` — year stream vs month stream per scope.
   - [x] `bumpReportYear` syncs detail month (current month if year is “today’s” year, else `1`).

4. **By month tab**
   - [x] Month prev/next **within selected year** (no cross-year jump).
   - [x] List expenses with shared tile + edit dialog — [`ExpenseSummaryListTile`](../lib/presentation/expenses/expense_summary_list_tile.dart), [`ExpenseFormDialog`](../lib/presentation/home/expense_form_dialog.dart).

5. **By category tab**
   - [x] `SegmentedButton`: full year vs single month; month controls when **Single month**.
   - [x] Table + **ExpansionTile** per category: USD + % of **period**; children: subcategory USD + % of **category** total.
   - [x] Footnote for denominators — ARB `reportsPercentFootnote`.

6. **Refactor**
   - [x] Home uses `ExpenseSummaryListTile` instead of a private duplicate — [`home_screen.dart`](../lib/presentation/home/home_screen.dart).

7. **Tests**
   - [x] [`test/report_aggregates_test.dart`](../test/report_aggregates_test.dart).

8. **Deferrals**
   - [ ] **Dedicated “by subcategory” route** as a third navigation level — not built; **expandable rows** satisfy “optional third level” for Phase 2.2 scope.
   - [ ] **Realized / scheduled** filter — belongs to **2.4**, not 2.2.

**Acceptance:**

- [x] Reports offers **Annual**, **By month**, and **By category** views for the **same selected year** (unless product later changes).
- [x] **Percentages** use explicit denominators (period USD vs category USD) and are explained in UI copy.
- [x] Strings in **ARB**; analyzer and tests clean.

**Suggested commit subject:** `02-Add report aggregations and category drill-down`

**As-built (this repo):**

- Category/subcategory **names** come from `categoriesStreamProvider` / `allSubcategoriesStreamProvider` (not raw ids in this tab).
- **Filters** in 2.2 = **period scope** (year vs month) only — not date vs “today” (2.4).

---

## Phase 2.3 — Charts

**Status:** `done`

**Goal:** Visual summaries on **web** without layout overflow on typical widths; keep **tables / numeric %** as accessible fallbacks (per spec doc).

**Dependency choice:** **`fl_chart` ^1.2.0** (declared in `pubspec.yaml`).

**Steps:**

1. **Dependency**
   - [x] Add a maintained chart package (e.g. **`fl_chart`**) in `pubspec.yaml`; document choice in this section when done.

2. **Annual / Reports context**
   - [x] **Bar chart:** spend per month (12 bars) for **selected year** — reuse same monthly USD series as the Annual tab table.
   - [x] Place on **Annual** tab **below** or **beside** the existing table (product: avoid removing the table; charts supplement).

3. **Category context**
   - [x] **Pie or doughnut:** share by **category** for **selected period** (align with **By category** tab: full year vs single month, same streams/providers).
   - [x] **Legend / labels** — do not rely on color alone (spec).

4. **Theming**
   - [x] Until **2.5** ships a shared palette, use **temporary** M3-harmonized colors with a **TODO** to wire `CategoryColorResolver` (or equivalent) when 2.5 completes.

5. **l10n**
   - [x] ARB keys for chart section titles, axis hints if any, accessibility labels.

6. **Tests**
   - [x] Smoke or golden optional; at minimum keep `flutter test` green (widget test that pumps Reports Annual with data if feasible without flakiness).

**Acceptance:**

- [x] At least **one bar** chart (monthly) and **one pie/doughnut** (category share) render on **web** for real data.
- [x] No critical overflow on **~360–1280px** widths for Reports (adjust with `LayoutBuilder` / scroll as needed).
- [x] Table + % views **remain** for accessibility.
- [x] `flutter analyze` and `flutter test` clean.

**Suggested commit subject:** `02-Add report charts with fl_chart`

**As-built (this repo):**

- Domain: [`monthlyUsdTotalsByCalendarMonth`](../lib/domain/report_aggregates.dart) — single source for table + bar chart.
- Annual tab: [`ReportsMonthlyBarChart`](../lib/presentation/reports/reports_monthly_bar_chart.dart) below [`_MonthlyUsdTable`](../lib/presentation/reports/reports_screen.dart).
- By category: [`ReportsCategoryPieChart`](../lib/presentation/reports/reports_category_pie_chart.dart) (doughnut + text legend) above `_CategoryBreakdownTable`.
- Temporary colors: [`report_chart_colors.dart`](../lib/presentation/reports/report_chart_colors.dart) with **TODO(phase-2.5)**.
- l10n: `reportsChartMonthlyTitle`, `reportsChartCategoryTitle`, semantic labels in [`app_en.arb`](../lib/l10n/app_en.arb).
- Unit test: monthly bucket helper in [`report_aggregates_test.dart`](../test/report_aggregates_test.dart).

---

## Phase 2.4 — Realized vs scheduled (projected) expenses

**Status:** `done`

**Goal:** Separate **realized** (`occurredOn` ≤ local **today**) vs **scheduled** (`occurredOn` > local today) using **query-time** rules (spec); **no** schema migration strictly required for v1.

**Steps:**

1. **Domain / application**
   - [x] Define `ExpenseInclusion` (or equivalent): `all` | `realizedOnly` | `scheduledOnly`.
   - [x] Pure helpers: `isRealizedOnLocalCalendar(DateTime occurredOn, DateTime todayDateOnly)` — **no** time-of-day in product semantics; normalize **local calendar** “today”.
   - [x] Unit tests: boundary on **local** date (same instant different timezone edge cases documented or simplified per project pick).

2. **Data / repository**
   - [ ] Option A: extend `watchForMonth` / `watchForYear` with optional inclusion filter (compare `occurredOn` string or parsed date to **today** in repository or domain filter after fetch — prefer **SQL predicate** if cheap and correct).
   - [x] Option B: single `watch` + filter in application layer — acceptable only if datasets stay small; document tradeoff.

3. **UI**
   - [x] **Reports:** toggle or segmented control (e.g. All | Realized | Scheduled) on one or more tabs; **footnote** documenting rules (spec).
   - [x] **Home (optional):** product decision — **default `all`** (unchanged); Home continues to use unfiltered month stream. Only Reports applies inclusion.

4. **Tests**
   - [x] Repository or domain tests for inclusion boundaries.
   - [ ] Optional widget test: toggle changes visible rows.

**Acceptance:**

- [x] Reports (and Home if in scope) can filter **realized vs scheduled** with **documented** rules in UI or this doc.
- [x] Unit tests for **date-boundary** logic.
- [x] Analyzer and tests clean.

**Suggested commit subject:** `02-Add realized vs scheduled expense filters`

**As-built (this repo):**

- Domain: [`expense_inclusion.dart`](../lib/domain/expense_inclusion.dart) — `ExpenseInclusion`, `calendarDateOnly`, `calendarTodayLocal`, `isRealizedOnLocalCalendar`, `applyExpenseInclusion`.
- **Timezone / “today”:** comparisons use **device local** calendar fields from `DateTime.now()` and strip time-of-day; no cross-timezone normalization of a single UTC instant (v1 simplification).
- **Data:** **Option B** — repository streams unchanged; [`providers.dart`](../lib/presentation/providers/providers.dart) maps `watchForYear` / `watchForMonth` outputs through `applyExpenseInclusion` for `expensesForSelectedReportYearProvider`, `expensesForReportDetailMonthProvider`, and `expensesForReportCategoryScopeProvider`. Tradeoff: full period rows are read from SQLite then filtered in memory (fine for small books).
- UI: `SegmentedButton` + footnote in [`reports_screen.dart`](../lib/presentation/reports/reports_screen.dart); ARB `reportsExpenseInclusion*` in [`app_en.arb`](../lib/l10n/app_en.arb).
- State: `reportExpenseInclusionProvider` (default `all`).
- Tests: [`expense_inclusion_test.dart`](../test/expense_inclusion_test.dart).

**Footnote behavior:** UI copy notes that totals do not auto-refresh at midnight (only on data/navigation rebuild).

---

## Phase 2.5 — Taxonomy UX: hide internal IDs, optional descriptions, color identity

**Status:** `done`

**Goal:** Categories screen shows **no** raw `cat_*` / slug strings in default UI; optional **description** on categories and subcategories; **deterministic pastel** colors shared with **lists and charts** (spec).

**Steps:**

1. **Schema (Drift)**
   - [x] Add nullable `description` on `Categories` and `Subcategories` — [`app_database.dart`](../lib/data/local/app_database.dart); bump `schemaVersion`; migration from existing installs.
   - [ ] (Optional later) nullable `accentColor` ARGB on categories — defer if not needed for 2.5 acceptance.

2. **Domain / repositories**
   - [x] Extend entities and mappers for `description` (and `accentColor` if added).

3. **Categories UI**
   - [x] Replace debug-first lines that show **internal id** / slug with **name** + optional **subtitle** from `description`; **never** fall back to slug in consumer UI (spec).
   - [x] Forms: optional description fields for user-defined categories/subcategories (seed rows may stay without description).

4. **Color system**
   - [x] Curated palette (12–16 muted pastels), stable index from `categoryId` hash or `sortOrder % N`.
   - [x] Subcategory: tonal variation from parent (no independent rainbow hash per subcategory).
   - [x] Single resolver used from **Categories** screen and **Reports charts** (after 2.3, update charts to use resolver — may complete 2.5 before or after chart color TODO).

5. **Tests**
   - [x] Migration test or database open test if migrations are non-trivial.
   - [x] Widget smoke: Categories list does not expose `cat_` pattern for seeded names (or golden).

**Acceptance:**

- [x] Categories screen: **no** raw `cat_*` strings in release UI unless explicit debug flag (out of scope unless product asks).
- [x] Optional descriptions **persist** and display correctly.
- [x] At least **one** Reports chart and Categories use **shared** color resolution (if 2.3 done first, retrofit chart; if 2.5 first, wire chart in 2.3).

**Suggested commit subjects:** `02-Add optional category descriptions and hide internal ids`; `02-Add deterministic pastel colors for categories`

**As-built (this repo):**

- Schema **v6**: nullable `description` on `categories` and `subcategories`; `onUpgrade` + `beforeOpen` + [`ensureCategoryAndSubcategoryDescriptionColumns()`](../lib/data/local/app_database.dart) for upgrades / WASM.
- Domain: [`category.dart`](../lib/domain/category.dart) (`description` on `Category` / `Subcategory`); [`category_palette.dart`](../lib/domain/category_palette.dart) (16 ARGB pastels + `categoryFillArgb`); [`CategoryRepository`](../lib/domain/category_repository.dart) `setCategoryDescription` / `setSubcategoryDescription`.
- Data: [`drift_category_repository.dart`](../lib/data/local/drift_category_repository.dart) maps + updates (trim / empty → null).
- UI: [`categories_screen.dart`](../lib/presentation/categories/categories_screen.dart) — name + optional subtitle, edit dialogs, tonal subcategory bars; Home / Reports expense rows: [`expense_summary_list_tile.dart`](../lib/presentation/expenses/expense_summary_list_tile.dart) optional `categoryId` accent + [`taxonomyUnknownLabel`](../lib/l10n/app_en.arb) instead of raw ids when labels missing.
- Charts: category doughnut uses [`categoryFillArgb`](../lib/domain/category_palette.dart) in [`reports_category_pie_chart.dart`](../lib/presentation/reports/reports_category_pie_chart.dart); monthly bar stays theme primary via [`report_chart_colors.dart`](../lib/presentation/reports/report_chart_colors.dart).
- Presentation helpers: [`category_accent_colors.dart`](../lib/presentation/theme/category_accent_colors.dart) (`categoryAccentColor`, `subcategoryTonalColor`).
- Tests: [`category_repository_test.dart`](../test/category_repository_test.dart), [`category_palette_test.dart`](../test/category_palette_test.dart), widget assert no `cat_` in [`widget_test.dart`](../test/widget_test.dart).

---

## Phase 2.6 — Report export stub (CSV / future PDF)

**Status:** `done`

**Goal:** **CSV** export for the **current report scope** (year / month / category context as selected), **web download** (blob); column layout friendly to future PDF (spec).

**Export scope (as-built):**

- **Active tab** (Annual | By month | By category) selects which expense stream is exported, synced via [`reportsExportTabIndexProvider`](../lib/presentation/providers/providers.dart) from the Reports `TabController`.
- **Shared:** [`selectedReportYearProvider`](../lib/presentation/providers/providers.dart), [`reportExpenseInclusionProvider`](../lib/presentation/providers/providers.dart) (All | Realized | Scheduled) — same filters as on-screen data.
- **By month tab:** [`selectedReportDetailMonthProvider`](../lib/presentation/providers/providers.dart).
- **By category tab:** [`reportCategoryPeriodScopeProvider`](../lib/presentation/providers/providers.dart) (full year vs single month) and, when single month, the same detail month as By month.

**Steps:**

1. **Scope definition**
   - [x] Document which tab + toggles define **export scope** (e.g. Annual year, By month month, By category period + optional filter from 2.4).

2. **Implementation**
   - [x] Build CSV string (header row + data): date, category, subcategory, amounts, currency, USD, flags as appropriate.
   - [x] Web: trigger download via `dart:html` or universal approach that works on **web** first; mobile/desktop can follow later.

3. **UI**
   - [x] **Export** button (e.g. AppBar action on Reports or per-tab) + ARB strings.

4. **Tests**
   - [x] Unit test: CSV rows for a small in-memory expense list (no Flutter).

**Acceptance:**

- [x] User exports **at least one** report view to CSV on **web**.
- [x] Analyzer and tests clean.

**Suggested commit subject:** `02-Add CSV export for report scope`

**As-built (this repo):**

- CSV builder: [`report_expense_csv.dart`](../lib/application/report_expense_csv.dart) (`buildReportExpensesCsv`, `csvEscapeField`) — columns: `occurred_on`, `category_id`, `category_name`, `subcategory_id`, `subcategory_name`, `amount_original`, `currency_code`, `fx_rate_to_usd`, `amount_usd`, `paid_with_credit_card`, `description`; sorted by date then expense id.
- Web download: [`report_csv_download.dart`](../lib/presentation/reports/report_csv_download.dart) (conditional export) + [`report_csv_download_web.dart`](../lib/presentation/reports/report_csv_download_web.dart) (`dart:html` blob); stub throws on non-web.
- UI: AppBar download action + [`_handleReportsCsvExport`](../lib/presentation/reports/reports_screen.dart); non-web shows [`reportsExportCsvUnavailable`](../lib/l10n/app_en.arb).
- Provider: [`reportExportExpensesProvider`](../lib/presentation/providers/providers.dart) switches streams by tab index.
- Tests: [`report_expense_csv_test.dart`](../test/report_expense_csv_test.dart).

---

## Reference

- Product narrative and foundations: [`02-reports-and-foundations-phase-2.md`](02-reports-and-foundations-phase-2.md).
- Prior phases as-built: [`01-implementation-initial-plan.md`](01-implementation-initial-plan.md).
- Master plan: [`PROJECT_MASTER_PLAN.md`](PROJECT_MASTER_PLAN.md).
- Agent rules: `.cursor/rules/expense-app-*.md`.

---

## Changelog (maintain when phases ship)

| Date (UTC) | Change |
|------------|--------|
| 2026-03-28 | Initial tracker: **2.1** and **2.2** marked **`done`** with as-built file pointers; **2.3–2.6** **`pending`**. |
| 2026-03-28 | Renamed from `03-implementation-phase-2-plan.md`; spec companion is `02-reports-and-foundations-phase-2.md`. |
| 2026-03-28 | **2.3 Charts** marked **`done`**: `fl_chart` 1.2.x, monthly bar + category doughnut with legend, ARB + `monthlyUsdTotalsByCalendarMonth`. |
| 2026-03-27 | **2.4 Realized vs scheduled** marked **`done`**: `ExpenseInclusion`, stream map filter in providers, Reports segmented control + ARB footnote, Home stays `all`. |
| 2026-03-27 | **2.5 Taxonomy UX** marked **`done`**: schema v6 descriptions, palette + pie chart + list accents, Categories edit dialogs, no `cat_*` in consumer UI. |
| 2026-03-27 | **2.6 CSV export** marked **`done`**: `buildReportExpensesCsv`, web blob download, Reports AppBar action, tab-scoped `reportExportExpensesProvider`. |
