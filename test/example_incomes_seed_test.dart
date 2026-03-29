import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:expense_app/data/local/app_database.dart';
import 'package:expense_app/data/local/category_seed.dart';
import 'package:expense_app/data/local/example_incomes_seed.dart';
import 'package:expense_app/data/local/income_category_seed.dart';

void main() {
  test(
      'populateExampleIncomes inserts sporadic rows, salary series, and is idempotent',
      () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(() async {
      await db.close();
    });
    await db.customSelect('SELECT 1').getSingle();
    await CategorySeeder.ensureSeedData(db);
    await IncomeCategorySeeder.ensureSeedData(db);

    await populateExampleIncomes(db);

    final rows = await db.select(db.incomeEntries).get();
    final demo = rows
        .where(
          (r) =>
              r.id.startsWith('inc_demo') || r.id.startsWith('sir_inc_demo'),
        )
        .toList();
    expect(demo.length, greaterThan(9));

    final seriesRows = await db.select(db.incomeRecSeries).get();
    expect(
      seriesRows.any((s) => s.id == 'inc_demo_series_salary'),
      isTrue,
    );

    final salaryLines = demo
        .where((r) => r.recurringSeriesId == 'inc_demo_series_salary')
        .toList();
    expect(salaryLines.length, greaterThanOrEqualTo(10));

    await populateExampleIncomes(db);
    final after = await db.select(db.incomeEntries).get();
    final demo2 = after
        .where(
          (r) =>
              r.id.startsWith('inc_demo') || r.id.startsWith('sir_inc_demo'),
        )
        .length;
    expect(demo2, demo.length);
  });
}
