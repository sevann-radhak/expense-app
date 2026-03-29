import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

import 'package:expense_app/data/local/app_database.dart';
import 'package:expense_app/data/local/drift_recurring_expense_series_repository.dart';
import 'package:expense_app/domain/domain.dart';

void main() {
  test('upsertAndRematerialize creates future rows for monthly series', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(() async {
      await db.close();
    });
    await db.customSelect('SELECT 1').getSingle();

    final cats = await db.select(db.categories).get();
    final categoryAId = cats.first.id;
    final subs = await (db.select(db.subcategories)
          ..where((s) => s.categoryId.equals(categoryAId)))
        .get();
    final subOther = subs.firstWhere((s) => s.slug == kOtherSubcategorySlug);

    final seriesId = const Uuid().v4();
    final repo = DriftRecurringExpenseSeriesRepository(db);
    final today = DateTime(2026, 3, 15);

    await repo.upsertAndRematerialize(
      ExpenseRecurringSeries(
        id: seriesId,
        anchorOccurredOn: DateTime(2026, 3, 1),
        rule: const RecurrenceMonthlyByCalendarDay(calendarDay: 1),
        endCondition: const RecurrenceEndNever(),
        horizonMonths: 3,
        active: true,
        categoryId: categoryAId,
        subcategoryId: subOther.id,
        amountOriginal: 50,
        currencyCode: 'USD',
        manualFxRateToUsd: 1,
        amountUsd: 50,
        paidWithCreditCard: false,
        description: 'Rent',
      ),
      today,
    );

    final all = await db.select(db.expenses).get();
    final march = all
        .where(
          (r) =>
              r.occurredOn.compareTo('2026-03-01') >= 0 &&
              r.occurredOn.compareTo('2026-04-01') < 0,
        )
        .toList();
    expect(march.length, greaterThanOrEqualTo(1));
    expect(
      march.every((r) => r.recurringSeriesId == seriesId),
      isTrue,
    );
    final marchRow = march.first;
    expect(marchRow.paymentExpectationStatus, 'confirmedPaid');
    expect(marchRow.paymentExpectationConfirmedOn, '2026-03-01');

    final april = all
        .where(
          (r) =>
              r.occurredOn.compareTo('2026-04-01') >= 0 &&
              r.occurredOn.compareTo('2026-05-01') < 0,
        )
        .toList();
    expect(april, isNotEmpty);
    expect(april.first.paymentExpectationStatus, 'expected');

    final june = all
        .where(
          (r) =>
              r.occurredOn.compareTo('2026-06-01') >= 0 &&
              r.occurredOn.compareTo('2026-07-01') < 0,
        )
        .toList();
    expect(june.length, 1);
  });

  test('rematerializeForward deletes strictly-future unrealized rows then refills', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(() async {
      await db.close();
    });
    await db.customSelect('SELECT 1').getSingle();

    final cats = await db.select(db.categories).get();
    final categoryAId = cats.first.id;
    final subs = await (db.select(db.subcategories)
          ..where((s) => s.categoryId.equals(categoryAId)))
        .get();
    final subOther = subs.firstWhere((s) => s.slug == kOtherSubcategorySlug);

    final seriesId = const Uuid().v4();
    final repo = DriftRecurringExpenseSeriesRepository(db);

    await repo.upsertAndRematerialize(
      ExpenseRecurringSeries(
        id: seriesId,
        anchorOccurredOn: DateTime(2026, 3, 1),
        rule: const RecurrenceMonthlyByCalendarDay(calendarDay: 1),
        endCondition: const RecurrenceEndNever(),
        horizonMonths: 4,
        active: true,
        categoryId: categoryAId,
        subcategoryId: subOther.id,
        amountOriginal: 10,
        currencyCode: 'USD',
        manualFxRateToUsd: 1,
        amountUsd: 10,
        paidWithCreditCard: false,
      ),
      DateTime(2026, 3, 15),
    );

    await repo.upsert(
      ExpenseRecurringSeries(
        id: seriesId,
        anchorOccurredOn: DateTime(2026, 3, 1),
        rule: const RecurrenceMonthlyByCalendarDay(calendarDay: 15),
        endCondition: const RecurrenceEndNever(),
        horizonMonths: 4,
        active: true,
        categoryId: categoryAId,
        subcategoryId: subOther.id,
        amountOriginal: 99,
        currencyCode: 'USD',
        manualFxRateToUsd: 1,
        amountUsd: 99,
        paidWithCreditCard: false,
      ),
    );
    await repo.rematerializeForward(
      seriesId: seriesId,
      todayDateOnly: DateTime(2026, 3, 15),
    );

    final futureRows = (await db.select(db.expenses).get())
        .where(
          (r) =>
              r.recurringSeriesId == seriesId &&
              r.occurredOn.compareTo('2026-03-15') > 0,
        )
        .toList();
    expect(futureRows.every((r) => r.amountOriginal == 99), isTrue);
  });
}
