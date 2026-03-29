import 'package:flutter_test/flutter_test.dart';

import 'package:expense_app/domain/partial_payment.dart';

void main() {
  test('PartialPayment holds fields (Phase 4.8 stub)', () {
    final p = PartialPayment(
      id: 'pp1',
      expenseId: 'e1',
      amountUsd: 10.5,
      paidOn: DateTime(2026, 3, 1),
      note: 'n',
    );
    expect(p.id, 'pp1');
    expect(p.expenseId, 'e1');
  });
}
