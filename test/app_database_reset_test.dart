import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:expense_app/data/local/app_database.dart';
import 'package:expense_app/data/local/app_database_reset.dart';
import 'package:expense_app/data/local/drift_expense_repository.dart';
import 'package:expense_app/domain/domain.dart';

void main() {
  test('resetLocalDatabaseToInitialState clears expenses and restores seed', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(() async => db.close());
    await db.customSelect('SELECT 1').getSingle();
    final repo = DriftExpenseRepository(db);
    final catsForExpense = await db.select(db.categories).get();
    expect(catsForExpense, isNotEmpty);
    final cat = catsForExpense.first;
    final subs = await (db.select(db.subcategories)
          ..where((s) => s.categoryId.equals(cat.id)))
        .get();
    final sub = subs.firstWhere((s) => s.slug == kOtherSubcategorySlug);
    await repo.create(
      Expense(
        id: 'x1',
        occurredOn: DateTime(2025, 1, 1),
        categoryId: cat.id,
        subcategoryId: sub.id,
        amountOriginal: 1,
        currencyCode: 'ARS',
        manualFxRateToUsd: 1,
        amountUsd: 1,
        paidWithCreditCard: false,
      ),
    );
    expect(await db.select(db.expenses).get(), isNotEmpty);

    await db.into(db.paymentInstruments).insert(
          PaymentInstrumentsCompanion.insert(
            id: 'pi_reset_test',
            label: 'Test card',
          ),
        );
    expect(await db.select(db.paymentInstruments).get(), isNotEmpty);

    await resetLocalDatabaseToInitialState(db);

    expect(await db.select(db.expenses).get(), isEmpty);
    expect(await db.select(db.paymentInstruments).get(), isEmpty);
    final cats = await db.select(db.categories).get();
    expect(cats.length, 11);
  });
}
