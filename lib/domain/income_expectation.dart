import 'package:expense_app/domain/income_entry.dart';
import 'package:expense_app/domain/payment_expectation_status.dart';

extension IncomeEntryExpectationX on IncomeEntry {
  /// Rows linked to a series default to [PaymentExpectationStatus.expected] when unset.
  PaymentExpectationStatus? get effectiveExpectationStatus {
    if (recurringSeriesId == null || recurringSeriesId!.isEmpty) {
      return expectationStatus;
    }
    return expectationStatus ?? PaymentExpectationStatus.expected;
  }
}
