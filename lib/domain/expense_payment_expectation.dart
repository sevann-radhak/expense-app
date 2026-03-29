import 'package:expense_app/domain/expense.dart';
import 'package:expense_app/domain/payment_expectation_status.dart';

extension ExpensePaymentExpectationX on Expense {
  /// Rows linked to a series default to [PaymentExpectationStatus.expected] when unset (pre-migration).
  PaymentExpectationStatus? get effectivePaymentExpectationStatus {
    if (recurringSeriesId == null || recurringSeriesId!.isEmpty) {
      return paymentExpectationStatus;
    }
    return paymentExpectationStatus ?? PaymentExpectationStatus.expected;
  }
}
