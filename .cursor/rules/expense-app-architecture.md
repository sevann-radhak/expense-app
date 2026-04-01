---
description: Clean architecture, layers, feature boundaries, dependency direction
globs: "**/*.dart,**/lib/**/*,**/test/**/*"
alwaysApply: false
---

# Architecture Rules

## Layering

Use **clean / hexagonal** style:

1. **Domain:** entities, value objects, repository **interfaces**, domain services (pure Dart, no Flutter/Drift imports).
2. **Application:** use cases / interactors (orchestrate repositories; single responsibility).
3. **Infrastructure / data:** Drift DAOs, DTO↔entity mappers, repository implementations.
4. **Presentation:** Flutter widgets, state (Riverpod/Bloc), navigation.

**Dependency rule:** outer layers depend inward; domain depends on nothing project-specific.

## Feature organization

Prefer **feature-first** folders when scales: `features/expenses/`, `features/categories/`, each with `data`, `domain`, `presentation` subfolders **or** shared `core/domain` + feature presentation — pick one structure and document in README.

## Cross-cutting

- **Error handling:** `Result`/`Either` or sealed failure types for use cases; map to user-facing messages in presentation.
- **Clock / time:** inject `Clock` or `DateTimeProvider` for testability.
- **UUIDs:** string IDs (uuid v4) for primary keys unless Drift auto rowid + uuid column.

## Future sync / cloud

Define **repository interfaces** in domain now. Add `SyncGateway` / `RemoteExpenseSource` interfaces **without** implementations until the Phase 5 sync slice. No domain type should reference HTTP or vendor auth SDKs. **Target:** **`expense-app-backend`** (ASP.NET Core) + **Azure SQL** + **Entra**-issued tokens (`msal` only in presentation/application)—see `docs/05-azure-hosting-strategy.md` and `docs/05-implementation-phase-5-plan.md`.

## Parity with Excel

Use `docs/Plantilla-2025-agent-prompt.mdc` as **reference**, not as file format. Month boundaries in app = **queries** on `occurredOn`, not separate tables per month.

## Testing hooks

Use cases must be unit-testable with **in-memory fake repositories**. Do not test Drift inside domain tests.
