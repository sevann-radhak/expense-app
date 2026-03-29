import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:expense_app/data/local/app_database.dart';
import 'package:expense_app/data/local/category_seed.dart';
import 'package:expense_app/data/local/example_expenses_seed.dart';

void main() {
  test('populateExampleExpenses inserts year of demo rows with EUR and USD travel months', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(() async {
      await db.close();
    });
    await db.customSelect('SELECT 1').getSingle();
    await CategorySeeder.ensureSeedData(db);

    await populateExampleExpenses(db);

    final rows = await db.select(db.expenses).get();
    final demo = rows.where((r) => r.id.startsWith('exp_demo')).toList();
    expect(demo.length, greaterThan(50));

    final months = demo.map((r) => r.occurredOn.substring(5, 7)).toSet();
    expect(months.length, 12);

    final juneEur = demo.where(
      (r) => r.occurredOn.startsWith('$kExampleDemoExpenseYear-06') && r.currencyCode == 'EUR',
    ).length;
    expect(juneEur, greaterThanOrEqualTo(1));

    final decUsd = demo.where(
      (r) => r.occurredOn.startsWith('$kExampleDemoExpenseYear-12') && r.currencyCode == 'USD',
    ).length;
    expect(decUsd, greaterThanOrEqualTo(1));

    await populateExampleExpenses(db);
    final afterSecond = await db.select(db.expenses).get();
    final demo2 = afterSecond.where((r) => r.id.startsWith('exp_demo')).length;
    expect(demo2, demo.length);
  });
}
