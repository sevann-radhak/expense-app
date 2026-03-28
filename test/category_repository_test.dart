import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:expense_app/data/local/app_database.dart';
import 'package:expense_app/data/local/drift_category_repository.dart';
import 'package:expense_app/domain/domain.dart';

void main() {
  late AppDatabase db;
  late DriftCategoryRepository repo;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await db.customSelect('SELECT 1').getSingle();
    repo = DriftCategoryRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('seed creates eight categories each with exactly one Other subcategory', () async {
    final cats = await db.select(db.categories).get();
    expect(cats.length, 8);

    for (final c in cats) {
      final subs = await (db.select(db.subcategories)
            ..where((t) => t.categoryId.equals(c.id)))
          .get();
      expect(subs.length, greaterThanOrEqualTo(1));
      final others = subs.where((s) => s.slug == kOtherSubcategorySlug).toList();
      expect(others, hasLength(1));
      expect(others.single.isSystemReserved, isTrue);
    }
  });

  test('default template includes multiple subcategories per category', () async {
    final subs = await (db.select(db.subcategories)
          ..where((t) => t.categoryId.equals('cat_fixed_expenses')))
        .get();
    expect(subs.length, greaterThan(3));
  });

  test('deleteSubcategory throws for system Other', () async {
    final row = await (db.select(db.subcategories)
          ..where((t) => t.slug.equals(kOtherSubcategorySlug))
          ..limit(1))
        .getSingle();

    expect(
      () => repo.deleteSubcategory(row.id),
      throwsA(isA<ReservedSubcategoryException>()),
    );
  });
}
