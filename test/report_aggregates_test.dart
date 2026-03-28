import 'package:flutter_test/flutter_test.dart';

import 'package:expense_app/domain/domain.dart';

Expense _e({
  required String id,
  required String categoryId,
  required String subcategoryId,
  double usd = 10,
}) {
  return Expense(
    id: id,
    occurredOn: DateTime(2025, 6, 15),
    categoryId: categoryId,
    subcategoryId: subcategoryId,
    amountOriginal: usd,
    currencyCode: 'USD',
    manualFxRateToUsd: 1,
    amountUsd: usd,
    paidWithCreditCard: false,
  );
}

void main() {
  test('totalUsd sums amountUsd', () {
    expect(
      totalUsd([
        _e(id: 'a', categoryId: 'c1', subcategoryId: 's1', usd: 100),
        _e(id: 'b', categoryId: 'c1', subcategoryId: 's2', usd: 50.5),
      ]),
      150.5,
    );
  });

  test('percentOfTotal handles zero whole', () {
    expect(percentOfTotal(5, 0), 0);
    expect(percentOfTotal(0, 100), 0);
  });

  test('percentOfTotal is share times 100', () {
    expect(percentOfTotal(25, 100), 25);
    expect(percentOfTotal(1, 3), closeTo(100 / 3, 0.0001));
  });

  test('aggregateUsdByCategory sorts by total descending', () {
    final rows = aggregateUsdByCategory([
      _e(id: '1', categoryId: 'a', subcategoryId: 's', usd: 10),
      _e(id: '2', categoryId: 'b', subcategoryId: 's', usd: 40),
      _e(id: '3', categoryId: 'a', subcategoryId: 's', usd: 5),
    ]);
    expect(rows.map((r) => r.categoryId).toList(), ['b', 'a']);
    expect(rows.first.totalUsd, 40);
    expect(rows[1].totalUsd, 15);
  });

  test('monthlyUsdTotalsByCalendarMonth buckets by occurredOn month', () {
    final list = monthlyUsdTotalsByCalendarMonth([
      _e(id: '1', categoryId: 'c', subcategoryId: 's', usd: 10).copyWith(
        occurredOn: DateTime(2025, 1, 15),
      ),
      _e(id: '2', categoryId: 'c', subcategoryId: 's', usd: 5).copyWith(
        occurredOn: DateTime(2025, 1, 20),
      ),
      _e(id: '3', categoryId: 'c', subcategoryId: 's', usd: 100).copyWith(
        occurredOn: DateTime(2025, 12, 1),
      ),
    ]);
    expect(list[0], 15);
    expect(list[11], 100);
    expect(list[5], 0);
  });

  test('aggregateUsdBySubcategoryForCategory filters and sorts', () {
    final rows = aggregateUsdBySubcategoryForCategory([
      _e(id: '1', categoryId: 'c', subcategoryId: 's1', usd: 3),
      _e(id: '2', categoryId: 'c', subcategoryId: 's2', usd: 10),
      _e(id: '3', categoryId: 'x', subcategoryId: 's9', usd: 99),
    ], 'c');
    expect(rows.map((r) => r.subcategoryId).toList(), ['s2', 's1']);
  });
}
