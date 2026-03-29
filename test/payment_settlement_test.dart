import 'package:flutter_test/flutter_test.dart';

import 'package:expense_app/domain/domain.dart';

void main() {
  final today = DateTime(2025, 6, 15);

  test('standalone expense past date without status is settled', () {
    final e = Expense(
      id: '1',
      occurredOn: DateTime(2025, 6, 10),
      categoryId: 'c',
      subcategoryId: 's',
      amountOriginal: 10,
      currencyCode: 'USD',
      manualFxRateToUsd: 1,
      amountUsd: 10,
      paidWithCreditCard: false,
    );
    expect(isEconomicallySettledExpense(e, today), isTrue);
  });

  test('standalone expense future with expected is not settled', () {
    final e = Expense(
      id: '1',
      occurredOn: DateTime(2025, 7, 1),
      categoryId: 'c',
      subcategoryId: 's',
      amountOriginal: 10,
      currencyCode: 'USD',
      manualFxRateToUsd: 1,
      amountUsd: 10,
      paidWithCreditCard: false,
      paymentExpectationStatus: PaymentExpectationStatus.expected,
    );
    expect(isEconomicallySettledExpense(e, today), isFalse);
  });

  test('standalone expense future with confirmed is settled', () {
    final e = Expense(
      id: '1',
      occurredOn: DateTime(2025, 7, 1),
      categoryId: 'c',
      subcategoryId: 's',
      amountOriginal: 10,
      currencyCode: 'USD',
      manualFxRateToUsd: 1,
      amountUsd: 10,
      paidWithCreditCard: false,
      paymentExpectationStatus: PaymentExpectationStatus.confirmedPaid,
      paymentExpectationConfirmedOn: DateTime(2025, 6, 20),
    );
    expect(isEconomicallySettledExpense(e, today), isTrue);
  });

  test('recurring expense future expected is not settled', () {
    final e = Expense(
      id: '1',
      occurredOn: DateTime(2025, 7, 1),
      categoryId: 'c',
      subcategoryId: 's',
      amountOriginal: 10,
      currencyCode: 'USD',
      manualFxRateToUsd: 1,
      amountUsd: 10,
      paidWithCreditCard: false,
      recurringSeriesId: 'series',
      paymentExpectationStatus: PaymentExpectationStatus.expected,
    );
    expect(isEconomicallySettledExpense(e, today), isFalse);
  });

  test('recurring income skipped is not economically settled', () {
    final entry = IncomeEntry(
      id: '1',
      receivedOn: DateTime(2025, 7, 1),
      incomeCategoryId: 'c',
      incomeSubcategoryId: 's',
      amountOriginal: 100,
      currencyCode: 'USD',
      manualFxRateToUsd: 1,
      amountUsd: 100,
      recurringSeriesId: 'series',
      expectationStatus: PaymentExpectationStatus.skipped,
    );
    expect(isEconomicallySettledIncome(entry, today), isFalse);
    expect(isIncomeExcludedFromCashflowTotals(entry), isTrue);
  });

  test('splitIncomeUsdSettledPending ignores skipped and waived', () {
    final todayInc = DateTime(2025, 6, 15);
    final incomes = [
      IncomeEntry(
        id: 'a',
        receivedOn: DateTime(2025, 3, 1),
        incomeCategoryId: 'c',
        incomeSubcategoryId: 's',
        amountOriginal: 100,
        currencyCode: 'USD',
        manualFxRateToUsd: 1,
        amountUsd: 100,
        recurringSeriesId: 'r',
        expectationStatus: PaymentExpectationStatus.skipped,
      ),
      IncomeEntry(
        id: 'b',
        receivedOn: DateTime(2025, 3, 2),
        incomeCategoryId: 'c',
        incomeSubcategoryId: 's',
        amountOriginal: 40,
        currencyCode: 'USD',
        manualFxRateToUsd: 1,
        amountUsd: 40,
        recurringSeriesId: 'r',
        expectationStatus: PaymentExpectationStatus.expected,
      ),
    ];
    final r = splitIncomeUsdSettledPending(incomes, todayInc);
    expect(r.settled, 0);
    expect(r.pending, 40);
  });

  test('splitExpenseUsdSettledPending buckets amounts', () {
    final expenses = [
      Expense(
        id: 'a',
        occurredOn: DateTime(2025, 3, 1),
        categoryId: 'c',
        subcategoryId: 's',
        amountOriginal: 100,
        currencyCode: 'USD',
        manualFxRateToUsd: 1,
        amountUsd: 100,
        paidWithCreditCard: false,
        paymentExpectationStatus: PaymentExpectationStatus.confirmedPaid,
        paymentExpectationConfirmedOn: DateTime(2025, 3, 1),
      ),
      Expense(
        id: 'b',
        occurredOn: DateTime(2025, 12, 1),
        categoryId: 'c',
        subcategoryId: 's',
        amountOriginal: 50,
        currencyCode: 'USD',
        manualFxRateToUsd: 1,
        amountUsd: 50,
        paidWithCreditCard: false,
        paymentExpectationStatus: PaymentExpectationStatus.expected,
      ),
    ];
    final r = splitExpenseUsdSettledPending(expenses, today);
    expect(r.settled, 100);
    expect(r.pending, 50);
  });

  test('showInlineSettlementToggle hides skipped and waived expenses', () {
    final base = Expense(
      id: '1',
      occurredOn: DateTime(2025, 7, 1),
      categoryId: 'c',
      subcategoryId: 's',
      amountOriginal: 10,
      currencyCode: 'USD',
      manualFxRateToUsd: 1,
      amountUsd: 10,
      paidWithCreditCard: false,
      recurringSeriesId: 'series',
    );
    expect(
      showInlineSettlementToggleForExpense(
        base.copyWith(paymentExpectationStatus: PaymentExpectationStatus.expected),
      ),
      isTrue,
    );
    expect(
      showInlineSettlementToggleForExpense(
        base.copyWith(paymentExpectationStatus: PaymentExpectationStatus.skipped),
      ),
      isFalse,
    );
    expect(
      showInlineSettlementToggleForExpense(
        base.copyWith(paymentExpectationStatus: PaymentExpectationStatus.waived),
      ),
      isFalse,
    );
  });

  test('withExpenseSettlementChoice sets confirmed on occurrence or today', () {
    final e = Expense(
      id: '1',
      occurredOn: DateTime(2025, 7, 20),
      categoryId: 'c',
      subcategoryId: 's',
      amountOriginal: 10,
      currencyCode: 'USD',
      manualFxRateToUsd: 1,
      amountUsd: 10,
      paidWithCreditCard: false,
    );
    final paidEarly = withExpenseSettlementChoice(e, true, today);
    expect(paidEarly.paymentExpectationStatus, PaymentExpectationStatus.confirmedPaid);
    expect(paidEarly.paymentExpectationConfirmedOn, today);
    final unpaid = withExpenseSettlementChoice(paidEarly, false, today);
    expect(unpaid.paymentExpectationStatus, PaymentExpectationStatus.expected);
    expect(unpaid.paymentExpectationConfirmedOn, isNull);
  });

  test('withIncomeSettlementChoice matches expense semantics', () {
    final entry = IncomeEntry(
      id: '1',
      receivedOn: DateTime(2025, 8, 1),
      incomeCategoryId: 'c',
      incomeSubcategoryId: 's',
      amountOriginal: 100,
      currencyCode: 'USD',
      manualFxRateToUsd: 1,
      amountUsd: 100,
      description: '',
    );
    final paid = withIncomeSettlementChoice(entry, true, today);
    expect(paid.expectationStatus, PaymentExpectationStatus.confirmedPaid);
    expect(paid.expectationConfirmedOn, today);
  });
}
