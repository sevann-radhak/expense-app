import 'package:expense_app/domain/domain.dart';
import 'package:expense_app/l10n/app_localizations.dart';

enum RecurringIncomeTileAction {
  /// Opens the same editor as tapping the row (paid/received uses the row control).
  update,
  skip,
  delete,
}

String recurringIncomeExpectationChipLabel(
  IncomeEntry entry,
  AppLocalizations l10n,
) {
  final s = entry.effectiveExpectationStatus;
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
