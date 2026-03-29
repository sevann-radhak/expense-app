import 'dart:convert';

import 'package:drift/drift.dart';

import 'package:expense_app/application/recurrence_json_codec.dart';
import 'package:expense_app/data/local/app_database.dart';
import 'package:expense_app/data/local/income_recurring_series_drift_mapper.dart';
import 'package:expense_app/domain/domain.dart';

class DriftRecurringIncomeSeriesRepository
    implements RecurringIncomeSeriesRepository {
  DriftRecurringIncomeSeriesRepository(this._db);

  final AppDatabase _db;

  /// Calendar-safe filter (avoids lexicographic bugs on `received_on` strings).
  Future<List<String>> _materializedIncomeIdsOnOrAfter({
    required String seriesId,
    required DateTime fromReceivedOnDateOnly,
  }) async {
    final from = calendarDateOnly(fromReceivedOnDateOnly);
    final rows = await (_db.select(_db.incomeEntries)
          ..where((e) => e.recurringSeriesId.equals(seriesId)))
        .get();
    final out = <String>[];
    for (final r in rows) {
      final d = calendarDateOnly(ExpenseDates.fromStorageDate(r.receivedOn));
      if (!d.isBefore(from)) {
        out.add(r.id);
      }
    }
    return out;
  }

  @override
  Future<void> upsert(IncomeRecurringSeries series) async {
    series.validate();
    await _assertIncomeSubcategoryBelongsToCategory(
      incomeCategoryId: series.incomeCategoryId,
      incomeSubcategoryId: series.incomeSubcategoryId,
    );
    final payload = encodeRecurrencePayload(
      rule: series.rule,
      endCondition: series.endCondition,
    );
    final json = jsonEncode(payload);
    final usd = IncomeEntry.computeUsd(
      series.amountOriginal,
      series.manualFxRateToUsd,
    );
    await _db.into(_db.incomeRecSeries).insert(
          IncomeRecSeriesCompanion.insert(
            id: series.id,
            anchorReceivedOn:
                ExpenseDates.toStorageDate(series.anchorReceivedOn),
            recurrenceJson: json,
            horizonMonths: series.horizonMonths,
            incomeCategoryId: series.incomeCategoryId,
            incomeSubcategoryId: series.incomeSubcategoryId,
            amountOriginal: series.amountOriginal,
            amountUsd: usd,
            active: Value(series.active),
            currencyCode: Value(series.currencyCode),
            manualFxRateToUsd: Value(series.manualFxRateToUsd),
            description: Value(series.description),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  @override
  Future<IncomeRecurringSeries?> getById(String id) async {
    final row = await (_db.select(_db.incomeRecSeries)
          ..where((s) => s.id.equals(id)))
        .getSingleOrNull();
    if (row == null) {
      return null;
    }
    return incomeRecurringSeriesFromDriftRow(row);
  }

  @override
  Future<void> rematerializeForward({
    required String seriesId,
    required DateTime todayDateOnly,
    DateTime? rematerializeOccurrencesOnOrAfter,
  }) async {
    final row = await (_db.select(_db.incomeRecSeries)
          ..where((s) => s.id.equals(seriesId)))
        .getSingleOrNull();
    if (row == null || !row.active) {
      return;
    }
    final series = incomeRecurringSeriesFromDriftRow(row);
    series.validate();

    final today = calendarDateOnly(todayDateOnly);
    final cutoff = rematerializeOccurrencesOnOrAfter;
    final minOccurrence =
        cutoff != null ? calendarDateOnly(cutoff) : null;

    final existing = await (_db.select(_db.incomeEntries)
          ..where((e) => e.recurringSeriesId.equals(seriesId)))
        .get();
    final toDelete = <String>[];
    for (final r in existing) {
      final d = calendarDateOnly(ExpenseDates.fromStorageDate(r.receivedOn));
      if (!d.isAfter(today)) {
        continue;
      }
      if (minOccurrence != null && d.isBefore(minOccurrence)) {
        continue;
      }
      toDelete.add(r.id);
    }
    if (toDelete.isNotEmpty) {
      await (_db.delete(_db.incomeEntries)
            ..where((e) => e.id.isIn(toDelete)))
          .go();
    }

    final horizonEnd = recurrenceMaterializationHorizonEndInclusive(
      todayDateOnly,
      series.horizonMonths,
    );
    final dates = expandRecurrenceOccurrences(
      anchor: series.anchorReceivedOn,
      rule: series.rule,
      endCondition: series.endCondition,
      capEndInclusive: horizonEnd,
    );

    final usd = IncomeEntry.computeUsd(
      series.amountOriginal,
      series.manualFxRateToUsd,
    );

    for (final d in dates) {
      final id = materializedIncomeIdForSeriesDate(
        seriesId: seriesId,
        receivedOn: d,
      );
      final exp = expectationForMaterializedRecurringDate(
        occurrenceDate: d,
        todayDateOnly: todayDateOnly,
      );
      await _db.into(_db.incomeEntries).insert(
            IncomeEntriesCompanion.insert(
              id: id,
              receivedOn: ExpenseDates.toStorageDate(d),
              incomeCategoryId: series.incomeCategoryId,
              incomeSubcategoryId: series.incomeSubcategoryId,
              amountOriginal: series.amountOriginal,
              currencyCode: Value(series.currencyCode),
              manualFxRateToUsd: Value(series.manualFxRateToUsd),
              amountUsd: usd,
              description: Value(series.description),
              recurringSeriesId: Value(seriesId),
              expectationStatus: Value(exp.status.storageName),
              expectationConfirmedOn: exp.confirmedOn != null
                  ? Value(ExpenseDates.toStorageDate(exp.confirmedOn!))
                  : const Value.absent(),
            ),
            mode: InsertMode.insertOrIgnore,
          );
    }
  }

  @override
  Stream<List<IncomeRecurringSeries>> watchAll() {
    return (_db.select(_db.incomeRecSeries)
          ..orderBy([
            (s) => OrderingTerm.desc(s.active),
            (s) => OrderingTerm.asc(s.description),
            (s) => OrderingTerm.asc(s.id),
          ]))
        .watch()
        .map((rows) => rows.map(incomeRecurringSeriesFromDriftRow).toList());
  }

  @override
  Future<void> deactivateSeries({
    required String seriesId,
    required DateTime todayDateOnly,
  }) async {
    await (_db.update(_db.incomeRecSeries)
          ..where((s) => s.id.equals(seriesId)))
        .write(const IncomeRecSeriesCompanion(active: Value(false)));
    final todayIso = ExpenseDates.toStorageDate(
      calendarDateOnly(todayDateOnly),
    );
    await (_db.delete(_db.incomeEntries)
          ..where(
            (e) =>
                e.recurringSeriesId.equals(seriesId) &
                e.receivedOn.isBiggerThanValue(todayIso),
          ))
        .go();
  }

  Future<void> _assertIncomeSubcategoryBelongsToCategory({
    required String incomeCategoryId,
    required String incomeSubcategoryId,
  }) async {
    final sRow = await (_db.select(_db.incomeSubcategories)
          ..where((s) => s.id.equals(incomeSubcategoryId)))
        .getSingleOrNull();
    if (sRow == null || sRow.categoryId != incomeCategoryId) {
      throw InvalidSubcategoryPairingException(
        'Income subcategory does not belong to the selected income category.',
      );
    }
  }

  @override
  Future<void> trimSeriesFromOccurrenceDate({
    required String seriesId,
    required DateTime fromReceivedOnDateOnly,
    required DateTime todayDateOnly,
  }) async {
    final row = await (_db.select(_db.incomeRecSeries)
          ..where((s) => s.id.equals(seriesId)))
        .getSingleOrNull();
    if (row == null) {
      return;
    }
    final series = incomeRecurringSeriesFromDriftRow(row);
    series.validate();
    final from = calendarDateOnly(fromReceivedOnDateOnly);

    final idsToRemove = await _materializedIncomeIdsOnOrAfter(
      seriesId: seriesId,
      fromReceivedOnDateOnly: from,
    );
    if (idsToRemove.isNotEmpty) {
      await (_db.delete(_db.incomeEntries)
            ..where((e) => e.id.isIn(idsToRemove)))
          .go();
    }

    final prev = lastRecurrenceOccurrenceStrictlyBefore(
      anchor: series.anchorReceivedOn,
      rule: series.rule,
      endCondition: series.endCondition,
      beforeDateExclusive: from,
    );

    if (prev == null) {
      await (_db.delete(_db.incomeEntries)
            ..where((e) => e.recurringSeriesId.equals(seriesId)))
          .go();
      await (_db.update(_db.incomeRecSeries)
            ..where((s) => s.id.equals(seriesId)))
          .write(const IncomeRecSeriesCompanion(active: Value(false)));
      return;
    }

    final mergedEnd = mergeRecurrenceEndWithUntilInclusive(
      series.endCondition,
      prev,
    );
    final trimmed = series.copyWith(endCondition: mergedEnd);
    await upsert(trimmed);
    await rematerializeForward(
      seriesId: seriesId,
      todayDateOnly: todayDateOnly,
      rematerializeOccurrencesOnOrAfter: null,
    );
  }

  @override
  Future<void> updateSeriesTemplateAndMaterializedFromDate({
    required IncomeRecurringSeries updatedSeries,
    required DateTime fromReceivedOnDateOnly,
    required DateTime todayDateOnly,
    required String occurrenceNoteFromEditedDate,
  }) async {
    updatedSeries.validate();
    await upsert(updatedSeries);
    final usd = IncomeEntry.computeUsd(
      updatedSeries.amountOriginal,
      updatedSeries.manualFxRateToUsd,
    );
    final patchIds = await _materializedIncomeIdsOnOrAfter(
      seriesId: updatedSeries.id,
      fromReceivedOnDateOnly: fromReceivedOnDateOnly,
    );
    if (patchIds.isNotEmpty) {
      await (_db.update(_db.incomeEntries)
            ..where((e) => e.id.isIn(patchIds)))
          .write(
        IncomeEntriesCompanion(
          incomeCategoryId: Value(updatedSeries.incomeCategoryId),
          incomeSubcategoryId: Value(updatedSeries.incomeSubcategoryId),
          amountOriginal: Value(updatedSeries.amountOriginal),
          currencyCode: Value(updatedSeries.currencyCode),
          manualFxRateToUsd: Value(updatedSeries.manualFxRateToUsd),
          amountUsd: Value(usd),
          description: Value(occurrenceNoteFromEditedDate),
        ),
      );
    }
    await rematerializeForward(
      seriesId: updatedSeries.id,
      todayDateOnly: todayDateOnly,
      rematerializeOccurrencesOnOrAfter: fromReceivedOnDateOnly,
    );
    final noteIds = await _materializedIncomeIdsOnOrAfter(
      seriesId: updatedSeries.id,
      fromReceivedOnDateOnly: fromReceivedOnDateOnly,
    );
    if (noteIds.isNotEmpty) {
      await (_db.update(_db.incomeEntries)
            ..where((e) => e.id.isIn(noteIds)))
          .write(
        IncomeEntriesCompanion(
          description: Value(occurrenceNoteFromEditedDate),
        ),
      );
    }
  }
}
