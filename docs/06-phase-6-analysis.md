# Phase 6 — Alerts and reconciliation (analysis)

**Ordered doc:** [`06-phase-6-analysis.md`](06-phase-6-analysis.md) — product and domain notes for **anomaly detection** and **data-quality / reconciliation** UX. **Execution tracker:** [`06-implementation-phase-6-plan.md`](06-implementation-phase-6-plan.md).

**Purpose:** Define what “alerts” mean in this app, how they relate to Excel-style checks, and how they run **after** Phase 5 so one **synced book** is the source of truth.

**Commit prefix for implementation:** **`06-`**

**Depends on:** [Phase 5](05-implementation-phase-5-plan.md) [**local MVP gate**](05-implementation-phase-5-plan.md#local-mvp-gate) (Entra + sync + Azure-aligned API proven **locally**, then hosted on Azure Dev/Prod) so rules target one **authoritative** book across devices.

---

## 1. Relationship to the master plan

[`PROJECT_MASTER_PLAN.md`](PROJECT_MASTER_PLAN.md) §5.6–5.7 described alerts early in the roadmap under **local-first** assumptions. The roadmap is **renumbered**: this content is **Phase 6**, immediately after cloud sync.

---

## 2. Product goals

1. **Surface issues** without blocking data entry (warnings, not hard errors unless critical).
2. **Excel-style reconciliation** where applicable: monthly totals sanity checks, category rollups vs line items (configurable tolerance).
3. **Operational alerts:** missing FX when USD reporting matters, duplicate-suspect rows (same day + amount + similar description), recurring / installment expectations (missed confirmation, due soon).
4. **Presentation:** dedicated **Issues** or **Insights** area on Home or Reports; optional **badges** on months with open issues.
5. **Severity:** info / warning / error (align with master plan §5.6).

---

## 3. Technical approach (high level)

- **Inputs:** read from **local Drift** after sync (same as today’s queries) plus optional **server-side** jobs later for email/push.
- **Rule engine:** pure Dart in **domain** or **application** — given a `BookSnapshot` or repository facades, produce `List<AlertIssue>` with stable `issueId` for dismiss/snooze.
- **Persistence:** optional `dismissed_issue_keys` in settings or table; **do not** mutate expenses automatically.
- **Push notifications:** **out of scope** for v1 of Phase 6 unless Phase 5 mobile permissions are already in place; document as Phase 6.2+.

---

## 4. Non-goals (Phase 6 v1)

- Full double-entry accounting validation.
- Bank feed matching.
- Real-time collaborative editing.

---

## 5. Reference

- [`PROJECT_MASTER_PLAN.md`](PROJECT_MASTER_PLAN.md) §5.6–5.7 (conceptual), §6 Phase 6  
- [`04-phase-4-analysis.md`](04-phase-4-analysis.md) §4.4 (expectation status — feeds alert rules)  
- [`05-phase-5-analysis.md`](05-phase-5-analysis.md) (sync model informs server vs client rule execution)
