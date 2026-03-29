import 'dart:convert';

import 'package:drift/drift.dart';

import 'package:expense_app/application/recurrence_json_codec.dart';
import 'package:expense_app/data/local/app_database.dart';
import 'package:expense_app/data/local/expense_recurring_series_drift_mapper.dart';
import 'package:expense_app/domain/domain.dart';

class DriftRecurringExpenseSeriesRepository
    implements RecurringExpenseSeriesRepository {
  DriftRecurringExpenseSeriesRepository(this._db);

  final AppDatabase _db;

  @override
  Future<void> upsert(ExpenseRecurringSeries series) async {
    series.validate();
    await _assertSubcategoryBelongsToCategory(
      categoryId: series.categoryId,
      subcategoryId: series.subcategoryId,
    );
    await _assertPaymentInstrumentIfSet(series.paymentInstrumentId);
    final payload = encodeRecurrencePayload(
      rule: series.rule,
      endCondition: series.endCondition,
    );
    final json = jsonEncode(payload);
    final usd = Expense.computeUsd(
      series.amountOriginal,
      series.manualFxRateToUsd,
    );
    await _db.into(_db.recExpenseSeries).insert(
          RecExpenseSeriesCompanion.insert(
            id: series.id,
            anchorOccurredOn:
                ExpenseDates.toStorageDate(series.anchorOccurredOn),
            recurrenceJson: json,
            horizonMonths: series.horizonMonths,
            categoryId: series.categoryId,
            subcategoryId: series.subcategoryId,
            amountOriginal: series.amountOriginal,
            amountUsd: usd,
            active: Value(series.active),
            currencyCode: Value(series.currencyCode),
            manualFxRateToUsd: Value(series.manualFxRateToUsd),
            paidWithCreditCard: Value(series.paidWithCreditCard),
            description: Value(series.description),
            paymentInstrumentId: Value(series.paymentInstrumentId),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  @override
  Future<ExpenseRecurringSeries?> getById(String id) async {
    final row = await (_db.select(_db.recExpenseSeries)
          ..where((s) => s.id.equals(id)))
        .getSingleOrNull();
    if (row == null) {
      return null;
    }
    return expenseRecurringSeriesFromDriftRow(row);
  }

  @override
  Future<void> rematerializeForward({
    required String seriesId,
    required DateTime todayDateOnly,
  }) async {
    final row = await (_db.select(_db.recExpenseSeries)
          ..where((s) => s.id.equals(seriesId)))
        .getSingleOrNull();
    if (row == null || !row.active) {
      return;
    }
    final series = expenseRecurringSeriesFromDriftRow(row);
    series.validate();

    final todayIso = ExpenseDates.toStorageDate(
      calendarDateOnly(todayDateOnly),
    );
    await (_db.delete(_db.expenses)
          ..where(
            (e) =>
                e.recurringSeriesId.equals(seriesId) &
                e.occurredOn.isBiggerThanValue(todayIso),
          ))
        .go();

    final horizonEnd = recurrenceMaterializationHorizonEndInclusive(
      todayDateOnly,
      series.horizonMonths,
    );
    final dates = expandRecurrenceOccurrences(
      anchor: series.anchorOccurredOn,
      rule: series.rule,
      endCondition: series.endCondition,
      capEndInclusive: horizonEnd,
    );

    final usd = Expense.computeUsd(
      series.amountOriginal,
      series.manualFxRateToUsd,
    );

    for (final d in dates) {
      final id = materializedExpenseIdForSeriesDate(
        seriesId: seriesId,
        occurredOn: d,
      );
      await _db.into(_db.expenses).insert(
            ExpensesCompanion.insert(
              id: id,
              occurredOn: ExpenseDates.toStorageDate(d),
              categoryId: series.categoryId,
              subcategoryId: series.subcategoryId,
              amountOriginal: series.amountOriginal,
              currencyCode: Value(series.currencyCode),
              manualFxRateToUsd: Value(series.manualFxRateToUsd),
              amountUsd: usd,
              paidWithCreditCard: Value(series.paidWithCreditCard),
              description: Value(series.description),
              paymentInstrumentId: Value(series.paymentInstrumentId),
              recurringSeriesId: Value(seriesId),
              paymentExpectationStatus:
                  Value(PaymentExpectationStatus.expected.storageName),
            ),
            mode: InsertMode.insertOrIgnore,
          );
    }
  }

  @override
  Stream<List<ExpenseRecurringSeries>> watchAll() {
    return (_db.select(_db.recExpenseSeries)
          ..orderBy([
            (s) => OrderingTerm.desc(s.active),
            (s) => OrderingTerm.asc(s.description),
            (s) => OrderingTerm.asc(s.id),
          ]))
        .watch()
        .map((rows) => rows.map(expenseRecurringSeriesFromDriftRow).toList());
  }

  @override
  Future<void> deactivateSeries({
    required String seriesId,
    required DateTime todayDateOnly,
  }) async {
    await (_db.update(_db.recExpenseSeries)
          ..where((s) => s.id.equals(seriesId)))
        .write(const RecExpenseSeriesCompanion(active: Value(false)));
    final todayIso = ExpenseDates.toStorageDate(
      calendarDateOnly(todayDateOnly),
    );
    await (_db.delete(_db.expenses)
          ..where(
            (e) =>
                e.recurringSeriesId.equals(seriesId) &
                e.occurredOn.isBiggerThanValue(todayIso),
          ))
        .go();
  }

  Future<void> _assertPaymentInstrumentIfSet(String? id) async {
    if (id == null || id.isEmpty) {
      return;
    }
    final pi = await (_db.select(_db.paymentInstruments)
          ..where((p) => p.id.equals(id)))
        .getSingleOrNull();
    if (pi == null) {
      throw ArgumentError.value(
        id,
        'paymentInstrumentId',
        'Unknown payment instrument',
      );
    }
  }

  Future<void> _assertSubcategoryBelongsToCategory({
    required String categoryId,
    required String subcategoryId,
  }) async {
    final sRow = await (_db.select(_db.subcategories)
          ..where((s) => s.id.equals(subcategoryId)))
        .getSingleOrNull();
    if (sRow == null || sRow.categoryId != categoryId) {
      throw InvalidSubcategoryPairingException(
        'Subcategory does not belong to the selected category.',
      );
    }
  }
}
