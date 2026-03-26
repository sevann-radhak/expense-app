# Personal expense app — planning repo

This folder holds **planning and Cursor rules** for replacing the Excel-based expense workflow with a **Flutter** **web-first**, then **mobile**, app (see `docs/PROJECT_MASTER_PLAN.md`).

## Start here

| File | Purpose |
|------|---------|
| [docs/PROJECT_MASTER_PLAN.md](docs/PROJECT_MASTER_PLAN.md) | Phased roadmap, stack choice, domain summary, open questions |
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

The actual Flutter project may live in this repo (future) or a new repository; keep `docs/` and `.cursor/rules/` in sync with the codebase you open in Cursor.
