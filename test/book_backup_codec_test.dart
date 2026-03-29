import 'package:flutter_test/flutter_test.dart';

import 'package:expense_app/application/application.dart';
import 'package:expense_app/domain/domain.dart';

void main() {
  test('encodeBookBackupPretty round-trips through decodeBookBackup', () {
    final snap = BookBackupSnapshot(
      schemaVersion: BookBackupSnapshot.currentSchemaVersion,
      exportedAt: DateTime.utc(2026, 3, 15, 12),
      categories: const [
        Category(id: 'c1', name: 'A', sortOrder: 0),
      ],
      subcategories: const [
        Subcategory(
          id: 's1',
          categoryId: 'c1',
          name: 'Sub',
          slug: 'sub_slug',
          isSystemReserved: false,
          sortOrder: 0,
        ),
      ],
      paymentInstruments: const [
        PaymentInstrument(id: 'pi1', label: 'Card'),
      ],
      expenses: [
        Expense(
          id: 'e1',
          occurredOn: DateTime(2026, 3, 1),
          categoryId: 'c1',
          subcategoryId: 's1',
          amountOriginal: 10,
          currencyCode: 'USD',
          manualFxRateToUsd: 1,
          amountUsd: 10,
          paidWithCreditCard: false,
          paymentInstrumentId: null,
        ),
      ],
    );
    final json = encodeBookBackupPretty(snap);
    final back = decodeBookBackup(json);
    expect(back.categories.length, 1);
    expect(back.subcategories.length, 1);
    expect(back.paymentInstruments.length, 1);
    expect(back.expenses.length, 1);
    expect(back.expenses.single.id, 'e1');
    expect(back.expenses.single.paymentInstrumentId, isNull);
  });

  test('decodeBookBackup rejects wrong schemaVersion', () {
    expect(
      () => decodeBookBackup('{"schemaVersion":999,"exportedAt":"2026-01-01T00:00:00.000Z","categories":[],"subcategories":[],"paymentInstruments":[],"expenses":[]}'),
      throwsA(isA<FormatException>()),
    );
  });
}
