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

  test('monthCashflowOriginalUsdSplitForIncome splits settled vs pending', () {
    final today = DateTime(2026, 6, 15);
    final received = IncomeEntry(
      id: 'a',
      receivedOn: DateTime(2026, 6, 10),
      incomeCategoryId: 'c',
      incomeSubcategoryId: 's',
      amountOriginal: 100,
      currencyCode: 'USD',
      manualFxRateToUsd: 1,
      amountUsd: 100,
      recurringSeriesId: 'r',
      expectationStatus: PaymentExpectationStatus.confirmedPaid,
      expectationConfirmedOn: DateTime(2026, 6, 10),
    );
    final expected = IncomeEntry(
      id: 'b',
      receivedOn: DateTime(2026, 6, 5),
      incomeCategoryId: 'c',
      incomeSubcategoryId: 's',
      amountOriginal: 40,
      currencyCode: 'USD',
      manualFxRateToUsd: 1,
      amountUsd: 40,
      recurringSeriesId: 'r',
      expectationStatus: PaymentExpectationStatus.expected,
    );
    final split = monthCashflowOriginalUsdSplitForIncome(
      [received, expected],
      today,
    );
    expect(split.usdSettled, 100);
    expect(split.usdPending, 40);
    expect(split.usdTotal, 140);
  });

  test('totalIncomeUsd excludes skipped and waived', () {
    final skipped = IncomeEntry(
      id: 's',
      receivedOn: DateTime(2025, 5, 1),
      incomeCategoryId: 'c',
      incomeSubcategoryId: 'sub',
      amountOriginal: 1250,
      currencyCode: 'USD',
      manualFxRateToUsd: 1,
      amountUsd: 1250,
      recurringSeriesId: 'r',
      expectationStatus: PaymentExpectationStatus.skipped,
    );
    final expected = IncomeEntry(
      id: 'e',
      receivedOn: DateTime(2025, 5, 2),
      incomeCategoryId: 'c',
      incomeSubcategoryId: 'sub',
      amountOriginal: 4000,
      currencyCode: 'USD',
      manualFxRateToUsd: 1,
      amountUsd: 4000,
      recurringSeriesId: 'r2',
      expectationStatus: PaymentExpectationStatus.expected,
    );
    expect(totalIncomeUsd([skipped, expected]), 4000);
  });

  test('aggregateUsdByIncomeCategory and subcategory helpers', () {
    final inc = IncomeEntry(
      id: 'i1',
      receivedOn: DateTime(2025, 3, 1),
      incomeCategoryId: 'cat_a',
      incomeSubcategoryId: 'sub_1',
      amountOriginal: 100,
      currencyCode: 'USD',
      manualFxRateToUsd: 1,
      amountUsd: 100,
    );
    final inc2 = IncomeEntry(
      id: 'i2',
      receivedOn: DateTime(2025, 3, 2),
      incomeCategoryId: 'cat_b',
      incomeSubcategoryId: 'sub_x',
      amountOriginal: 50,
      currencyCode: 'USD',
      manualFxRateToUsd: 1,
      amountUsd: 50,
    );
    final inc3 = inc.copyWith(
      id: 'i3',
      incomeSubcategoryId: 'sub_2',
      amountOriginal: 30,
      amountUsd: 30,
    );
    final byCat = aggregateUsdByIncomeCategory([inc, inc2, inc3]);
    expect(byCat.map((r) => r.categoryId).toList(), ['cat_a', 'cat_b']);
    expect(byCat.first.totalUsd, 130);
    final subs = aggregateUsdByIncomeSubcategoryForCategory(
      [inc, inc2, inc3],
      'cat_a',
    );
    expect(subs.map((r) => r.subcategoryId).toList(), ['sub_1', 'sub_2']);
  });
}
