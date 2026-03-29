import 'package:expense_app/domain/expense.dart';
import 'package:expense_app/domain/expense_inclusion.dart';
import 'package:expense_app/domain/expense_payment_expectation.dart';
import 'package:expense_app/domain/income_entry.dart';
import 'package:expense_app/domain/income_expectation.dart';
import 'package:expense_app/domain/payment_expectation_status.dart';

/// True when the line should be treated as paid/received (or otherwise closed),
/// as opposed to still scheduled and awaiting confirmation.
///
/// [todayDateOnly] must be calendar date-only (local).
bool isEconomicallySettledExpense(Expense expense, DateTime todayDateOnly) {
  final d = calendarDateOnly(expense.occurredOn);
  final t = calendarDateOnly(todayDateOnly);
  final recurring = expense.recurringSeriesId != null &&
      expense.recurringSeriesId!.isNotEmpty;
  final st = expense.effectivePaymentExpectationStatus;
  if (st == PaymentExpectationStatus.confirmedPaid ||
      st == PaymentExpectationStatus.skipped ||
      st == PaymentExpectationStatus.waived) {
    return true;
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

/// Same semantics as [isEconomicallySettledExpense] for income lines.
bool isEconomicallySettledIncome(IncomeEntry entry, DateTime todayDateOnly) {
  final d = calendarDateOnly(entry.receivedOn);
  final t = calendarDateOnly(todayDateOnly);
  final recurring =
      entry.recurringSeriesId != null && entry.recurringSeriesId!.isNotEmpty;
  final st = entry.effectiveExpectationStatus;
  if (st == PaymentExpectationStatus.confirmedPaid ||
      st == PaymentExpectationStatus.skipped ||
      st == PaymentExpectationStatus.waived) {
    return true;
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
