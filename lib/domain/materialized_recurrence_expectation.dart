import 'package:expense_app/domain/expense_inclusion.dart';
import 'package:expense_app/domain/payment_expectation_status.dart';

/// Default disposition for a materialized recurring row when it is created or
/// regenerated: past and **today** count as already settled (paid / received);
/// strictly future dates stay [PaymentExpectationStatus.expected].
({
  PaymentExpectationStatus status,
  DateTime? confirmedOn,
}) expectationForMaterializedRecurringDate({
  required DateTime occurrenceDate,
  required DateTime todayDateOnly,
}) {
  final o = calendarDateOnly(occurrenceDate);
  final t = calendarDateOnly(todayDateOnly);
  if (!o.isAfter(t)) {
    return (
      status: PaymentExpectationStatus.confirmedPaid,
      confirmedOn: o,
    );
  }
  return (
    status: PaymentExpectationStatus.expected,
    confirmedOn: null,
  );
}
