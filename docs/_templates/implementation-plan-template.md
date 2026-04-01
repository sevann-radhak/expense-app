# {TITLE} — implementation plan (`NN-` series)

**Ordered doc:** Use a **zero-padded** numeric prefix in the filename (e.g. `02-feature-name.md`) so plans sort in `docs/`. Copy this file and replace `{TITLE}`, `{NN}`, and phase rows.

**Phase 2 in this repo (paired `02-` docs):** [`02-reports-and-foundations-phase-2.md`](../02-reports-and-foundations-phase-2.md) holds **product/spec**; [`02-implementation-phase-2-plan.md`](../02-implementation-phase-2-plan.md) holds the **execution tracker**. Use a **distinct slug** after the `NN-` prefix when adding another doc at the same number.

**How to use:** Keep **`Status:`** in sync with the **Phase overview** table. Use **`in progress`** only while the phase is actively being worked on. Set **`done`** when **Acceptance** is satisfied. Use **`review`** only when completed work needs follow-up adjustments or a revision pass — not as a routine post-implementation state. For each **Suggested commit subject**, prefix the imperative line with the same **`NN-`** as this doc’s filename (e.g. **`01-Add feature foo`**, **`02-Add report charts`**).

---

## Phase status legend

| Value | When to use |
|--------|-------------|
| `pending` | Not started. |
| `in progress` | Currently implementing or actively working on this phase. |
| `done` | **Acceptance** satisfied; phase accepted. |
| `review` | Complete work needs revisions or a follow-up pass (adjustments, fixes); not for normal “awaiting verification”. |

---

## Phase overview

| Phase | Status |
|-------|--------|
| {phase_id} — {short name} | `pending` |
| … | `pending` |

---

## Phase {X.Y} — {Title}

**Status:** `pending`

**Goal:** {One sentence.}

**Steps:**

1. {…}

**Acceptance:**

- {…}

**Suggested commit subject:** `{NN}-{Imperative English ≤8 words}`

---

## Reference

- Product / ADR / master plan links.
- Agent rules: `.cursor/rules/expense-app-*.md` (if applicable).
