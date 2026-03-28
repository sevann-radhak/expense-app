import 'package:flutter_test/flutter_test.dart';

import 'package:expense_app/domain/domain.dart';

void main() {
  group('calendarDateOnly', () {
    test('strips time', () {
      final d = DateTime(2026, 3, 15, 23, 59);
      expect(calendarDateOnly(d), DateTime(2026, 3, 15));
    });
  });

  group('isRealizedOnLocalCalendar', () {
    final today = DateTime(2026, 6, 10);

    test('same calendar day is realized', () {
      expect(
        isRealizedOnLocalCalendar(DateTime(2026, 6, 10, 8, 0), today),
        isTrue,
      );
    });

    test('yesterday is realized', () {
      expect(isRealizedOnLocalCalendar(DateTime(2026, 6, 9), today), isTrue);
    });

    test('tomorrow is not realized', () {
      expect(isRealizedOnLocalCalendar(DateTime(2026, 6, 11), today), isFalse);
    });
  });

  group('applyExpenseInclusion', () {
    final today = DateTime(2026, 4, 1);
    final ePast = Expense(
      id: 'a',
      occurredOn: DateTime(2026, 3, 31),
      categoryId: 'c',
      subcategoryId: 's',
      amountOriginal: 1,
      currencyCode: 'USD',
      manualFxRateToUsd: 1,
      amountUsd: 1,
      paidWithCreditCard: false,
    );
    final eToday = Expense(
      id: 'b',
      occurredOn: DateTime(2026, 4, 1, 12),
      categoryId: 'c',
      subcategoryId: 's',
      amountOriginal: 2,
      currencyCode: 'USD',
      manualFxRateToUsd: 1,
      amountUsd: 2,
      paidWithCreditCard: false,
    );
    final eFuture = Expense(
      id: 'c',
      occurredOn: DateTime(2026, 4, 2),
      categoryId: 'c',
      subcategoryId: 's',
      amountOriginal: 3,
      currencyCode: 'USD',
      manualFxRateToUsd: 1,
      amountUsd: 3,
      paidWithCreditCard: false,
    );
    final all = [ePast, eToday, eFuture];

    test('all returns copy of list', () {
      final out = applyExpenseInclusion(all, ExpenseInclusion.all, today);
      expect(out.length, 3);
      expect(out, isNot(same(all)));
    });

    test('realizedOnly excludes future', () {
      final out = applyExpenseInclusion(
        all,
        ExpenseInclusion.realizedOnly,
        today,
      );
      expect(out.map((e) => e.id).toList(), ['a', 'b']);
    });

    test('scheduledOnly is strictly after today', () {
      final out = applyExpenseInclusion(
        all,
        ExpenseInclusion.scheduledOnly,
        today,
      );
      expect(out.single.id, 'c');
    });
  });
}
