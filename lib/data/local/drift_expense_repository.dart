import 'package:drift/drift.dart';

import 'package:expense_app/data/local/app_database.dart';
import 'package:expense_app/domain/domain.dart';

class DriftExpenseRepository implements ExpenseRepository {
  DriftExpenseRepository(this._db);

  final AppDatabase _db;

  static (String startInclusive, String endExclusive) _monthRangeIso(
    int year,
    int month,
  ) {
    final start = ExpenseDates.toStorageDate(DateTime(year, month, 1));
    final nextMonth = DateTime(year, month + 1, 1);
    final end = ExpenseDates.toStorageDate(nextMonth);
    return (start, end);
  }

  @override
  Stream<List<Expense>> watchForMonth(int year, int month) {
    final range = _monthRangeIso(year, month);
    final start = range.$1;
    final endExclusive = range.$2;
    return (_db.select(_db.expenses)
          ..where(
            (e) =>
                e.occurredOn.isBiggerOrEqualValue(start) &
                e.occurredOn.isSmallerThanValue(endExclusive),
          )
          ..orderBy([
            (e) => OrderingTerm.desc(e.occurredOn),
            (e) => OrderingTerm.desc(e.id),
          ]))
        .watch()
        .map((rows) => rows.map(_toDomain).toList());
  }

  Expense _toDomain(ExpenseRow r) {
    return Expense(
      id: r.id,
      occurredOn: ExpenseDates.fromStorageDate(r.occurredOn),
      categoryId: r.categoryId,
      subcategoryId: r.subcategoryId,
      amountOriginal: r.amountOriginal,
      currencyCode: r.currencyCode,
      manualFxRateToUsd: r.manualFxRateToUsd,
      amountUsd: r.amountUsd,
      paidWithCreditCard: r.paidWithCreditCard,
      description: r.description,
    );
  }

  Future<void> _assertSubcategoryBelongsToCategory({
    required String categoryId,
    required String subcategoryId,
  }) async {
    final row = await (_db.select(_db.subcategories)
          ..where((s) => s.id.equals(subcategoryId)))
        .getSingleOrNull();
    if (row == null || row.categoryId != categoryId) {
      throw InvalidSubcategoryPairingException(
        'Subcategory does not belong to the selected category.',
      );
    }
  }

  Expense _withRecomputedUsd(Expense expense) {
    final usd = Expense.computeUsd(
      expense.amountOriginal,
      expense.manualFxRateToUsd,
    );
    return expense.copyWith(amountUsd: usd);
  }

  @override
  Future<void> create(Expense expense) async {
    if (expense.manualFxRateToUsd <= 0) {
      throw ArgumentError.value(
        expense.manualFxRateToUsd,
        'manualFxRateToUsd',
        'must be positive',
      );
    }
    await _assertSubcategoryBelongsToCategory(
      categoryId: expense.categoryId,
      subcategoryId: expense.subcategoryId,
    );
    final e = _withRecomputedUsd(expense);
    await _db.into(_db.expenses).insert(
          ExpensesCompanion.insert(
            id: e.id,
            occurredOn: ExpenseDates.toStorageDate(e.occurredOn),
            categoryId: e.categoryId,
            subcategoryId: e.subcategoryId,
            amountOriginal: e.amountOriginal,
            currencyCode: Value(e.currencyCode),
            manualFxRateToUsd: Value(e.manualFxRateToUsd),
            amountUsd: e.amountUsd,
            paidWithCreditCard: Value(e.paidWithCreditCard),
            description: Value(e.description),
          ),
        );
  }

  @override
  Future<void> update(Expense expense) async {
    if (expense.manualFxRateToUsd <= 0) {
      throw ArgumentError.value(
        expense.manualFxRateToUsd,
        'manualFxRateToUsd',
        'must be positive',
      );
    }
    await _assertSubcategoryBelongsToCategory(
      categoryId: expense.categoryId,
      subcategoryId: expense.subcategoryId,
    );
    final e = _withRecomputedUsd(expense);
    final updated = await (_db.update(_db.expenses)..where((x) => x.id.equals(e.id)))
        .write(
      ExpensesCompanion(
        occurredOn: Value(ExpenseDates.toStorageDate(e.occurredOn)),
        categoryId: Value(e.categoryId),
        subcategoryId: Value(e.subcategoryId),
        amountOriginal: Value(e.amountOriginal),
        currencyCode: Value(e.currencyCode),
        manualFxRateToUsd: Value(e.manualFxRateToUsd),
        amountUsd: Value(e.amountUsd),
        paidWithCreditCard: Value(e.paidWithCreditCard),
        description: Value(e.description),
      ),
    );
    if (updated == 0) {
      throw StateError('Expense not found: ${e.id}');
    }
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.expenses)..where((e) => e.id.equals(id))).go();
  }
}
