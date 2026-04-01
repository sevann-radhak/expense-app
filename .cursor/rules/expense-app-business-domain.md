---
description: Domain rules — categories, expenses, recurring, installments, alerts, income placeholder
globs: "**/*.dart"
alwaysApply: false
---

# Business & Domain Rules

## Categories and subcategories

- Users **create, update, delete** categories and subcategories.
- Each category **must** expose exactly one system subcategory **`other`** (slug `other`; localized label via ARB). It **cannot** be deleted or reassigned to another category.
- Deleting a category: **soft-delete** or **reassign** expenses first — never orphan expenses; agent must define explicit policy in use cases.
- **Seed** initial taxonomy from the Excel template (Formación, Gastos_Fijos, Impuestos, Inversiones, Ocio, Salud, Transporte, Vivienda) plus **Other** under each. Seed runs on first launch or explicit "load defaults".

## Expense (transaction)

Required associations: **category**, **subcategory** (must belong to that category), **occurred date** (**calendar date only — no time**), **detail/description**.

Financial fields:

- **`localAmount`** in user's **default currency** (default ARS).
- **`fxRateToUsd`**: optional; manual entry in early phases; when absent, USD equivalent is empty or explicitly "N/A" in reports.
- **`amountUsd`**: derived when rate present: `localAmount / fxRateToUsd` (document rounding: e.g. 4 decimal internal, 2 for display).
- **`paidWithCreditCard`**: boolean.
- Optional **`paymentInstrumentId`**: references a **credit card profile** (metadata only).

Validation: subcategory.categoryId must match expense.categoryId. If `paidWithCreditCard` and a **default instrument** exists, pre-fill but allow override.

## User configuration (evolve to full "user settings")

Model settings early even with a single local profile:

- `locale` (default `en`), `defaultCurrency` (default **ARS**).
- **CreditCardProfile**: id, displayName, bankName, annualFee, monthlyFee, feePercentages (structured), billingCycleAnchorDay, notes.
- **defaultCreditCardProfileId** for suggestions.

## Recurring / fixed expenses

- **RecurringExpenseRule**: cadence (monthly, weekly), **amountMode** `fixed | variable`, amount template for fixed, **nextExpectedDate**, link to category/subcategory, optional instrument.
- **Variable**: prompt user when period opens or use "copy last amount" pattern.

## Installments / scheduled payments

- **InstallmentPlan**: principal total, currency, start date, installment count, period length (e.g. monthly), category/subcategory, optional card profile.
- Generate **InstallmentOccurrence** schedule; allow marking paid and linking to a real **Expense** row.

## Alerts and data quality

Define **Alert** or **Issue** value objects: type (e.g. `missingFxForUsdReport`, `suspectedDuplicate`, `recurringOverdue`, `installmentDue`, `budgetExceeded` future), severity, payload, `dismissedAt`.

Reconciliation: support rules similar in spirit to Excel "sums must match" (e.g. monthly total vs sum of category buckets) where product defines the check.

## Income (future)

- Reserve interfaces or empty modules for **IncomeEntry** and **CashflowReport** without implementing full UI until Phase 7+.

## Naming

Ubiquitous language in **English** in code: `Expense`, `Category`, `Subcategory`, `CreditCardProfile`, `RecurringRule`, `InstallmentPlan`.
