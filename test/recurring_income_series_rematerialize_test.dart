import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

import 'package:expense_app/data/local/app_database.dart';
import 'package:expense_app/data/local/drift_recurring_income_series_repository.dart';
import 'package:expense_app/domain/domain.dart';

void main() {
  test(
    'rematerializeForward with cutoff does not rewrite future months before cutoff',
    () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(() async {
        await db.close();
      });
      await db.customSelect('SELECT 1').getSingle();

      final incCats = await db.select(db.incomeCategories).get();
      expect(incCats, isNotEmpty);
      final categoryId = incCats.first.id;
      final subs = await (db.select(db.incomeSubcategories)
            ..where((s) => s.categoryId.equals(categoryId)))
          .get();
      expect(subs, isNotEmpty);
      final subId = subs.first.id;

      final seriesId = const Uuid().v4();
      final repo = DriftRecurringIncomeSeriesRepository(db);
      final today = DateTime(2026, 3, 1);

      Future<double?> amountOn(String yyyyMmDd) async {
        final rows = await (db.select(db.incomeEntries)
              ..where((e) => e.recurringSeriesId.equals(seriesId)))
            .get();
        final match =
            rows.where((r) => r.receivedOn == yyyyMmDd).toList();
        if (match.isEmpty) {
          return null;
        }
        return match.single.amountOriginal;
      }

      await repo.upsertAndRematerialize(
        IncomeRecurringSeries(
          id: seriesId,
          anchorReceivedOn: DateTime(2026, 1, 5),
          rule: const RecurrenceMonthlyByCalendarDay(calendarDay: 5),
          endCondition: const RecurrenceEndNever(),
          horizonMonths: 8,
          active: true,
          incomeCategoryId: categoryId,
          incomeSubcategoryId: subId,
          amountOriginal: 3800,
          currencyCode: 'USD',
          manualFxRateToUsd: 1,
          amountUsd: IncomeEntry.computeUsd(3800, 1),
          description: 'JBK',
        ),
        today,
      );

      expect(await amountOn('2026-05-05'), 3800);

      await repo.upsert(
        IncomeRecurringSeries(
          id: seriesId,
          anchorReceivedOn: DateTime(2026, 1, 5),
          rule: const RecurrenceMonthlyByCalendarDay(calendarDay: 5),
          endCondition: const RecurrenceEndNever(),
          horizonMonths: 8,
          active: true,
          incomeCategoryId: categoryId,
          incomeSubcategoryId: subId,
          amountOriginal: 4000,
          currencyCode: 'USD',
          manualFxRateToUsd: 1,
          amountUsd: IncomeEntry.computeUsd(4000, 1),
          description: 'JBK',
        ),
      );
      await repo.rematerializeForward(
        seriesId: seriesId,
        todayDateOnly: today,
        rematerializeOccurrencesOnOrAfter: DateTime(2026, 6, 5),
      );

      expect(await amountOn('2026-05-05'), 3800);
      expect(await amountOn('2026-06-05'), 4000);
    },
  );
}
