import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:expense_app/application/application.dart';
import 'package:expense_app/data/local/app_database.dart';
import 'package:expense_app/domain/domain.dart';
import 'package:expense_app/data/local/book_backup_export.dart';
import 'package:expense_app/data/local/book_backup_importer.dart';
import 'package:expense_app/data/local/category_seed.dart';

void main() {
  test('importBookBackupReplacingAll restores snapshot on same database', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(() async {
      await db.close();
    });
    await db.customSelect('SELECT 1').getSingle();
    await CategorySeeder.ensureSeedData(db);

    final snap = await exportFullBookSnapshot(db);
    final json = encodeBookBackupPretty(snap);
    final parsed = decodeBookBackup(json);

    final report = await importBookBackupReplacingAll(db, parsed);
    expect(report.hadRepairs, isFalse);

    final cats = await db.select(db.categories).get();
    final subs = await db.select(db.subcategories).get();
    expect(cats.length, snap.categories.length);
    expect(subs.length, snap.subcategories.length);
  });

  test('import skips expense with missing subcategory and still loads book', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(() async {
      await db.close();
    });
    await db.customSelect('SELECT 1').getSingle();
    await CategorySeeder.ensureSeedData(db);
    final base = await exportFullBookSnapshot(db);
    final badExpense = Expense(
      id: 'orphan_exp',
      occurredOn: DateTime(2026, 1, 1),
      categoryId: base.categories.first.id,
      subcategoryId: 'sub_does_not_exist',
      amountOriginal: 1,
      currencyCode: 'USD',
      manualFxRateToUsd: 1,
      amountUsd: 1,
      paidWithCreditCard: false,
    );
    final tainted = BookBackupSnapshot(
      schemaVersion: base.schemaVersion,
      exportedAt: base.exportedAt,
      categories: base.categories,
      subcategories: base.subcategories,
      paymentInstruments: base.paymentInstruments,
      expenses: [...base.expenses, badExpense],
    );
    final report = await importBookBackupReplacingAll(db, tainted);
    expect(report.expensesSkipped, 1);
    final rows = await db.select(db.expenses).get();
    expect(rows.any((r) => r.id == 'orphan_exp'), isFalse);
  });

  test('validateBookBackupSnapshot rejects orphan expense subcategory', () {
    final snap = BookBackupSnapshot(
      schemaVersion: BookBackupSnapshot.currentSchemaVersion,
      exportedAt: DateTime.utc(2026),
      categories: const [Category(id: 'c1', name: 'A', sortOrder: 0)],
      subcategories: const [],
      paymentInstruments: const [],
      expenses: [
        Expense(
          id: 'e1',
          occurredOn: DateTime(2026),
          categoryId: 'c1',
          subcategoryId: 'missing',
          amountOriginal: 1,
          currencyCode: 'USD',
          manualFxRateToUsd: 1,
          amountUsd: 1,
          paidWithCreditCard: false,
        ),
      ],
    );
    expect(() => validateBookBackupSnapshot(snap), throwsArgumentError);
  });
}
