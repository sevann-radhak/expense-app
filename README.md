# Personal expense app — planning repo

This repository contains the **Flutter** app (package `expense_app`) plus planning references for replacing the Excel-based expense workflow with a **web-first**, then **mobile**, product (see `docs/PROJECT_MASTER_PLAN.md`).

## Run the app (web)

1. Install [Flutter](https://docs.flutter.dev/get-started/install) on the **stable** channel and enable web (`flutter config --enable-web`).
2. From the repo root: `flutter pub get`
3. Run in Chrome: `flutter run -d chrome`

For a release build: `flutter build web`.

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
