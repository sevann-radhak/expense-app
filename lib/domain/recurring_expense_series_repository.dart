import 'package:expense_app/domain/expense_recurring_series.dart';

/// Persistence + materialization port for recurring expense series (Phase 4.1).
abstract class RecurringExpenseSeriesRepository {
  Future<void> upsert(ExpenseRecurringSeries series);

  Future<ExpenseRecurringSeries?> getById(String id);

  /// Deletes materialized rows for [seriesId] with [occurredOn] strictly after
  /// [todayDateOnly], then inserts missing occurrences through the rolling horizon.
  ///
  /// No-op when the series is inactive.
  Future<void> rematerializeForward({
    required String seriesId,
    required DateTime todayDateOnly,
  });

  Stream<List<ExpenseRecurringSeries>> watchAll();

  /// Sets [series] inactive and removes materialized expenses with [occurredOn]
  /// strictly after [todayDateOnly].
  Future<void> deactivateSeries({
    required String seriesId,
    required DateTime todayDateOnly,
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
