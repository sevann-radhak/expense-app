import 'package:flutter_test/flutter_test.dart';

import 'package:expense_app/application/application.dart';
import 'package:expense_app/domain/domain.dart';

void main() {
  test('buildReportExpensesCsv header and row fields', () {
    final expenses = [
      Expense(
        id: 'e1',
        occurredOn: DateTime(2026, 2, 1),
        categoryId: 'c1',
        subcategoryId: 's1',
        amountOriginal: 10.5,
        currencyCode: 'ARS',
        manualFxRateToUsd: 0.001,
        amountUsd: 0.0105,
        paidWithCreditCard: true,
        description: 'Note',
      ),
    ];
    final csv = buildReportExpensesCsv(
      expenses: expenses,
      categoryNames: {'c1': 'Cat A'},
      subcategoryNames: {'s1': 'Sub B'},
      unknownCategoryLabel: '?',
      unknownSubcategoryLabel: '?',
    );
    expect(csv.startsWith('occurred_on,category_id,'), isTrue);
    expect(csv.contains('2026-02-01'), isTrue);
    expect(csv.contains('Cat A'), isTrue);
    expect(csv.contains('Sub B'), isTrue);
    expect(csv.contains('10.5'), isTrue);
    expect(csv.contains('ARS'), isTrue);
    expect(csv.contains('true'), isTrue);
    expect(csv.contains('Note'), isTrue);
  });

  test('buildReportExpensesCsv escapes commas and quotes in description', () {
    final expenses = [
      Expense(
        id: 'e1',
        occurredOn: DateTime(2026, 1, 1),
        categoryId: 'c',
        subcategoryId: 's',
        amountOriginal: 1,
        currencyCode: 'USD',
        manualFxRateToUsd: 1,
        amountUsd: 1,
        paidWithCreditCard: false,
        description: 'Say "hello", world',
      ),
    ];
    final csv = buildReportExpensesCsv(
      expenses: expenses,
      categoryNames: {'c': 'C'},
      subcategoryNames: {'s': 'S'},
      unknownCategoryLabel: '?',
      unknownSubcategoryLabel: '?',
    );
    expect(csv.contains('"Say ""hello"", world"'), isTrue);
  });

  test('buildReportExpensesCsv sorts by date then id', () {
    final expenses = [
      Expense(
        id: 'b',
        occurredOn: DateTime(2026, 1, 2),
        categoryId: 'c',
        subcategoryId: 's',
        amountOriginal: 1,
        currencyCode: 'USD',
        manualFxRateToUsd: 1,
        amountUsd: 1,
        paidWithCreditCard: false,
      ),
      Expense(
        id: 'a',
        occurredOn: DateTime(2026, 1, 1),
        categoryId: 'c',
        subcategoryId: 's',
        amountOriginal: 2,
        currencyCode: 'USD',
        manualFxRateToUsd: 1,
        amountUsd: 2,
        paidWithCreditCard: false,
      ),
      Expense(
        id: 'c',
        occurredOn: DateTime(2026, 1, 2),
        categoryId: 'c',
        subcategoryId: 's',
        amountOriginal: 3,
        currencyCode: 'USD',
        manualFxRateToUsd: 1,
        amountUsd: 3,
        paidWithCreditCard: false,
      ),
    ];
    final csv = buildReportExpensesCsv(
      expenses: expenses,
      categoryNames: {'c': 'C'},
      subcategoryNames: {'s': 'S'},
      unknownCategoryLabel: '?',
      unknownSubcategoryLabel: '?',
    );
    final lines = csv.trim().split('\n');
    expect(lines.length, 4);
    expect(lines[1], startsWith('2026-01-01'));
    expect(lines[1], contains(',2,'));
    expect(lines[2], startsWith('2026-01-02'));
    expect(lines[2], contains(',1,'));
    expect(lines[3], startsWith('2026-01-02'));
    expect(lines[3], contains(',3,'));
  });

  test('csvEscapeField wraps fields with newline', () {
    expect(csvEscapeField('a\nb'), '"a\nb"');
  });
}
