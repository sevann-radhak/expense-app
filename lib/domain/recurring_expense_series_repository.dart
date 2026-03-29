import 'package:expense_app/domain/expense_recurring_series.dart';

/// Persistence + materialization port for recurring expense series (Phase 4.1).
abstract class RecurringExpenseSeriesRepository {
  Future<void> upsert(ExpenseRecurringSeries series);

  Future<ExpenseRecurringSeries?> getById(String id);

  /// Refills materialized rows strictly after [todayDateOnly] from the series template.
  ///
  /// When [rematerializeOccurrencesOnOrAfter] is set (e.g. “this date and later” save),
  /// only rows with [occurredOn] **on or after** that calendar date are removed and
  /// recreated. Earlier future rows (still after today but before the cutoff) are left
  /// unchanged.
  ///
  /// No-op when the series is inactive.
  Future<void> rematerializeForward({
    required String seriesId,
    required DateTime todayDateOnly,
    DateTime? rematerializeOccurrencesOnOrAfter,
  });

  Stream<List<ExpenseRecurringSeries>> watchAll();

  /// Sets [series] inactive and removes materialized expenses with [occurredOn]
  /// strictly after [todayDateOnly].
  Future<void> deactivateSeries({
    required String seriesId,
    required DateTime todayDateOnly,
  });

  /// Same as [RecurringIncomeSeriesRepository.trimSeriesFromOccurrenceDate] for expenses.
  Future<void> trimSeriesFromOccurrenceDate({
    required String seriesId,
    required DateTime fromOccurredOnDateOnly,
    required DateTime todayDateOnly,
  });

  /// Same as income [updateSeriesTemplateAndMaterializedFromDate] for expenses.
  Future<void> updateSeriesTemplateAndMaterializedFromDate({
    required ExpenseRecurringSeries updatedSeries,
    required DateTime fromOccurredOnDateOnly,
    required DateTime todayDateOnly,
    required String occurrenceNoteFromEditedDate,
  });
}

extension RecurringExpenseSeriesRepositoryMaterialize
    on RecurringExpenseSeriesRepository {
  Future<void> upsertAndRematerialize(
    ExpenseRecurringSeries series,
    DateTime todayDateOnly,
  ) async {
    await upsert(series);
    await rematerializeForward(seriesId: series.id, todayDateOnly: todayDateOnly);
  }
}
