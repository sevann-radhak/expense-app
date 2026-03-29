import 'package:drift/drift.dart';

import 'package:expense_app/data/local/app_database.dart';
import 'package:expense_app/domain/income_category.dart';
import 'package:expense_app/domain/income_taxonomy_repository.dart';

class DriftIncomeTaxonomyRepository implements IncomeTaxonomyRepository {
  DriftIncomeTaxonomyRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<List<IncomeCategory>> watchIncomeCategories() {
    return (_db.select(_db.incomeCategories)
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .watch()
        .map(
          (rows) => rows
              .map(
                (r) => IncomeCategory(
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
  Stream<List<IncomeSubcategory>> watchAllIncomeSubcategories() {
    return (_db.select(_db.incomeSubcategories)
          ..orderBy([
            (t) => OrderingTerm.asc(t.categoryId),
            (t) => OrderingTerm.asc(t.sortOrder),
          ]))
        .watch()
        .map(
          (rows) => rows
              .map(
                (r) => IncomeSubcategory(
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
  Stream<List<IncomeSubcategory>> watchIncomeSubcategories(String categoryId) {
    return (_db.select(_db.incomeSubcategories)
          ..where((s) => s.categoryId.equals(categoryId))
          ..orderBy([(s) => OrderingTerm.asc(s.sortOrder)]))
        .watch()
        .map(
          (rows) => rows
              .map(
                (r) => IncomeSubcategory(
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
}
