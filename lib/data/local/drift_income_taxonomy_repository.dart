import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'package:expense_app/data/local/app_database.dart';
import 'package:expense_app/domain/domain.dart';

class DriftIncomeTaxonomyRepository implements IncomeTaxonomyRepository {
  DriftIncomeTaxonomyRepository(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  IncomeCategory _incCatFromRow(IncomeCategoryRow r) => IncomeCategory(
        id: r.id,
        name: r.name,
        description: r.description,
        sortOrder: r.sortOrder,
        isActive: r.isActive,
      );

  IncomeSubcategory _incSubFromRow(IncomeSubcategoryRow r) => IncomeSubcategory(
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

  Future<int> _maxIncomeCategorySortOrder() async {
    final rows = await (_db.select(_db.incomeCategories)
          ..orderBy([(c) => OrderingTerm.desc(c.sortOrder)])
          ..limit(1))
        .get();
    if (rows.isEmpty) {
      return -1;
    }
    return rows.single.sortOrder;
  }

  @override
  Stream<List<IncomeCategory>> watchIncomeCategories() {
    return (_db.select(_db.incomeCategories)
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .watch()
        .map((rows) => rows.map(_incCatFromRow).toList());
  }

  @override
  Stream<List<IncomeSubcategory>> watchAllIncomeSubcategories() {
    return (_db.select(_db.incomeSubcategories)
          ..orderBy([
            (t) => OrderingTerm.asc(t.categoryId),
            (t) => OrderingTerm.asc(t.sortOrder),
          ]))
        .watch()
        .map((rows) => rows.map(_incSubFromRow).toList());
  }

  @override
  Stream<List<IncomeSubcategory>> watchIncomeSubcategories(String categoryId) {
    return (_db.select(_db.incomeSubcategories)
          ..where((s) => s.categoryId.equals(categoryId))
          ..orderBy([(s) => OrderingTerm.asc(s.sortOrder)]))
        .watch()
        .map((rows) => rows.map(_incSubFromRow).toList());
  }

  @override
  Future<String> createIncomeCategory({required String name, String? description}) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError.value(name, 'name', 'must be non-empty');
    }
    final id = _uuid.v4();
    final sortOrder = (await _maxIncomeCategorySortOrder()) + 1;
    final desc = _normDesc(description);
    await _db.transaction(() async {
      await _db.into(_db.incomeCategories).insert(
            IncomeCategoriesCompanion.insert(
              id: id,
              name: trimmed,
              description: Value(desc),
              sortOrder: Value(sortOrder),
            ),
          );
      await _db.into(_db.incomeSubcategories).insert(
            IncomeSubcategoriesCompanion.insert(
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
  Future<String> createIncomeSubcategory({
    required String categoryId,
    required String name,
    String? description,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError.value(name, 'name', 'must be non-empty');
    }
    final cat = await (_db.select(_db.incomeCategories)
          ..where((c) => c.id.equals(categoryId)))
        .getSingleOrNull();
    if (cat == null) {
      throw ArgumentError.value(categoryId, 'categoryId', 'Unknown income category');
    }
    final existing = await (_db.select(_db.incomeSubcategories)
          ..where((s) => s.categoryId.equals(categoryId)))
        .get();
    var base = slugifyTaxonomyName(trimmed);
    var slug = base;
    var n = 0;
    while (existing.any((s) => s.slug == slug)) {
      n++;
      slug = '${base}_$n';
    }
    final nonOther =
        existing.where((s) => s.slug != kOtherSubcategorySlug).toList();
    var nextOrder = nonOther.isEmpty
        ? 0
        : nonOther.map((s) => s.sortOrder).reduce((a, b) => a > b ? a : b) + 1;
    if (nextOrder >= 999) {
      throw StateError('Too many income subcategories in this category');
    }
    final id = _uuid.v4();
    final desc = _normDesc(description);
    await _db.into(_db.incomeSubcategories).insert(
          IncomeSubcategoriesCompanion.insert(
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
  Future<void> setIncomeCategoryName(String id, String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError.value(name, 'name', 'must be non-empty');
    }
    await (_db.update(_db.incomeCategories)..where((t) => t.id.equals(id))).write(
      IncomeCategoriesCompanion(name: Value(trimmed)),
    );
  }

  @override
  Future<void> setIncomeSubcategoryName(String id, String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError.value(name, 'name', 'must be non-empty');
    }
    await (_db.update(_db.incomeSubcategories)..where((t) => t.id.equals(id))).write(
      IncomeSubcategoriesCompanion(name: Value(trimmed)),
    );
  }

  @override
  Future<void> deleteIncomeSubcategory(String id) async {
    final row = await (_db.select(_db.incomeSubcategories)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row == null) {
      return;
    }
    if (row.isSystemReserved || row.slug == kOtherSubcategorySlug) {
      throw ReservedSubcategoryException(
        'Cannot delete reserved income subcategory "${row.name}".',
      );
    }
    await (_db.update(_db.incomeSubcategories)..where((t) => t.id.equals(id))).write(
      const IncomeSubcategoriesCompanion(isActive: Value(false)),
    );
  }

  @override
  Future<void> deactivateIncomeCategory(String id) async {
    await _db.transaction(() async {
      await (_db.update(_db.incomeCategories)..where((c) => c.id.equals(id))).write(
        const IncomeCategoriesCompanion(isActive: Value(false)),
      );
      await (_db.update(_db.incomeSubcategories)..where((s) => s.categoryId.equals(id)))
          .write(
        const IncomeSubcategoriesCompanion(isActive: Value(false)),
      );
    });
  }

  @override
  Future<void> reactivateIncomeCategory(String id) async {
    await _db.transaction(() async {
      await (_db.update(_db.incomeCategories)..where((c) => c.id.equals(id))).write(
        const IncomeCategoriesCompanion(isActive: Value(true)),
      );
      await (_db.update(_db.incomeSubcategories)..where((s) => s.categoryId.equals(id)))
          .write(
        const IncomeSubcategoriesCompanion(isActive: Value(true)),
      );
    });
  }

  @override
  Future<void> reactivateIncomeSubcategory(String id) async {
    await (_db.update(_db.incomeSubcategories)..where((t) => t.id.equals(id))).write(
      const IncomeSubcategoriesCompanion(isActive: Value(true)),
    );
  }

  @override
  Future<void> setIncomeCategoryDescription(String id, String? description) async {
    final stored = _normDesc(description);
    await (_db.update(_db.incomeCategories)..where((t) => t.id.equals(id))).write(
      IncomeCategoriesCompanion(description: Value(stored)),
    );
  }

  @override
  Future<void> setIncomeSubcategoryDescription(
    String id,
    String? description,
  ) async {
    final stored = _normDesc(description);
    await (_db.update(_db.incomeSubcategories)..where((t) => t.id.equals(id)))
        .write(
      IncomeSubcategoriesCompanion(description: Value(stored)),
    );
  }
}
