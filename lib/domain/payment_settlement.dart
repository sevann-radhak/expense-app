import 'package:expense_app/domain/expense.dart';
import 'package:expense_app/domain/expense_inclusion.dart';
import 'package:expense_app/domain/expense_payment_expectation.dart';
import 'package:expense_app/domain/income_entry.dart';
import 'package:expense_app/domain/income_expectation.dart';
import 'package:expense_app/domain/payment_expectation_status.dart';

/// True when the line counts as paid (expense) for settlement UI and for
/// report “confirmed” stacks — not the same as [isExpenseExcludedFromCashflowTotals].
///
/// Skipped/waived rows return false here so they are not shown as “paid” in charts;
/// they are omitted from totals via [isExpenseExcludedFromCashflowTotals].
///
/// [todayDateOnly] must be calendar date-only (local).
bool isEconomicallySettledExpense(Expense expense, DateTime todayDateOnly) {
  final d = calendarDateOnly(expense.occurredOn);
  final t = calendarDateOnly(todayDateOnly);
  final recurring = expense.recurringSeriesId != null &&
      expense.recurringSeriesId!.isNotEmpty;
  final st = expense.effectivePaymentExpectationStatus;
  if (st == PaymentExpectationStatus.confirmedPaid) {
    return true;
  }
  if (st == PaymentExpectationStatus.skipped ||
      st == PaymentExpectationStatus.waived) {
    return false;
  }
  if (!recurring) {
    if (expense.paymentExpectationStatus ==
        PaymentExpectationStatus.expected) {
      return false;
    }
    return !d.isAfter(t);
  }
  return false;
}

/// Same as [isEconomicallySettledExpense] for income (received vs still expected).
bool isEconomicallySettledIncome(IncomeEntry entry, DateTime todayDateOnly) {
  final d = calendarDateOnly(entry.receivedOn);
  final t = calendarDateOnly(todayDateOnly);
  final recurring =
      entry.recurringSeriesId != null && entry.recurringSeriesId!.isNotEmpty;
  final st = entry.effectiveExpectationStatus;
  if (st == PaymentExpectationStatus.confirmedPaid) {
    return true;
  }
  if (st == PaymentExpectationStatus.skipped ||
      st == PaymentExpectationStatus.waived) {
    return false;
  }
  if (!recurring) {
    if (entry.expectationStatus == PaymentExpectationStatus.expected) {
      return false;
    }
    return !d.isAfter(t);
  }
  return false;
}

/// Inline paid/unpaid control is hidden for skipped or waived lines (use overflow menu).
bool showInlineSettlementToggleForExpense(Expense expense) {
  final s = expense.effectivePaymentExpectationStatus;
  return s != PaymentExpectationStatus.skipped &&
      s != PaymentExpectationStatus.waived;
}

/// Same as [showInlineSettlementToggleForExpense] for income rows.
bool showInlineSettlementToggleForIncome(IncomeEntry entry) {
  final s = entry.effectiveExpectationStatus;
  return s != PaymentExpectationStatus.skipped &&
      s != PaymentExpectationStatus.waived;
}

/// Applies list-row toggle: paid (confirmed on occurrence or today if future) vs expected.
Expense withExpenseSettlementChoice(
  Expense expense,
  bool settled,
  DateTime todayDateOnly,
) {
  final occ = calendarDateOnly(expense.occurredOn);
  final t = calendarDateOnly(todayDateOnly);
  if (settled) {
    return expense.copyWith(
      paymentExpectationStatus: PaymentExpectationStatus.confirmedPaid,
      paymentExpectationConfirmedOn: occ.isAfter(t) ? t : occ,
    );
  }
  return expense.copyWith(
    paymentExpectationStatus: PaymentExpectationStatus.expected,
    clearPaymentExpectationConfirmedOn: true,
  );
}

/// Skipped or waived materialized occurrences do not count toward cashflow totals
/// or annual/monthly report stacks (treated as annulled for money; row kept for history).
bool isExpenseExcludedFromCashflowTotals(Expense expense) {
  final s = expense.effectivePaymentExpectationStatus;
  return s == PaymentExpectationStatus.skipped ||
      s == PaymentExpectationStatus.waived;
}

/// Same as [isExpenseExcludedFromCashflowTotals] for income.
bool isIncomeExcludedFromCashflowTotals(IncomeEntry entry) {
  final s = entry.effectiveExpectationStatus;
  return s == PaymentExpectationStatus.skipped ||
      s == PaymentExpectationStatus.waived;
}

IncomeEntry withIncomeSettlementChoice(
  IncomeEntry entry,
  bool settled,
  DateTime todayDateOnly,
) {
  final day = calendarDateOnly(entry.receivedOn);
  final t = calendarDateOnly(todayDateOnly);
  if (settled) {
    return entry.copyWith(
      expectationStatus: PaymentExpectationStatus.confirmedPaid,
      expectationConfirmedOn: day.isAfter(t) ? t : day,
    );
  }
  return entry.copyWith(
    expectationStatus: PaymentExpectationStatus.expected,
    clearExpectationConfirmedOn: true,
  );
}
