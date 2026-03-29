import 'package:flutter_test/flutter_test.dart';

import 'package:expense_app/application/expense_api_dto.dart';
import 'package:expense_app/domain/domain.dart';

void main() {
  test('ExpenseApiDto fromExpense and toExpense round-trip', () {
    final e = Expense(
      id: 'x',
      occurredOn: DateTime(2026, 4, 1),
      categoryId: 'c',
      subcategoryId: 's',
      amountOriginal: 3.5,
      currencyCode: 'EUR',
      manualFxRateToUsd: 0.5,
      amountUsd: 1.75,
      paidWithCreditCard: true,
      description: 'd',
      paymentInstrumentId: 'pi',
    );
    final dto = ExpenseApiDto.fromExpense(e);
    final back = dto.toExpense();
    expect(back.id, e.id);
    expect(back.occurredOn, e.occurredOn);
    expect(back.paymentInstrumentId, e.paymentInstrumentId);
  });

  test('ExpenseApiDto toJson and fromJson round-trip', () {
    const dto = ExpenseApiDto(
      id: 'a',
      occurredOn: '2026-05-20',
      categoryId: 'c',
      subcategoryId: 's',
      amountOriginal: 100,
      currencyCode: 'ARS',
      manualFxRateToUsd: 0.001,
      amountUsd: 0.1,
      paidWithCreditCard: false,
      description: 'note',
      paymentInstrumentId: null,
    );
    final map = dto.toJson();
    final back = ExpenseApiDto.fromJson(map);
    expect(back.id, dto.id);
    expect(back.occurredOn, dto.occurredOn);
    expect(back.description, dto.description);
  });

  test('ExpenseApiDto list JSON round-trip', () {
    final list = [
      const ExpenseApiDto(
        id: '1',
        occurredOn: '2026-01-01',
        categoryId: 'c',
        subcategoryId: 's',
        amountOriginal: 1,
        currencyCode: 'USD',
        manualFxRateToUsd: 1,
        amountUsd: 1,
        paidWithCreditCard: false,
      ),
    ];
    final utf8 = ExpenseApiDto.listToJsonUtf8(list);
    final back = ExpenseApiDto.listFromJsonUtf8(utf8);
    expect(back.length, 1);
    expect(back.single.id, '1');
  });
}
