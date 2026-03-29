import 'package:expense_app/domain/income_recurring_series.dart';

abstract class RecurringIncomeSeriesRepository {
  Future<void> upsert(IncomeRecurringSeries series);

  Future<IncomeRecurringSeries?> getById(String id);

  /// Refills materialized rows strictly after [todayDateOnly] from the series template.
  ///
  /// When [rematerializeOccurrencesOnOrAfter] is set (e.g. “this date and later” save),
  /// only rows with [receivedOn] **on or after** that calendar date are removed and
  /// recreated. Earlier future rows (still after today but before the cutoff) are left
  /// unchanged so a raise from June does not rewrite May.
  Future<void> rematerializeForward({
    required String seriesId,
    required DateTime todayDateOnly,
    DateTime? rematerializeOccurrencesOnOrAfter,
  });

  Stream<List<IncomeRecurringSeries>> watchAll();

  Future<void> deactivateSeries({
    required String seriesId,
    required DateTime todayDateOnly,
  });

  /// Deletes materialized rows on or after [fromReceivedOnDateOnly], trims the
  /// recurrence end so they are not recreated. If there is no occurrence before
  /// [fromReceivedOnDateOnly], removes all rows for the series and deactivates it.
  Future<void> trimSeriesFromOccurrenceDate({
    required String seriesId,
    required DateTime fromReceivedOnDateOnly,
    required DateTime todayDateOnly,
  });

  /// Persists [updatedSeries] (amount, categories, currency, etc.) and reapplies
  /// those fields to every materialized row on or after [fromReceivedOnDateOnly],
  /// then [rematerializeForward].
  ///
  /// [updatedSeries.description] must remain the **series template** note (unchanged
  /// from [getById]); it is **not** overwritten for the whole series. The form
  /// note for this save is [occurrenceNoteFromEditedDate] and is written **only**
  /// to rows with [receivedOn] on or after [fromReceivedOnDateOnly]—never to
  /// earlier materialized rows.
  Future<void> updateSeriesTemplateAndMaterializedFromDate({
    required IncomeRecurringSeries updatedSeries,
    required DateTime fromReceivedOnDateOnly,
    required DateTime todayDateOnly,
    required String occurrenceNoteFromEditedDate,
  });
}

extension RecurringIncomeSeriesRepositoryMaterialize on RecurringIncomeSeriesRepository {
  Future<void> upsertAndRematerialize(
    IncomeRecurringSeries series,
    DateTime todayDateOnly,
  ) async {
    await upsert(series);
    await rematerializeForward(seriesId: series.id, todayDateOnly: todayDateOnly);
  }
}
