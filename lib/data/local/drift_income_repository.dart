import 'package:drift/drift.dart';

import 'package:expense_app/data/local/app_database.dart';
import 'package:expense_app/domain/domain.dart';

class DriftIncomeRepository implements IncomeRepository {
  DriftIncomeRepository(this._db);

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

  static (String startInclusive, String endExclusive) _yearRangeIso(int year) {
    final start = ExpenseDates.toStorageDate(DateTime(year, 1, 1));
    final end = ExpenseDates.toStorageDate(DateTime(year + 1, 1, 1));
    return (start, end);
  }

  @override
  Stream<List<IncomeEntry>> watchForMonth(int year, int month) {
    final range = _monthRangeIso(year, month);
    return (_db.select(_db.incomeEntries)
          ..where(
            (e) =>
                e.receivedOn.isBiggerOrEqualValue(range.$1) &
                e.receivedOn.isSmallerThanValue(range.$2),
          )
          ..orderBy([
            (e) => OrderingTerm.desc(e.receivedOn),
            (e) => OrderingTerm.desc(e.id),
          ]))
        .watch()
        .map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Stream<List<IncomeEntry>> watchForYear(int year) {
    final range = _yearRangeIso(year);
    return (_db.select(_db.incomeEntries)
          ..where(
            (e) =>
                e.receivedOn.isBiggerOrEqualValue(range.$1) &
                e.receivedOn.isSmallerThanValue(range.$2),
          )
          ..orderBy([
            (e) => OrderingTerm.asc(e.receivedOn),
            (e) => OrderingTerm.asc(e.id),
          ]))
        .watch()
        .map((rows) => rows.map(_toDomain).toList());
  }

  IncomeEntry _toDomain(IncomeEntryRow r) {
    final pxs = r.expectationStatus;
    final pxc = r.expectationConfirmedOn;
    return IncomeEntry(
      id: r.id,
      receivedOn: ExpenseDates.fromStorageDate(r.receivedOn),
      incomeCategoryId: r.incomeCategoryId,
      incomeSubcategoryId: r.incomeSubcategoryId,
      amountOriginal: r.amountOriginal,
      currencyCode: r.currencyCode,
      manualFxRateToUsd: r.manualFxRateToUsd,
      amountUsd: r.amountUsd,
      description: r.description,
      recurringSeriesId: r.recurringSeriesId,
      expectationStatus: paymentExpectationStatusFromStorage(pxs),
      expectationConfirmedOn: pxc != null && pxc.isNotEmpty
          ? ExpenseDates.fromStorageDate(pxc)
          : null,
    );
  }

  IncomeEntry _withUsd(IncomeEntry e) {
    return e.copyWith(
      amountUsd: IncomeEntry.computeUsd(e.amountOriginal, e.manualFxRateToUsd),
    );
  }

  Future<void> _assertIncomeSubcategoryBelongsToCategory({
    required String incomeCategoryId,
    required String incomeSubcategoryId,
    bool requireActiveTaxonomy = false,
  }) async {
    final cat = await (_db.select(_db.incomeCategories)
          ..where((c) => c.id.equals(incomeCategoryId)))
        .getSingleOrNull();
    final row = await (_db.select(_db.incomeSubcategories)
          ..where((s) => s.id.equals(incomeSubcategoryId)))
        .getSingleOrNull();
    if (cat == null || row == null || row.categoryId != incomeCategoryId) {
      throw InvalidSubcategoryPairingException(
        'Income subcategory does not belong to the selected income category.',
      );
    }
    if (requireActiveTaxonomy && (!cat.isActive || !row.isActive)) {
      throw InactiveTaxonomyForNewEntryException();
    }
  }

  @override
  Future<void> create(IncomeEntry entry) async {
    if (entry.manualFxRateToUsd <= 0) {
      throw ArgumentError.value(
        entry.manualFxRateToUsd,
        'manualFxRateToUsd',
        'must be positive',
      );
    }
    await _assertIncomeSubcategoryBelongsToCategory(
      incomeCategoryId: entry.incomeCategoryId,
      incomeSubcategoryId: entry.incomeSubcategoryId,
      requireActiveTaxonomy: true,
    );
    final e = _withUsd(entry);
    await _db.into(_db.incomeEntries).insert(
          IncomeEntriesCompanion.insert(
            id: e.id,
            receivedOn: ExpenseDates.toStorageDate(e.receivedOn),
            incomeCategoryId: e.incomeCategoryId,
            incomeSubcategoryId: e.incomeSubcategoryId,
            amountOriginal: e.amountOriginal,
            currencyCode: Value(e.currencyCode),
            manualFxRateToUsd: Value(e.manualFxRateToUsd),
            amountUsd: e.amountUsd,
            description: Value(e.description),
            recurringSeriesId: Value(e.recurringSeriesId),
            expectationStatus: Value(e.expectationStatus?.storageName),
            expectationConfirmedOn: Value(
              e.expectationConfirmedOn != null
                  ? ExpenseDates.toStorageDate(e.expectationConfirmedOn!)
                  : null,
            ),
          ),
        );
  }

  @override
  Future<void> update(IncomeEntry entry) async {
    if (entry.manualFxRateToUsd <= 0) {
      throw ArgumentError.value(
        entry.manualFxRateToUsd,
        'manualFxRateToUsd',
        'must be positive',
      );
    }
    await _assertIncomeSubcategoryBelongsToCategory(
      incomeCategoryId: entry.incomeCategoryId,
      incomeSubcategoryId: entry.incomeSubcategoryId,
    );
    final e = _withUsd(entry);
    final n = await (_db.update(_db.incomeEntries)..where((x) => x.id.equals(e.id)))
        .write(
      IncomeEntriesCompanion(
        receivedOn: Value(ExpenseDates.toStorageDate(e.receivedOn)),
        incomeCategoryId: Value(e.incomeCategoryId),
        incomeSubcategoryId: Value(e.incomeSubcategoryId),
        amountOriginal: Value(e.amountOriginal),
        currencyCode: Value(e.currencyCode),
        manualFxRateToUsd: Value(e.manualFxRateToUsd),
        amountUsd: Value(e.amountUsd),
        description: Value(e.description),
        recurringSeriesId: Value(e.recurringSeriesId),
        expectationStatus: Value(e.expectationStatus?.storageName),
        expectationConfirmedOn: Value(
          e.expectationConfirmedOn != null
              ? ExpenseDates.toStorageDate(e.expectationConfirmedOn!)
              : null,
        ),
      ),
    );
    if (n == 0) {
      throw StateError('Income entry not found: ${e.id}');
    }
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.incomeEntries)..where((e) => e.id.equals(id))).go();
  }
}
