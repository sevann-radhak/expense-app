import 'package:expense_app/domain/domain.dart';
import 'package:expense_app/l10n/app_localizations.dart';
import 'package:expense_app/presentation/expenses/recurring_expense_ui.dart';
import 'package:expense_app/presentation/incomes/recurring_income_ui.dart';

/// Status chip for list tiles: recurring rows always show; one-off future rows
/// show expected vs confirmed. Past/today one-offs omit the chip when uncluttered.
String? expenseExpectationChipLabel(
  Expense expense,
  AppLocalizations l10n,
  DateTime todayDateOnly,
) {
  if (expense.recurringSeriesId?.isNotEmpty == true) {
    return recurringPaymentExpectationChipLabel(expense, l10n);
  }
  final d = calendarDateOnly(expense.occurredOn);
  final t = calendarDateOnly(todayDateOnly);
  if (!d.isAfter(t)) {
    return null;
  }
  final s = expense.paymentExpectationStatus;
  if (s == null) {
    return l10n.paymentExpectationExpectedShort;
  }
  return switch (s) {
    PaymentExpectationStatus.expected => l10n.paymentExpectationExpectedShort,
    PaymentExpectationStatus.confirmedPaid =>
      l10n.paymentExpectationConfirmedShort,
    PaymentExpectationStatus.skipped => l10n.paymentExpectationSkippedShort,
    PaymentExpectationStatus.waived => l10n.paymentExpectationWaivedShort,
  };
}

String? incomeExpectationChipLabel(
  IncomeEntry entry,
  AppLocalizations l10n,
  DateTime todayDateOnly,
) {
  if (entry.recurringSeriesId?.isNotEmpty == true) {
    return recurringIncomeExpectationChipLabel(entry, l10n);
  }
  final d = calendarDateOnly(entry.receivedOn);
  final t = calendarDateOnly(todayDateOnly);
  if (!d.isAfter(t)) {
    return null;
  }
  final s = entry.expectationStatus;
  if (s == null) {
    return l10n.paymentExpectationExpectedShort;
  }
  return switch (s) {
    PaymentExpectationStatus.expected => l10n.paymentExpectationExpectedShort,
    PaymentExpectationStatus.confirmedPaid =>
      l10n.paymentExpectationConfirmedShort,
    PaymentExpectationStatus.skipped => l10n.paymentExpectationSkippedShort,
    PaymentExpectationStatus.waived => l10n.paymentExpectationWaivedShort,
  };
}
