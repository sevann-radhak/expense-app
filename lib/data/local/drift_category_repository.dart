import 'package:drift/drift.dart';

import 'package:expense_app/data/local/app_database.dart';
import 'package:expense_app/domain/domain.dart';

class DriftCategoryRepository implements CategoryRepository {
  DriftCategoryRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<List<Subcategory>> watchAllSubcategories() {
    return (_db.select(_db.subcategories)
          ..orderBy([(t) => OrderingTerm.asc(t.categoryId), (t) => OrderingTerm.asc(t.sortOrder)]))
        .watch()
        .map(
          (rows) => rows
              .map(
                (r) => Subcategory(
                  id: r.id,
                  categoryId: r.categoryId,
                  name: r.name,
                  description: r.description,
                  slug: r.slug,
                  isSystemReserved: r.isSystemReserved,
                  sortOrder: r.sortOrder,
                ),
              )
              .toList(),
        );
  }

  @override
  Stream<List<Category>> watchCategories() {
    return (_db.select(_db.categories)
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .watch()
        .map(
          (rows) => rows
              .map(
                (r) => Category(
                  id: r.id,
                  name: r.name,
                  description: r.description,
                  sortOrder: r.sortOrder,
                ),
              )
              .toList(),
        );
  }

  @override
  Stream<List<Subcategory>> watchSubcategories(String categoryId) {
    return (_db.select(_db.subcategories)
          ..where((t) => t.categoryId.equals(categoryId))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .watch()
        .map(
          (rows) => rows
              .map(
                (r) => Subcategory(
                  id: r.id,
                  categoryId: r.categoryId,
                  name: r.name,
                  description: r.description,
                  slug: r.slug,
                  isSystemReserved: r.isSystemReserved,
                  sortOrder: r.sortOrder,
                ),
              )
              .toList(),
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
    await (_db.delete(_db.subcategories)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> setCategoryDescription(String id, String? description) async {
    final normalized = description?.trim();
    final stored =
        normalized == null || normalized.isEmpty ? null : normalized;
    await (_db.update(_db.categories)..where((t) => t.id.equals(id))).write(
      CategoriesCompanion(description: Value(stored)),
    );
  }

  @override
  Future<void> setSubcategoryDescription(String id, String? description) async {
    final normalized = description?.trim();
    final stored =
        normalized == null || normalized.isEmpty ? null : normalized;
    await (_db.update(_db.subcategories)..where((t) => t.id.equals(id))).write(
      SubcategoriesCompanion(description: Value(stored)),
    );
  }
}
