---
description: Local-first storage, Drift/SQLite, migrations, export, future remote adapter
globs: "**/data/**/*,*drift*,**/*.drift,**/migrations/**/*"
alwaysApply: false
---

# Data & Persistence Rules

## Phase 1 — Device-local only

- Primary store: **SQLite** via **Drift** in the app sandbox. **Web is a first-class target:** use Drift **for web** (WASM / sql.js per package docs) and document limitations (private mode, storage eviction) in README.
- **Versioned migrations** for every schema change; never destructive migrate without user backup path.
- **No** silent data loss on upgrade.

## Export / backup

- Provide **export** to JSON or CSV (minimum: expenses + categories) from settings.
- Import optional in later phase; design export schema with **version field** for forward compatibility.

## Security

- Local DB file: rely on OS sandbox; document threat model (rooted devices).
- Future cloud: **encrypt at rest** for backups; never log PII or amounts in production logs.

## Mapping

- **Tables** reflect query needs; normalize categories/subcategories; expenses reference IDs with FK constraints where supported.
- Store **amounts** as integer **minor units** (e.g. cents) or **Decimal** via fixed-scale strategy — document choice; avoid `double` for money.

## FX and USD

- Persist `fxRateToUsd` and computed `amountUsd` as entered/calculated; if recomputed in app, single function in domain **Money** or **Fx** service.

## Future persistence

- Implement `ExpenseRepository` in `data/local/` first; add `data/remote/` only behind the same interface.
- Eventual **sync**: consider last-write-wins with audit log or CRDT later — **do not** implement until Phase 7 spec exists.
