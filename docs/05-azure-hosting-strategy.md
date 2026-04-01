# Phase 5 — Azure hosting, environments, and cost gates

**Normative for:** where cloud **money** may be spent, how **local / dev / prod** are defined, and how this repo doubles as the **first** Azure product in a broader portfolio.  
**Companion:** [`05-implementation-phase-5-plan.md`](05-implementation-phase-5-plan.md) (execution tracker), [`05-sync-spec.md`](05-sync-spec.md) (data contract).

**Language:** English (project standard for technical docs).

---

## 1. Purpose and strategic fit

- **Goal:** Standardize on **Microsoft Azure** for backend, identity integration, and production hosting so the same patterns (resource groups, monitoring, budgets, IaC) apply to **future apps and customer projects**.
- **This repository:** Serves as the **learning and template** project—accounts, subscriptions, naming conventions, and pipelines—without assuming multi-tenant billing or subscriptions on day one.
- **Near-term usage:** **Personal** (one or very few users, low transaction volume). Design choices should remain **compatible** with more users and paid offerings later (clear `user_id` scoping, auditable APIs, deletion story).

**Non-goal for this doc:** Step-by-step Azure Portal clicks (those change); use this as a **checklist** and hand off detailed procedures to runbooks or IaC when implemented.

### 1.1 Azure subscription layout (recommended)

Use **one** Azure **subscription** for your personal and portfolio apps. Isolate workloads with **resource groups** (e.g. `rg-expense-tracker-dev`, `rg-expense-tracker-prod`, later `rg-other-product-dev`). **Benefits:** single invoice, one **Cost Management** dashboard, simpler budgets. Open a **second subscription** when a **client contract** or legal entity requires **hard billing separation**.

---

## 2. What the backend must provide

For **consistency and durable user data** (aligned with [`05-sync-spec.md`](05-sync-spec.md)):

| Capability | Role |
|------------|------|
| **Identity** | Issue and validate tokens tied to a stable **user id** (sign-up, sign-in, sign-out, password reset flows as needed). |
| **Authoritative store** | **Azure SQL** (or Postgres on Azure if you standardize on Postgres later) holds the **server copy** of the book per user. |
| **HTTP API** | Authenticated endpoints for **snapshot and/or delta sync**, idempotent writes, predictable errors (see Phase 5.4 in the implementation plan). |
| **Authorization** | Every row or payload scoped by **authenticated user**; no cross-user reads/writes (RLS in Postgres, or **API + stored procedures / parameterized queries** in SQL Server with explicit `user_id` checks). |
| **TLS** | HTTPS everywhere between clients and API. |

**Flutter mobile and web:** Same app; **Drift remains local-first** on device/browser. The client calls your **API** with a **Bearer token** after login; offline queue and sync behavior are implemented in the app (Phase 5.5). No separate “mobile backend”—only **one API** with mobile-friendly timeouts and payload sizes.

---

## 3. Environments: local, Azure Dev, Azure Prod

| Environment | Intent | Azure consumption | Data / compute |
|-------------|--------|-------------------|----------------|
| **Local** | Implementation on your machine (primary dev). | **$0** Azure infrastructure. | **Drift/SQLite** (Flutter repo); **`expense-app-backend`** `ExpenseTracker.Api` on **Kestrel** (Swagger at `/swagger`); optional **Docker SQL Server** / LocalDB; **Azurite** if needed. JWT: mock middleware or dev-only keys until MSAL is wired. |
| **Azure Dev** | Hosted mirror for integration testing and shared QA. | **Billable** (use smallest SKUs). | **Only after** the [**Local MVP gate**](05-implementation-phase-5-plan.md#local-mvp-gate) in the implementation plan. Typical: `rg-expense-tracker-dev`, non-prod **Azure SQL**, API host (**Functions** consumption or **App Service**), **Entra External ID** redirects to dev URLs. |
| **Azure Prod** | End users and durable production data. | **Billable**. | **After** Dev smoke tests and the [**Azure provisioning gate**](05-implementation-phase-5-plan.md#azure-provisioning-gate-after-local-mvp). Typical: `rg-expense-tracker-prod`, **Static Web Apps** for Flutter web, production SQL + API. |

**Principle:** **No** billable **Azure SQL** or **cloud-hosted API** for this product until the **local** stack proves the MVP. Entra **app registrations** in the tenant are usually fine to create early (no compute meter).

---

## 4. Azure inventory (what to create, and when)

### 4.1 Safe to do early (typically no recurring infrastructure charge)

These help you **learn the portal** and **prepare** without committing to database compute:

- **Azure account + subscription** (billing account exists; **no monthly fee** for an empty subscription).
- **Microsoft Entra ID** (directory): **App registrations** for the API and for the Flutter client (public client) are **free**; you pay for **MAU**-priced features if you adopt **Entra External ID** (CIAM) at scale—fine for personal MVP within free/low tiers; verify current pricing before enabling premium features.
- **Naming convention** and **documentation** in repo (resource prefixes, `rg-expense-tracker-prod`, etc.).
- **IaC skeleton** (Bicep/Terraform) **in Git** without deploying, or deploy only **free-tier** static placeholders if you accept any metered edge cases.

**Caution:** Some services (e.g. **Key Vault**, **Log Analytics**) can incur **small** charges at scale or with certain operations; for **personal** use they are often negligible—still set **budgets** as soon as a subscription has any resource.

### 4.2 After local MVP + owner approval — Azure Dev and Prod (lowest practical cost)

Target a **small** footprint; adjust SKUs with current Azure pricing pages.

| Resource | Typical use | Cost mindset |
|----------|-------------|--------------|
| **Resource group** | `rg-expense-tracker-prod` | Free. |
| **Azure SQL Database** | **Serverless** or **small vCore / DTU** tier; single database per app for v1. | Often **largest** line item for always-on SQL; **auto-pause** serverless reduces idle cost; backups may add. |
| **Azure Functions (Consumption)** or **Container Apps (consumption)** | HTTP API for sync + health. | Pay per execution; very low for 1 user. Cold start acceptable for personal use. |
| **Storage account** | Function triggers, artifacts, optional snapshots. | Usually **small** at low volume. |
| **Azure Static Web Apps** (Free SKU where sufficient) or **Storage static website + CDN** | Host Flutter **web** `build/web`. | SWA Free tier fits many hobby projects; verify bandwidth limits. |
| **Application Insights** | Logs and basic metrics. | Often **low** with sampling; can grow with volume—set caps. |
| **Key Vault** (optional for prod secrets) | API keys, connection strings. | Prefer **managed identity** from Functions to SQL to reduce secret sprawl; vault operations are usually cheap at hobby scale. |
| **Microsoft Entra ID / External ID** | User sign-in for the app. | MAU-based pricing for external identities—check current **free tier** thresholds. |

**Not required for personal MVP:** Multi-region HA, API Management (unless you want a unified edge for many products later), dedicated App Service Plan (unless Functions constraints bite).

### 4.3 Future portfolio (multiple products / clients)

When you add more apps:

- **Separate resource groups** (or subscriptions per customer if billing isolation is required).
- **Reuse:** same **tenant** and **patterns** (Function + SQL + Static Web Apps), **different** databases and app registrations.
- **Centralize:** naming, budgets, and **Cost Management + alerts** at subscription level.

---

## 5. Cost warnings and habits

1. **Azure SQL** is rarely “free forever” for production-shaped workloads—**serverless + auto-pause** is the usual **cost minimization** lever for intermittent use.
2. **Always-on App Service** (lowest SKUs) is a **fixed monthly** cost; prefer **consumption** compute until you need always-on.
3. **Egress** (data out of Azure) and **CDN** can surprise you if the app moves large payloads; snapshot sync should stay **bounded** (see sync spec).
4. **Free trials / credits** expire—**budget alerts** (e.g. email at 5 € / 20 €) should be configured **before** first billable resource.
5. **Destroy sandboxes** when not in use if you spun up SQL “just to try.”
6. Pricing changes—re-validate before provisioning.

---

## 6. Local machine (“third environment”) — concrete local artifacts

What you maintain **on your PC** without Azure spend:

- **Flutter repo** with `--dart-define=AZURE_API_BASE_URL=...` (or gitignored env) pointing to the local Kestrel base URL (see `dotnet run` output) or a local Functions host.
- **Drift** database files as today.
- **Optional Docker Compose:** SQL Server container + run API locally against it.
- **Azure Functions Core Tools** for local function host (no cloud charge).
- **Azurite** if the API uses queues/tables locally.
- **Tests:** mocked HTTP or **Testcontainers** / local SQL for contract tests—no cloud dependency in CI if desired.

**Entra / dev tenant:** You can use a **separate app registration** “ExpenseTracker-Dev” with redirect URIs for `localhost`—still free tier for normal dev sign-ins; keeps prod app registration clean.

---

## 7. Current codebase anchor

**Backend repo:** **`expense-app-backend`** → `ExpenseTracker.Api` (`/api/health`, `/api/hello`, Swagger at `/swagger`). **Flutter** remote base URL: [`lib/application/cloud_backend_env.dart`](../lib/application/cloud_backend_env.dart). **Auth** packages (e.g. **MSAL**) are added when subphase **5.5** starts.

---

## 8. References

- [`05-implementation-phase-5-plan.md`](05-implementation-phase-5-plan.md) — subphases, **local** and **Azure** gates, execution status.  
- [`05-sync-spec.md`](05-sync-spec.md) — sync contract.  
- [`05-phase-5-analysis.md`](05-phase-5-analysis.md) — broader platform notes.  
- [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/)  
- [Microsoft Entra External ID pricing](https://www.microsoft.com/security/business/microsoft-entra-pricing) (verify current MAU free tier)
