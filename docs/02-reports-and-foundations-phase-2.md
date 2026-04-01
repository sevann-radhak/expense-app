# Phase 2+ — Reports, taxonomy UX, and long-term foundations

**Ordered doc:** **`02-reports-and-foundations-phase-2.md`** — Phase 2 **product/spec** in the `docs/` implementation-plan series, following [`01-implementation-initial-plan.md`](01-implementation-initial-plan.md). **Execution checklist:** [`02-implementation-phase-2-plan.md`](02-implementation-phase-2-plan.md).

**Purpose:** Define the **next implementation slice** (reports + navigation + aggregations + basic charts), align with **`docs/PROJECT_MASTER_PLAN.md`** §6 Phase 2, and record **non-binding foundations** for later phases (projections, income, alerts, imports, report export). Those foundations are **design intent** until promoted into a later numbered plan or the master plan.

**Execution tracker (step-level status, as-built notes):** [`02-implementation-phase-2-plan.md`](02-implementation-phase-2-plan.md) — update that file as Phase 2 work lands; this doc stays the **product/spec** summary.

**Stack (unchanged):** Flutter, Drift, Riverpod, web first; domain layer stays free of Flutter/SQLite imports.

---

## Relationship to the master plan

| Master plan §6 | This doc |
|----------------|----------|
| **Phase 2 — Reports and charts** | Implemented here as **2.1–2.5** (shell, annual hub, drill-downs, charts, export stub). |
| **Phase 3 — Configuration** | Only **hooks**: settings keys, optional report defaults; no full settings UI required for Phase 2. |
| **Phase 4 — Recurring + installments** | **Expense kind** and projection strategy below prepare queries and schema evolution without building the engine yet. |
| **Phase 5 — Alerts** | **Data-quality flags** can reuse report aggregations; detailed alert types stay future work. |
| **Phase 6+ — Import / FX API** | **Import pipeline interface** noted under long-term foundations. |

---

## Phase status legend

| Value | When to use |
|--------|-------------|
| `pending` | Not started. |
| `in progress` | Active implementation. |
| `done` | Acceptance satisfied. |
| `review` | Rework pass needed. |

---

## Phase overview

High-level status only; **detailed steps and file-level as-built** live in [`02-implementation-phase-2-plan.md`](02-implementation-phase-2-plan.md).

| Phase | Status |
|-------|--------|
| 2.1 — Reports shell and annual hub | `done` |
| 2.2 — Aggregations, filters, percentages | `done` |
| 2.3 — Charts | `done` |
| 2.4 — Realized vs scheduled (projected) expenses | `done` |
| 2.5 — Taxonomy UX: hide internal IDs, optional descriptions, color identity | `done` |
| 2.6 — Report export stub (CSV / future PDF) | `done` |

---

## Product: Reports module (left navigation)

**Goal:** A **fourth** shell destination **Reports** (`/reports`), consistent with Home, Categories, Settings (order suggestion: **Home → Reports → Categories → Settings** — adjust if product prefers Categories before Reports).

**Main page (landing):** **Annual report** for the **selected calendar year** (default: year containing “today” in local calendar):

- Total spend (with currency strategy: **primary display USD** plus breakdown by **original currencies** where useful — mirror Home’s mental model).
- **Month × totals** table or compact row strip (12 months).
- Entry points to **drill-down** views (same year unless user changes scope).

**Drill-down strategy (recommended):**

1. **By month** — list expenses or sub-aggregates for that month; reuse month semantics from Home.
2. **By category** — for the year (or selected month): each category’s total, **% of period total**, optional subcategory breakdown.
3. **By subcategory** — optional third level when category selected (master plan parity with Excel-style breakdowns).

**Navigation pattern:** Prefer **one Reports branch** with **child routes** or **tabs** inside the Reports scaffold (e.g. `Annual` | `By month` | `By category`) to avoid exploding top-level shell items. Deep links: `/reports`, `/reports/year/2026`, `/reports/year/2026/month/3`, `/reports/year/2026/category/{id}` as needed.

**Percentages:** Always relative to a **clear denominator** (e.g. “% of total expenses in **selected period** in **USD**”). Show footnote when FX mix makes interpretation approximate.

**Charts (Phase 2.3):**

- **Bar:** spend per month (year view).
- **Pie or doughnut:** share by category for a chosen month or year (pastel colors aligned with **category color strategy** below).
- Keep **accessible** alternatives: table + numeric % alongside charts.

**Acceptance (2.1–2.3 combined):**

- User can open **Reports** from shell; see **annual** totals for current year from **existing** expenses.
- At least one **chart** and **category %** view work on web without overflow on typical widths.
- All new UI strings in **ARB** (English first).

**Suggested commit subjects:** `02-Add reports shell and annual route`; `02-Add report aggregations and category drill-down`; `02-Add report charts with fl_chart` (or chosen package).

---

## Domain: realized vs projected (scheduled) expenses

**Problem:** Users want to separate **money already spent** (as of today) from **committed future spend** (recorded with a **future** `occurredOn`).

**Current state:** Single `Expense` row with **date-only** `occurredOn` — no explicit “kind” field.

**Recommended strategy (phased):**

### Phase 2 (minimal change, no migration strictly required)

- **Definition — “Scheduled / projected”:** `occurredOn` **strictly after** the user’s **local calendar today** (normalize date comparison in domain or application layer).
- **Definition — “Realized”:** `occurredOn` **on or before** today (or optionally treat **today** as realized regardless of user mental model — product pick; document in UI copy).
- **Queries:** As implemented (2.4), **Reports** use `ExpenseInclusion` via Riverpod (`all` | `realizedOnly` | `scheduledOnly`) with **in-memory** filter on repository streams; **Home** stays **all** (unfiltered month list).

### Later (Phase 4+ alignment)

- Add optional **`ExpenseKind`** enum column (`realized`, `scheduled`, `generatedFromRecurring`, …) when **recurring materialization** and **installments** arrive — avoids ambiguity when backdating or editing past scheduled items.
- Alternatively or additionally: **`ScheduledExpense`** template entity that **generates** `Expense` rows — only if product wants strict separation of “plan” vs “booking.”

**Acceptance (2.4):**

- Reports (and optionally Home) can filter **realized vs scheduled** with documented rules.
- Unit tests for date-boundary logic (time zone / local calendar).

**Suggested commit subject:** `02-Add realized vs scheduled expense filters`

---

## Taxonomy UX: remove `cat_*` noise, optional descriptions

**Problem:** Debug-oriented display of stable IDs (`cat_leisure`, `cat_leisure_entertainment`) confuses end users (see Categories screen).

**Principles:**

- **`id` / `slug` remain internal** — stable for seeds, migrations, foreign keys, and future sync; **not** shown in default consumer UI.
- **User-facing line:** **localized or DB `name`** + optional **subtitle**.

**Schema (Drift) — recommended:**

- `Categories`: add nullable **`description`** (`Text`, optional).
- `Subcategories`: add nullable **`description`** (`Text`, optional).

**UI:**

- **Title:** category/subcategory **name** (from DB or i18n map keyed by `id` if you later externalize labels).
- **Subtitle:** `description` if non-empty; otherwise **omit** subtitle row (no fallback to slug/id).
- **Developer mode (optional, much later):** toggle in Settings to show IDs for support — not required for Phase 2.

**Acceptance (2.5 part A):**

- Categories screen lists **no** raw `cat_*` strings in release UI unless debug flag explicitly enabled.

**Suggested commit subject:** `02-Add optional category descriptions and hide internal ids`

---

## Category and subcategory color identity (pastel / coherent with app)

**Goal:** Consistent **visual anchor** per category in lists, chips, charts, and future Home rows — **coherent** with existing **Material 3 / soft purple** app chrome (avoid neon; prefer **muted pastels** and **tonal harmony**).

**Recommended strategy:**

1. **Curated palette:** Fixed list of **N pastel fills** (e.g. 12–16) chosen to work on light backgrounds with adequate contrast for text/icons — derive from **seed** or **theme extension** (`CategoryColors` / `AppChartColors`).
2. **Stable assignment:** `colorIndex = hash(categoryId).abs() % N` (or **explicit `sortOrder` modulo N**) so colors **never jump** when unrelated categories change.
3. **Subcategories:** **Same hue family** as parent — e.g. parent color at **primary** tone, subcategory at **+1 or +2 lightness** steps (Material tonal palette) or **alpha blend** with surface (e.g. 70% parent, 30% neutral). Avoid a second hash per subcategory to prevent rainbow noise inside one card.
4. **Charts:** Pie/doughnut segments use **same** category colors as rest of app for **learnability**.
5. **Accessibility:** Do not rely on color alone; keep **labels** and **patterns** or **legends** for charts.

**Optional schema extension:** Nullable **`accentColor`** (`Int` ARGB) on `Categories` for **user override** later; if null, use derived index rule. Subcategories inherit unless override requested in a later phase.

**Acceptance (2.5 part B):**

- Categories screen and at least one Report chart use **shared** category color resolution (single provider or domain helper + presentation mapper).

**Suggested commit subject:** `02-Add deterministic pastel colors for categories`

---

## Long-term foundations (not fully specified — track for Phase 3–6)

These items **inform** architecture but **do not** require full implementation in Phase 2. When building Phase 2, prefer **interfaces and extension points** over large speculative code.

### Projections and cashflow

- **Projection engine (future):** Combine **realized** expenses, **scheduled** expenses, optional **income** ledger, and **recurring** rules into a **timeline** view (monthly net). Phase 2 reports lay the **aggregation** groundwork; projection UI is later.
- **Cross-cutting “books”:** Single book per install remains; any **multi-profile** work stays behind explicit product decision (master plan §8).

### Income panel

- Reserve **Income** entity or `Transaction` supertype in domain discussions; **no mandatory UI** until Phase 3+. Reports can later show **expense-only** vs **net** behind a feature flag.

### Estimates and budgets

- **Budget per category/month** (future) enables variance and **alerts**; chart components in Phase 2 should accept **optional target lines** later without rewrite.

### Alerts

- Reuse **aggregations** (spend vs budget, missing FX, duplicate detection) as **read models** feeding an **Alerts** or **Issues** list (master plan §5.6). Phase 2: optional **placeholder** section “No alerts yet” is acceptable only if product wants it; otherwise **document only**.

### Automatic registration / third parties (e.g. card charges)

- **Ingestion boundary:** Define a future **`StatementImportService`** or **`ExternalTransactionAdapter`** in `data/` / `application/` — **no card PAN/CVV** (project non-negotiable). Formats: CSV/OFX first; **rules-based category mapping** from merchant strings.
- **Matching:** Fuzzy match to existing expenses or create drafts for user confirmation — **not** auto-post without user action in early versions.

### Report generation (export, print, share)

- **Phase 2.6 stub:** **CSV export** for a selected scope (year/month/category filter) — matches master plan Phase 2 “export month CSV”; extend to annual.
- **Future:** **PDF** template (annual summary), **print-friendly** CSS/layout on web, optional **scheduled email** only if cloud exists — document as Phase 6+.

### Sync and multi-device

- Out of scope until master plan Phase 7; **repository interfaces** already support swapping implementations.

---

## Phase 2.6 — Report export stub

**Goal:** **CSV** (and optional **clipboard**) for the **current report scope**; structure columns to match future PDF (date, category, subcategory, amounts, currency, USD, flags).

**Acceptance:**

- User can export at least **one** report view to CSV on web (download blob).

**Suggested commit subject:** `02-Add CSV export for report scope`

---

## Reference

- Phase 2 execution plan / tracker: [`02-implementation-phase-2-plan.md`](02-implementation-phase-2-plan.md).
- Prior completed work: [`01-implementation-initial-plan.md`](01-implementation-initial-plan.md).
- Product source of truth: [`PROJECT_MASTER_PLAN.md`](PROJECT_MASTER_PLAN.md).
- Excel parity hints: [`Plantilla-2025-agent-prompt.mdc`](Plantilla-2025-agent-prompt.mdc).
- Agent rules: `.cursor/rules/expense-app-*.md`.
- New plan template: [`_templates/implementation-plan-template.md`](_templates/implementation-plan-template.md).
