# Personal expense app

Flutter package **`expense_app`**: **local-first**, **web-first** personal expense tracker.

---

## Prerequisites

| Requirement | Notes |
|-------------|--------|
| **Flutter (stable)** | [Install Flutter](https://docs.flutter.dev/get-started/install); use the stable channel. |
| **Web support** | `flutter config --enable-web` |
| **Chrome** (recommended) | For `flutter run -d chrome`. Or use `flutter run -d web-server` and open the printed URL. |
| **Dart SDK** | Satisfies `pubspec.yaml` (`>=3.11.4 <4.0.0`); bundled with Flutter. |

Optional: **Git** for clone/pull. On Windows, if plugins complain about symlinks, enable [Developer Mode](https://learn.microsoft.com/en-us/windows/apps/get-started/enable-your-device-for-development).

---

## First-time run (web)

From the repository root:

```bash
flutter pub get
flutter run -d chrome
```

Release build for deployment:

```bash
flutter build web
```

**After a fresh clone:** `lib/l10n/*.dart` (from ARB) is committed; `flutter pub get` is enough for normal work. If you delete generated files or change only ARB files, run:

```bash
flutter gen-l10n
```

**After changing Drift tables or queries:**

```bash
dart run build_runner build --delete-conflicting-outputs
```

**Docker / CI vs your machine:** If `flutter pub get` ran inside Linux Docker on a folder bind-mounted from Windows, `.dart_tool/package_config.json` may point at Linux paths (`/root/.pub-cache/...`) and local `flutter run` will fail. Delete `.dart_tool` (and optionally `build/`), then run **`flutter pub get` again on your PC**.

---

## Phase 0 complete — what you have

Foundation (implementation plan phases 0.1–0.7) delivers:

- Runnable **web** app, **lints**, layered **`lib/`**, **Drift** + **web WASM** (`web/sqlite3.wasm`, `web/drift_worker.js`), **ARB / l10n** (English), responsive **shell** + **`go_router`** (**Home** / **Settings**).

---

## Phase 1 entry criteria (MVP data)

Start Phase 1 when you are ready to implement **categories + expenses** (aligned with the product master plan §6 — Phase 1). Target outcomes:

- **Categories:** Entities and persistence; **subcategories** with a non-deletable **Other** per category; seed taxonomy (see master plan §7).
- **Expenses:** **CRUD**, list **filtered by calendar month**; **subcategory must belong** to the selected category.
- **Fields:** **Date-only** `occurredOn`, detail, `paidWithCreditCard`, local amount, **manual FX**, **computed USD** (per master plan).
- **Deliverable:** Behavior equivalent to **one month’s Excel sheet** for entry and review (digital).

Detailed breakdown: implementation plan Phase 1.1–1.3.

---

## Internationalization (l10n)

- **Template locale:** English in [`lib/l10n/app_en.arb`](lib/l10n/app_en.arb). Config: [`l10n.yaml`](l10n.yaml); `pubspec.yaml` has `flutter: generate: true`.
- **In widgets:** `import 'package:expense_app/l10n/app_localizations.dart'`; wire `MaterialApp` / `MaterialApp.router` with `AppLocalizations.localizationsDelegates` and `supportedLocales`; use `AppLocalizations.of(context)!`.
- **Adding strings:** New keys in `app_en.arb` (optional `@key` descriptions). [ICU placeholders](https://docs.flutter.dev/ui/accessibility-and-localization/internationalization#placeholders-plurals-and-selects) for dynamic text.
- **New locale:** Add `app_<lang>.arb`, then `flutter gen-l10n` (or `flutter pub get`).

---

## Drift on web

`web/sqlite3.wasm` and `web/drift_worker.js` are required. Pin them to the **`sqlite3`** and **`drift`** versions in `pubspec.lock` ([sqlite3.dart releases](https://github.com/simolus3/sqlite3.dart/releases), [drift releases](https://github.com/simolus3/drift/releases)). Serve `*.wasm` as `Content-Type: application/wasm` in production. See [Drift web docs](https://drift.simonbinder.eu/web/).

---

## `lib/` layout (clean architecture)

| Folder | Role |
|--------|------|
| `lib/domain/` | Entities, value objects, repository **interfaces** — **pure Dart** (no `package:flutter`). |
| `lib/application/` | Use cases / orchestration — no Flutter UI. |
| `lib/data/` | Repository implementations, Drift (`lib/data/local/app_database.dart`), mappers. |
| `lib/presentation/` | Widgets, themes, [`go_router`](https://pub.dev/packages/go_router) (`router/`), shell (`shell/`), features (`home/`, `settings/`). |
| `lib/main.dart` | Entrypoint: binding + DB init + `runApp`. |

---

## Web-first Git scope

`android/`, `ios/`, `linux/`, `macos/`, and `windows/` are **gitignored** so the repo focuses on Dart + web. Recreate native folders when needed:

```bash
flutter create . --project-name expense_app --org com.sevann.expense --platforms=android,ios,linux,macos,windows
```

Stop ignoring those paths in `.gitignore` when you want to **commit** platform projects.

---

## Start here (agent rules)

| Location | Purpose |
|----------|---------|
| [.cursor/rules/](.cursor/rules/) | Agent implementation rules |

Keep `.cursor/rules/` aligned with the codebase.

---

## Rules index

- `expense-app-project-context.mdc` — stack defaults  
- `expense-app-business-domain.mdc` — categories, expenses, recurring, alerts  
- `expense-app-architecture.mdc` — clean architecture  
- `expense-app-data-persistence.mdc` — SQLite, migrations, export  
- `expense-app-implementation.mdc` — style, i18n, money, tests  
- `expense-app-ui-ux.mdc` — charts, a11y, navigation  
