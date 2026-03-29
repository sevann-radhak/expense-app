import 'package:flutter_test/flutter_test.dart';

import 'package:expense_app/domain/domain.dart';

void main() {
  test('expectationForMaterializedRecurringDate confirms today and past only',
      () {
    final today = DateTime(2026, 6, 10);
    final past = expectationForMaterializedRecurringDate(
      occurrenceDate: DateTime(2026, 5, 1),
      todayDateOnly: today,
    );
    expect(past.status, PaymentExpectationStatus.confirmedPaid);
    expect(past.confirmedOn, DateTime(2026, 5, 1));

    final sameDay = expectationForMaterializedRecurringDate(
      occurrenceDate: DateTime(2026, 6, 10, 15, 30),
      todayDateOnly: today,
    );
    expect(sameDay.status, PaymentExpectationStatus.confirmedPaid);
    expect(sameDay.confirmedOn, DateTime(2026, 6, 10));

    final future = expectationForMaterializedRecurringDate(
      occurrenceDate: DateTime(2026, 6, 11),
      todayDateOnly: today,
    );
    expect(future.status, PaymentExpectationStatus.expected);
    expect(future.confirmedOn, isNull);
  });
}
