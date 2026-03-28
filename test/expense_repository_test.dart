import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:expense_app/data/local/app_database.dart';
import 'package:expense_app/data/local/drift_expense_repository.dart';
import 'package:expense_app/domain/domain.dart';

void main() {
  late AppDatabase db;
  late DriftExpenseRepository repo;
  late String categoryAId;
  late String subcategoryAId;
  late String categoryBId;
  late String subcategoryBId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await db.customSelect('SELECT 1').getSingle();
    repo = DriftExpenseRepository(db);
    final cats = await db.select(db.categories).get();
    expect(cats.length, greaterThanOrEqualTo(2));
    categoryAId = cats.first.id;
    categoryBId = cats.last.id;
    final subsA = await (db.select(db.subcategories)
          ..where((s) => s.categoryId.equals(categoryAId)))
        .get();
    subcategoryAId = subsA.firstWhere((s) => s.slug == kOtherSubcategorySlug).id;
    final subsB = await (db.select(db.subcategories)
          ..where((s) => s.categoryId.equals(categoryBId)))
        .get();
    subcategoryBId = subsB.firstWhere((s) => s.slug == kOtherSubcategorySlug).id;
  });

  tearDown(() async {
    await db.close();
  });

  Expense sample({
    required String id,
    required DateTime occurredOn,
    String? categoryId,
    String? subcategoryId,
  }) {
    return Expense(
      id: id,
      occurredOn: occurredOn,
      categoryId: categoryId ?? categoryAId,
      subcategoryId: subcategoryId ?? subcategoryAId,
      amountOriginal: 25.5,
      currencyCode: 'USD',
      manualFxRateToUsd: 1,
      amountUsd: 25.5,
      paidWithCreditCard: false,
    );
  }

  test('create rejects subcategory that does not match category', () async {
    expect(
      () => repo.create(
        sample(
          id: 'e_bad',
          occurredOn: DateTime(2025, 6, 10),
          categoryId: categoryAId,
          subcategoryId: subcategoryBId,
        ),
      ),
      throwsA(isA<InvalidSubcategoryPairingException>()),
    );
  });

  test('watchForMonth uses local calendar boundaries', () async {
    await repo.create(
      sample(id: 'e_jan', occurredOn: DateTime(2025, 1, 31)),
    );
    await repo.create(
      sample(id: 'e_feb', occurredOn: DateTime(2025, 2, 1)),
    );
    final jan = await repo.watchForMonth(2025, 1).first;
    expect(jan.map((e) => e.id).toList(), ['e_jan']);
    final feb = await repo.watchForMonth(2025, 2).first;
    expect(feb.map((e) => e.id).toList(), ['e_feb']);
  });

  test('update recomputes USD and enforces pairing', () async {
    await repo.create(
      sample(id: 'e1', occurredOn: DateTime(2025, 3, 5)),
    );
    await repo.update(
      sample(id: 'e1', occurredOn: DateTime(2025, 3, 5)).copyWith(
        amountOriginal: 100,
        manualFxRateToUsd: 2,
        amountUsd: 0,
      ),
    );
    final row = await (db.select(db.expenses)..where((e) => e.id.equals('e1')))
        .getSingle();
    expect(row.amountUsd, 200);
    expect(
      () => repo.update(
        sample(
          id: 'e1',
          occurredOn: DateTime(2025, 3, 5),
          categoryId: categoryAId,
          subcategoryId: subcategoryBId,
        ),
      ),
      throwsA(isA<InvalidSubcategoryPairingException>()),
    );
  });

  test('delete removes row', () async {
    await repo.create(sample(id: 'e_del', occurredOn: DateTime(2025, 4, 1)));
    await repo.delete('e_del');
    final rows = await db.select(db.expenses).get();
    expect(rows.where((r) => r.id == 'e_del'), isEmpty);
  });

  test('create and update persist description', () async {
    await repo.create(
      sample(id: 'e_note', occurredOn: DateTime(2025, 7, 2)).copyWith(
        description: 'Team lunch',
      ),
    );
    var list = await repo.watchForMonth(2025, 7).first;
    expect(list.single.description, 'Team lunch');
    await repo.update(list.single.copyWith(description: 'Updated note'));
    list = await repo.watchForMonth(2025, 7).first;
    expect(list.single.description, 'Updated note');
  });
}
