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

  test('seed creates built-in categories each with exactly one Other subcategory', () async {
    final cats = await db.select(db.categories).get();
    expect(cats.length, 11);

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

  test('deleteSubcategory soft-deactivates user subcategory', () async {
    final row = await (db.select(db.subcategories)
          ..where((t) => t.slug.equals('formation_courses'))
          ..limit(1))
        .getSingle();
    await repo.deleteSubcategory(row.id);
    final after = await (db.select(db.subcategories)
          ..where((t) => t.id.equals(row.id)))
        .getSingle();
    expect(after.isActive, isFalse);
  });

  test('createCategory inserts category and Other subcategory', () async {
    final id = await repo.createCategory(name: 'Custom QA', description: 'd');
    final cat = await (db.select(db.categories)..where((c) => c.id.equals(id)))
        .getSingle();
    expect(cat.name, 'Custom QA');
    expect(cat.description, 'd');
    expect(cat.isActive, isTrue);
    final subs = await (db.select(db.subcategories)
          ..where((s) => s.categoryId.equals(id)))
        .get();
    expect(subs.length, 1);
    expect(subs.single.slug, kOtherSubcategorySlug);
    expect(subs.single.isSystemReserved, isTrue);
  });

  test('setCategoryDescription trims, persists, and clears', () async {
    await repo.setCategoryDescription('cat_formation', '  Hello  ');
    var row = await (db.select(db.categories)
          ..where((t) => t.id.equals('cat_formation')))
        .getSingle();
    expect(row.description, 'Hello');

    await repo.setCategoryDescription('cat_formation', null);
    row = await (db.select(db.categories)
          ..where((t) => t.id.equals('cat_formation')))
        .getSingle();
    expect(row.description, isNull);

    await repo.setCategoryDescription('cat_formation', '   ');
    row = await (db.select(db.categories)
          ..where((t) => t.id.equals('cat_formation')))
        .getSingle();
    expect(row.description, isNull);
  });

  test('setSubcategoryDescription persists', () async {
    final row = await (db.select(db.subcategories)
          ..where((t) => t.categoryId.equals('cat_leisure'))
          ..limit(1))
        .getSingle();
    await repo.setSubcategoryDescription(row.id, 'Day trips');
    final updated = await (db.select(db.subcategories)
          ..where((t) => t.id.equals(row.id)))
        .getSingle();
    expect(updated.description, 'Day trips');
  });

  test('ensureCategoryAndSubcategoryDescriptionColumns is idempotent', () async {
    await db.ensureCategoryAndSubcategoryDescriptionColumns();
    await db.ensureCategoryAndSubcategoryDescriptionColumns();
    final cats = await db.select(db.categories).get();
    expect(cats, isNotEmpty);
  });
}
