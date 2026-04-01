# Phase 8 — Extended integrations (analysis)

**Ordered doc:** [`08-phase-8-analysis.md`](08-phase-8-analysis.md). **Execution tracker:** [`08-implementation-phase-8-plan.md`](08-implementation-phase-8-plan.md).

**Purpose:** Hold **later** capabilities: bank/credit **statement import**, **FX quote** providers, extra **encrypted backup** options, **multi-book / profiles** if the product owner requests them. Only start after Phases **5–7** are stable. Phase 5 uses **Microsoft Azure** + **Entra External ID** per [`05-azure-hosting-strategy.md`](05-azure-hosting-strategy.md).

**Commit prefix for implementation:** **`08-`**

---

## 1. Candidate features (pick per priority)

| Track | Notes |
|--------|--------|
| **Bank / CSV import** | Parse CSV/OFX; map columns; duplicate detection; privacy — data stays user-controlled. |
| **FX API** | Optional auto-fill of rate vs USD; cache + offline fallback; ToS for provider. |
| **Backup extras** | Scheduled cloud export, E2E encryption — requires key management UX. |
| **Multi-book** | `profileId` scope in schema; switcher UI; migration from single book. |

---

## 2. Principles

- **No PAN/CVV** (unchanged).
- Each integration behind **feature flag** and **explicit opt-in**.

---

## 3. Reference

- [`PROJECT_MASTER_PLAN.md`](PROJECT_MASTER_PLAN.md) §6 Phase 8  
