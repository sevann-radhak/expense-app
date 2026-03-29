import 'package:expense_app/domain/income_recurring_series.dart';

abstract class RecurringIncomeSeriesRepository {
  Future<void> upsert(IncomeRecurringSeries series);

  Future<IncomeRecurringSeries?> getById(String id);

  Future<void> rematerializeForward({
    required String seriesId,
    required DateTime todayDateOnly,
  });

  Stream<List<IncomeRecurringSeries>> watchAll();

  Future<void> deactivateSeries({
    required String seriesId,
    required DateTime todayDateOnly,
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
