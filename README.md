# Personal expense app — planning repo

This repository contains the **Flutter** app (package `expense_app`) plus planning references for replacing the Excel-based expense workflow with a **web-first**, then **mobile**, product (see `docs/PROJECT_MASTER_PLAN.md`).

## Run the app (web)

1. Install [Flutter](https://docs.flutter.dev/get-started/install) on the **stable** channel and enable web (`flutter config --enable-web`).
2. From the repo root: `flutter pub get`
3. Run in Chrome: `flutter run -d chrome`

For a release build: `flutter build web`.

**Docker / CI vs your machine:** If you (or a tool) run `flutter pub get` inside Linux Docker while this folder is bind-mounted from Windows, `.dart_tool/package_config.json` can end up with Linux paths (`file:///root/.pub-cache/...`). Your local `flutter run` will then fail with “cannot find path” for `widgets.dart` or `drift.dart`. Fix: delete `.dart_tool` (and optionally `build/`), then run **`flutter pub get` again on your PC** so paths point at your Flutter SDK and `%LOCALAPPDATA%\Pub\Cache`.

After changing Drift tables or queries, regenerate code:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Internationalization (l10n)

- **Template locale:** English strings live in [`lib/l10n/app_en.arb`](lib/l10n/app_en.arb). Configuration is in [`l10n.yaml`](l10n.yaml) at the repo root; `pubspec.yaml` sets `flutter: generate: true` so `flutter pub get` / build runs code generation.
- **In widgets:** import `package:expense_app/l10n/app_localizations.dart`, set `MaterialApp.localizationsDelegates` and `supportedLocales` to `AppLocalizations.*`, and read strings with `AppLocalizations.of(context)!`. Generated files under `lib/l10n/` are checked in; run `flutter gen-l10n` after ARB edits (or rely on `flutter pub get` / build with `generate: true`).
- **Adding a string:** Add a key and value to `app_en.arb` (optional `"@key": { "description": "..." }` for translators). Use [ICU placeholders](https://docs.flutter.dev/ui/accessibility-and-localization/internationalization#placeholders-plurals-and-selects) when you need variables (`{name}`, plurals, `select`).
- **New locale:** Add `app_<lang>.arb` beside `app_en.arb` with the same keys, run `flutter gen-l10n` (or `flutter pub get`), then include the locale in your app’s locale resolution logic when you add a language picker (later phase).

### Drift on web

The files `web/sqlite3.wasm` and `web/drift_worker.js` are required for SQLite in the browser. They are pinned to the **`sqlite3`** and **`drift`** versions resolved in `pubspec.lock` (see releases: [sqlite3.dart](https://github.com/simolus3/sqlite3.dart/releases), [drift](https://github.com/simolus3/drift/releases)). After upgrading those packages, download the matching assets again and replace the files in `web/`. In production, serve `*.wasm` with `Content-Type: application/wasm`. Some browsers may use slower storage (e.g. private mode or without COOP/COEP); see [Drift web docs](https://drift.simonbinder.eu/web/).

### `lib/` layout (clean architecture)

| Folder | Role |
|--------|------|
| `lib/domain/` | Entities, value objects, repository **interfaces** — **pure Dart** (no `package:flutter`). |
| `lib/application/` | Use cases / orchestration — no Flutter UI. |
| `lib/data/` | Repository implementations, Drift (`lib/data/local/app_database.dart`), mappers. |
| `lib/presentation/` | Widgets, themes, navigation shell. |
| `lib/main.dart` | Entrypoint: `runApp` only. |

### Web-first Git scope

Native project trees **`android/`**, **`ios/`**, **`linux/`**, **`macos/`**, and **`windows/`** are listed in `.gitignore` so the repository stays focused on **Dart + web** sources. They are standard Flutter templates, not your app logic; you can recreate them anytime.

To restore all platforms locally (e.g. before mobile/desktop work):

```bash
flutter create . --project-name expense_app --org com.sevann.expense --platforms=android,ios,linux,macos,windows
```

Then remove those lines from `.gitignore` (or stop ignoring the folders you need) when you want to **commit** platform code to Git.

## Start here

| File | Purpose |
|------|---------|
| [docs/PROJECT_MASTER_PLAN.md](docs/PROJECT_MASTER_PLAN.md) | Phased roadmap, stack choice, domain summary, open questions |
| [docs/01-implementation-initial-plan.md](docs/01-implementation-initial-plan.md) | Step-by-step implementation plan 01 (foundation → MVP entry) |
| [docs/_templates/implementation-plan-template.md](docs/_templates/implementation-plan-template.md) | Template for `02-…` / `03-…` implementation plans (status + phases) |
| [Plantilla-2025-agent-prompt.mdc](docs/Plantilla-2025-agent-prompt.mdc) | Legacy Excel workbook structure (parity reference) |
| [Plantilla 2025.xlsx](docs/Plantilla%202025.xlsx) | Source Excel workbook (same folder as spec) |
| [.cursor/rules/](.cursor/rules/) | Implementation rules for the AI agent |

## Rules index

- `expense-app-project-context.mdc` — always on; stack defaults and pointers  
- `expense-app-business-domain.mdc` — categories, expenses, recurring, alerts  
- `expense-app-architecture.mdc` — clean architecture, layers  
- `expense-app-data-persistence.mdc` — local SQLite, migrations, export  
- `expense-app-implementation.mdc` — code style, i18n, money, tests  
- `expense-app-ui-ux.mdc` — charts, accessibility, navigation  

Keep `docs/` and `.cursor/rules/` in sync with the codebase you open in Cursor (paths may be gitignored in some clones).
