# Phase 3 — detailed implementation plan and tracker

**Ordered doc:** **`03-implementation-phase-3-plan.md`** — Phase 3 **execution tracker** following [`02-implementation-phase-2-plan.md`](02-implementation-phase-2-plan.md). **Product source:** [`PROJECT_MASTER_PLAN.md`](PROJECT_MASTER_PLAN.md) §6 Phase 3 (configuration depth) and §Phase 7 (future sync).

**Purpose:** Executable checklist for **settings, demo data, card profiles, and production-readiness documentation** without implementing auth or remote sync yet. Update **`Status:`** and **As-built** when slices ship.

**Commit prefix:** use **`03-`** on commits for this phase.

---

## Production and multi-device (ADR summary)

**Current (v1):** Local-first persistence — Drift/SQLite (native) and Drift web (WASM). Suitable for single-book installs and demos.

**Target production (multi-user, any device):** Typically a **managed database** (e.g. PostgreSQL on Azure/AWS RDS, or Supabase/Firestore) plus an **HTTP API** plus **authentication** (OAuth/JWT). The client must **not** embed database credentials; it uses short-lived tokens and TLS. **Viable and recommended** for serious production: backups, scaling, encryption at rest, and per-tenant isolation (`user_id` on all rows or separate schemas).

**Extension points in this codebase:** [`ExpenseRepository`](lib/domain/expense_repository.dart), [`CategoryRepository`](lib/domain/category_repository.dart), and [`PaymentInstrumentRepository`](lib/domain/payment_instrument_repository.dart) are the seams for a future **remote** implementation or a **sync layer** that merges local and server rows. Domain logic should remain free of Flutter and transport details.

**Future sync concerns:** Conflict resolution (e.g. last-write-wins vs CRDT), schema migrations on the server, and offline queues. **Phase 7** in the master plan covers auth + multi-device explicitly; Phase 3 only **documents** this path and may add empty/stub interfaces if needed.

**Secrets:** Never commit API keys or DB passwords; use environment/config providers and CI secrets.

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

| Phase | Status |
|-------|--------|
| 3.0 — Production readiness (documentation) | `done` (ADR in this file) |
| 3.1 — Demo / example expenses seed + Settings action | `done` |
| 3.2 — Settings structure (locale, default currency persistence) | `done` |
| 3.3 — Credit card profiles (schema + repository + Settings CRUD) | `done` |
| 3.4 — Wire expense form to default card / `paymentInstrumentId` | `done` |
| 3.5 — Backup / import JSON (optional) | `done` |
| 3.6 — Pre-sync API spike (optional mock client) | `done` |

---

## Phase 3.0 — Production readiness (documentation only)

**Status:** `done`

**Goal:** Align the team on how local-first evolves to hosted multi-user without implementing it.

**Deliverable:** ADR section above + extension points called out.

---

## Phase 3.1 — Demo / example expenses seed

**Status:** `done`

**Goal:** Optional, removable **demo expenses** (~one calendar year, mixed currencies, coherent categories) for Reports/Home QA; **Settings** action separate from reset DB.

**As-built:**

- Data: [`lib/data/local/example_expenses_seed.dart`](../lib/data/local/example_expenses_seed.dart) — `kExampleDemoExpenseYear`, ids prefixed `exp_demo_`, **DEMO_ONLY** comment.
- Replace prior demo rows: `DELETE FROM expenses WHERE id LIKE 'exp_demo%'` before insert.
- UI: [`settings_screen.dart`](../lib/presentation/settings/settings_screen.dart) + ARB `settingsPopulateExample*`.
- Tests: [`test/example_expenses_seed_test.dart`](../test/example_expenses_seed_test.dart).

**Acceptance:**

- [x] User can **Reset DB** then **Populate example data** (or populate on existing taxonomy).
- [x] Data spans **≥12 months** in `kExampleDemoExpenseYear` with **EUR** (and **USD**) in travel-heavy months (e.g. June/December).
- [x] File is easy to delete when demo is no longer needed.

---

## Phase 3.2 — Settings structure

**Status:** `done`

**Goal:** Persist **locale** and **default currency** (and placeholders for “Account” section).

**Decision:** **`shared_preferences`** for app UI prefs (locale, default currency, last card id in 3.4). **Drift** remains the book of record (expenses, categories, card profiles). Avoids mixing taxonomy migrations with simple key–value settings.

**As-built:**

- Storage keys: [`lib/data/local/app_user_settings_storage.dart`](../lib/data/local/app_user_settings_storage.dart).
- Riverpod: [`lib/presentation/providers/app_user_settings_provider.dart`](../lib/presentation/providers/app_user_settings_provider.dart) (exported from [`providers.dart`](../lib/presentation/providers/providers.dart)); `sharedPreferencesProvider` overridden in [`main.dart`](../lib/main.dart).
- UI: [`lib/presentation/settings/settings_screen.dart`](../lib/presentation/settings/settings_screen.dart) — Preferences (language, default currency), Account placeholder.
- `MaterialApp`: [`lib/presentation/app.dart`](../lib/presentation/app.dart) — `ConsumerWidget`, `locale` + `localeResolutionCallback`.
- New expense default currency: [`expense_form_dialog.dart`](../lib/presentation/home/expense_form_dialog.dart) via `effectiveDefaultCurrencyForForm`.
- Tests: [`test/app_user_settings_test.dart`](../test/app_user_settings_test.dart); widget tests override `sharedPreferencesProvider`.

**Acceptance:**

- [x] Locale persists (system default vs English); `MaterialApp` reflects choice.
- [x] Default currency persists and preselects **new** expense form when valid vs FX table.
- [x] Account section placeholder copy for future sync/auth.

---

## Phase 3.3 — Credit card profiles

**Status:** `done`

**Goal:** Schema + repository for **card metadata only** (label, bank, cycle, fees text/numbers) — no PAN/CVV per project rules.

**As-built:**

- Domain: [`lib/domain/payment_instrument.dart`](../lib/domain/payment_instrument.dart), [`payment_instrument_repository.dart`](../lib/domain/payment_instrument_repository.dart).
- Drift: `payment_instruments` table + migration v7 in [`app_database.dart`](../lib/data/local/app_database.dart); reset wipes profiles in [`app_database_reset.dart`](../lib/data/local/app_database_reset.dart).
- Data: [`lib/data/local/drift_payment_instrument_repository.dart`](../lib/data/local/drift_payment_instrument_repository.dart).
- Providers: `paymentInstrumentRepositoryProvider`, `paymentInstrumentsStreamProvider` in [`providers.dart`](../lib/presentation/providers/providers.dart).
- UI: [`settings_card_profiles_section.dart`](../lib/presentation/settings/settings_card_profiles_section.dart), [`payment_instrument_form_dialog.dart`](../lib/presentation/settings/payment_instrument_form_dialog.dart), embedded from Settings screen.
- ARB: `settingsPaymentInstrument*` / `settingsPaymentInstruments*`.
- Tests: [`test/payment_instrument_repository_test.dart`](../test/payment_instrument_repository_test.dart).

**Acceptance:**

- [x] User can CRUD card profiles in Settings (metadata only).
- [x] Reset DB clears payment instruments with other user data.

---

## Phase 3.4 — Expense form + profiles

**Status:** `done`

**Goal:** Optional `paymentInstrumentId` on expenses; suggest default when `paidWithCreditCard` is true.

**As-built:**

- Domain: `Expense.paymentInstrumentId` in [`lib/domain/expense.dart`](../lib/domain/expense.dart); `copyWith(..., clearPaymentInstrumentId: true)` where needed.
- Drift: `expenses.payment_instrument_id` + migration v8 + `ensureExpensePaymentInstrumentIdColumn` in [`app_database.dart`](../lib/data/local/app_database.dart).
- Repository: validation against `payment_instruments` in [`drift_expense_repository.dart`](../lib/data/local/drift_expense_repository.dart).
- Form: optional card profile dropdown when “Paid with credit card” and profiles exist; suggestion order: **last saved id** (prefs) → **single profile** → none; prefs key in [`app_user_settings_storage.dart`](../lib/data/local/app_user_settings_storage.dart).
- CSV export: `payment_instrument_id` column in [`report_expense_csv.dart`](../lib/application/report_expense_csv.dart).
- ARB: `expenseCardProfileLabel`, `expenseCardProfileNone`.
- Tests: [`test/expense_repository_test.dart`](../test/expense_repository_test.dart), [`test/report_expense_csv_test.dart`](../test/report_expense_csv_test.dart), [`test/app_user_settings_test.dart`](../test/app_user_settings_test.dart).

**Acceptance:**

- [x] Optional `paymentInstrumentId` persisted on expenses; unknown id rejected at repository.
- [x] UI suggests a profile when enabling card payment (last used or only profile).
- [x] CSV includes `payment_instrument_id`.

---

## Phase 3.5 — Backup / import JSON (optional)

**Status:** `done`

**Goal:** Local book export/import as JSON complement to CSV; user chooses **CSV** (scoped report) vs **JSON** (full book) on export.

**As-built:**

- Snapshot + codec: [`lib/application/book_backup_snapshot.dart`](../lib/application/book_backup_snapshot.dart), [`book_backup_codec.dart`](../lib/application/book_backup_codec.dart) — `schemaVersion: 1`, stable keys in [BookBackupJsonKeys](../lib/application/book_backup_codec.dart).
- Export from DB: [`lib/data/local/book_backup_export.dart`](../lib/data/local/book_backup_export.dart).
- Import (replace-all, same destructive scope as reset): [`lib/data/local/book_backup_importer.dart`](../lib/data/local/book_backup_importer.dart) — `validateBookBackupSnapshot`, `importBookBackupReplacingAll`.
- Reports UI: [`reports_screen.dart`](../lib/presentation/reports/reports_screen.dart) — `PopupMenuButton` → **Current report as CSV** | **Full book as JSON backup**; web download via [`report_file_download.dart`](../lib/presentation/reports/report_file_download.dart) (conditional).
- Settings UI: [`settings_backup_section.dart`](../lib/presentation/settings/settings_backup_section.dart) — **Import JSON backup** with confirm dialog; web file pick [`book_backup_pick.dart`](../lib/presentation/settings/book_backup_pick.dart).
- ARB: `reportsExport*`, `settingsBackup*`, `settingsImportJsonWebOnly`.
- Tests: [`test/book_backup_codec_test.dart`](../test/book_backup_codec_test.dart), [`test/book_backup_importer_test.dart`](../test/book_backup_importer_test.dart).

**Acceptance:**

- [x] User can export CSV (unchanged scope) or full-book JSON from Reports (web).
- [x] User can import JSON backup from Settings after confirmation (web); referential integrity validated.
- [x] Non-web: export/import shows appropriate snackbar (web-first).

---

## Phase 3.6 — Pre-sync spike (optional)

**Status:** `done`

**Goal:** Mock API client + serialization test for `Expense` DTOs — **no** real backend.

**As-built:**

- Wire DTO: [`lib/application/expense_api_dto.dart`](../lib/application/expense_api_dto.dart) — `ExpenseApiDto`, `fromExpense` / `toExpense`, `toJson` / `fromJson`, list UTF-8 helpers.
- Mock client: [`lib/data/remote/mock_expense_remote_api.dart`](../lib/data/remote/mock_expense_remote_api.dart) — `ExpenseRemoteApi`, `MockExpenseRemoteApi.fetchSampleExpenses()`.
- Tests: [`test/expense_api_dto_test.dart`](../test/expense_api_dto_test.dart), [`test/mock_expense_remote_api_test.dart`](../test/mock_expense_remote_api_test.dart).

**Acceptance:**

- [x] DTO JSON round-trip tested; mock returns fixed payload without HTTP.

---

## Reference

- Master plan: [`PROJECT_MASTER_PLAN.md`](PROJECT_MASTER_PLAN.md).
- Phase 2 tracker: [`02-implementation-phase-2-plan.md`](02-implementation-phase-2-plan.md).
- Phase 2 spec: [`02-reports-and-foundations-phase-2.md`](02-reports-and-foundations-phase-2.md).

---

## Changelog

| Date (UTC) | Change |
|------------|--------|
| 2026-03-28 | Initial **03** tracker; **3.0** + **3.1** marked done (demo seed + Settings). |
| 2026-03-29 | **3.2** settings (`shared_preferences` + MaterialApp locale + default currency); **3.3** card profiles (Drift + Settings CRUD); **3.4** `paymentInstrumentId` on expenses + form + CSV + last-card suggestion prefs. |
| 2026-03-29 | **3.5** Reports export menu CSV vs full JSON backup; Settings JSON import (replace-all). **3.6** `ExpenseApiDto` + `MockExpenseRemoteApi` + tests. |
