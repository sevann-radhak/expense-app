import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'package:expense_app/data/local/app_database.dart';
import 'package:expense_app/domain/domain.dart';

class DriftCategoryRepository implements CategoryRepository {
  DriftCategoryRepository(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  Category _catFromRow(CategoryRow r) => Category(
        id: r.id,
        name: r.name,
        description: r.description,
        sortOrder: r.sortOrder,
        isActive: r.isActive,
      );

  Subcategory _subFromRow(SubcategoryRow r) => Subcategory(
        id: r.id,
        categoryId: r.categoryId,
        name: r.name,
        description: r.description,
        slug: r.slug,
        isSystemReserved: r.isSystemReserved,
        sortOrder: r.sortOrder,
        isActive: r.isActive,
      );

  String? _normDesc(String? description) {
    final normalized = description?.trim();
    if (normalized == null || normalized.isEmpty) {
      return null;
    }
    return normalized;
  }

  Future<int> _maxCategorySortOrder() async {
    final rows = await (_db.select(_db.categories)
          ..orderBy([(c) => OrderingTerm.desc(c.sortOrder)])
          ..limit(1))
        .get();
    if (rows.isEmpty) {
      return -1;
    }
    return rows.single.sortOrder;
  }

  @override
  Stream<List<Subcategory>> watchAllSubcategories() {
    return (_db.select(_db.subcategories)
          ..orderBy([(t) => OrderingTerm.asc(t.categoryId), (t) => OrderingTerm.asc(t.sortOrder)]))
        .watch()
        .map((rows) => rows.map(_subFromRow).toList());
  }

  @override
  Stream<List<Category>> watchCategories() {
    return (_db.select(_db.categories)
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .watch()
        .map((rows) => rows.map(_catFromRow).toList());
  }

  @override
  Stream<List<Subcategory>> watchSubcategories(String categoryId) {
    return (_db.select(_db.subcategories)
          ..where((t) => t.categoryId.equals(categoryId))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .watch()
        .map((rows) => rows.map(_subFromRow).toList());
  }

  @override
  Future<String> createCategory({required String name, String? description}) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError.value(name, 'name', 'must be non-empty');
    }
    final id = _uuid.v4();
    final sortOrder = (await _maxCategorySortOrder()) + 1;
    final desc = _normDesc(description);
    await _db.transaction(() async {
      await _db.into(_db.categories).insert(
            CategoriesCompanion.insert(
              id: id,
              name: trimmed,
              description: Value(desc),
              sortOrder: Value(sortOrder),
            ),
          );
      await _db.into(_db.subcategories).insert(
            SubcategoriesCompanion.insert(
              id: '${id}_other',
              categoryId: id,
              name: 'Other',
              slug: kOtherSubcategorySlug,
              isSystemReserved: const Value(true),
              sortOrder: const Value(999),
            ),
          );
    });
    return id;
  }

  @override
  Future<String> createSubcategory({
    required String categoryId,
    required String name,
    String? description,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError.value(name, 'name', 'must be non-empty');
    }
    final cat = await (_db.select(_db.categories)..where((c) => c.id.equals(categoryId)))
        .getSingleOrNull();
    if (cat == null) {
      throw ArgumentError.value(categoryId, 'categoryId', 'Unknown category');
    }
    final existing = await (_db.select(_db.subcategories)
          ..where((s) => s.categoryId.equals(categoryId)))
        .get();
    var base = slugifyTaxonomyName(trimmed);
    var slug = base;
    var n = 0;
    while (existing.any((s) => s.slug == slug)) {
      n++;
      slug = '${base}_$n';
    }
    final nonOther = existing.where((s) => s.slug != kOtherSubcategorySlug).toList();
    var nextOrder = nonOther.isEmpty
        ? 0
        : nonOther.map((s) => s.sortOrder).reduce((a, b) => a > b ? a : b) + 1;
    if (nextOrder >= 999) {
      throw StateError('Too many subcategories in this category');
    }
    final id = _uuid.v4();
    final desc = _normDesc(description);
    await _db.into(_db.subcategories).insert(
          SubcategoriesCompanion.insert(
            id: id,
            categoryId: categoryId,
            name: trimmed,
            description: Value(desc),
            slug: slug,
            isSystemReserved: const Value(false),
            sortOrder: Value(nextOrder),
          ),
        );
    return id;
  }

  @override
  Future<void> setCategoryName(String id, String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError.value(name, 'name', 'must be non-empty');
    }
    await (_db.update(_db.categories)..where((t) => t.id.equals(id))).write(
      CategoriesCompanion(name: Value(trimmed)),
    );
  }

  @override
  Future<void> setSubcategoryName(String id, String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError.value(name, 'name', 'must be non-empty');
    }
    await (_db.update(_db.subcategories)..where((t) => t.id.equals(id))).write(
      SubcategoriesCompanion(name: Value(trimmed)),
    );
  }

  @override
  Future<void> deleteSubcategory(String id) async {
    final row = await (_db.select(_db.subcategories)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row == null) {
      return;
    }
    if (row.isSystemReserved || row.slug == kOtherSubcategorySlug) {
      throw ReservedSubcategoryException(
        'Cannot delete reserved subcategory "${row.name}".',
      );
    }
    await (_db.update(_db.subcategories)..where((t) => t.id.equals(id))).write(
      const SubcategoriesCompanion(isActive: Value(false)),
    );
  }

  @override
  Future<void> deactivateCategory(String id) async {
    await _db.transaction(() async {
      await (_db.update(_db.categories)..where((c) => c.id.equals(id))).write(
        const CategoriesCompanion(isActive: Value(false)),
      );
      await (_db.update(_db.subcategories)..where((s) => s.categoryId.equals(id))).write(
        const SubcategoriesCompanion(isActive: Value(false)),
      );
    });
  }

  @override
  Future<void> reactivateCategory(String id) async {
    await _db.transaction(() async {
      await (_db.update(_db.categories)..where((c) => c.id.equals(id))).write(
        const CategoriesCompanion(isActive: Value(true)),
      );
      await (_db.update(_db.subcategories)..where((s) => s.categoryId.equals(id))).write(
        const SubcategoriesCompanion(isActive: Value(true)),
      );
    });
  }

  @override
  Future<void> reactivateSubcategory(String id) async {
    await (_db.update(_db.subcategories)..where((t) => t.id.equals(id))).write(
      const SubcategoriesCompanion(isActive: Value(true)),
    );
  }

  @override
  Future<void> setCategoryDescription(String id, String? description) async {
    final stored = _normDesc(description);
    await (_db.update(_db.categories)..where((t) => t.id.equals(id))).write(
      CategoriesCompanion(description: Value(stored)),
    );
  }

  @override
  Future<void> setSubcategoryDescription(String id, String? description) async {
    final stored = _normDesc(description);
    await (_db.update(_db.subcategories)..where((t) => t.id.equals(id))).write(
      SubcategoriesCompanion(description: Value(stored)),
    );
  }
}
