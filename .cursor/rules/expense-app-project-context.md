---
description: Project identity, stack default, doc pointers, phased delivery index (Flutter repo only)
alwaysApply: true
---

# Expense Tracker — Project Context

**Repository:** **`expense-app`** (Flutter + Dart only). The HTTP API is **`expense-app-backend`** (separate clone; ASP.NET Core + Swagger). Do not add `backend/` here.

## Purpose

Build a **local-first** personal expense app (**web first, then mobile**) replacing yearly Excel workbooks. Progressive parity with `docs/Plantilla 2025.xlsx`; see `docs/PROJECT_MASTER_PLAN.md` and `docs/Plantilla-2025-agent-prompt.mdc`.

## Default stack (unless explicitly changed)

- **Flutter + Dart**, **Drift** (SQLite), **Riverpod** (or Bloc — pick one and stay consistent).
- **English** for code, identifiers, and technical docs. **UI strings** externalized for **i18n** (start with `en`; structure for more locales).

## Delivery model

Implement **by phase** in `PROJECT_MASTER_PLAN.md`. **Target web** until the current phase scope is solid; **then** ship native mobile. Do not skip ahead into sync/auth/cloud until persistence and domain boundaries are stable.

## Decided product rules

- **Expense date:** calendar date **only** (no time-of-day).
- **v1 data scope:** **single book** per app install / browser storage (no multi-profile UI unless product owner requests it).

## Non-negotiables

- **No** storage of full card numbers, CVV, or PIN. Only **card profile metadata** (label, bank, fees, cycle).
- **Domain layer** must not import Flutter or SQLite APIs.
- Every category has a reserved **Other** subcategory; cannot be deleted.
- Prefer **small, reviewable PRs** aligned to one phase or feature slice.

## Phase 5 cloud target

- **Microsoft Azure** — **Entra External ID** (email + Microsoft + Google as configured), **Azure SQL**, **ASP.NET Core** API in repo **`expense-app-backend`**, **Static Web Apps** for Flutter web. Environments: **local** (PC) → **Azure Dev** → **Azure Prod** (`docs/05-azure-hosting-strategy.md`).
- **Order:** Finish the **local MVP** (`docs/05-implementation-phase-5-plan.md` **Local MVP gate**) before provisioning **billable** Azure Dev/Prod compute or SQL. **One** Azure subscription + separate **resource groups** per app/env unless a client requires a dedicated subscription.

## When unsure

Ask the product owner rather than guessing **multi-profile**, **sync**, or **fiscal rules** not listed in `PROJECT_MASTER_PLAN.md`.
