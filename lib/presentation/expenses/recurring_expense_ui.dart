import 'package:expense_app/domain/domain.dart';
import 'package:expense_app/l10n/app_localizations.dart';

/// Overflow actions for a scheduled recurring-generated expense (Phase 4.2).
enum RecurringExpenseTileAction {
  update,
  skip,
  restoreSkipped,
  delete,
}

String recurringPaymentExpectationChipLabel(
  Expense expense,
  AppLocalizations l10n,
) {
  final s = expense.effectivePaymentExpectationStatus;
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
