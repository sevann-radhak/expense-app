import 'package:drift/drift.dart';

import 'package:expense_app/data/local/app_database.dart';
import 'package:expense_app/domain/category.dart';

/// Master plan §7 — English names in DB. Each category gets exactly one **Other** row.
abstract final class CategorySeeder {
  static const _categories = <({String id, String name, int sortOrder})>[
    (id: 'cat_formation', name: 'Formation', sortOrder: 0),
    (id: 'cat_fixed_expenses', name: 'Fixed expenses', sortOrder: 1),
    (id: 'cat_taxes', name: 'Taxes', sortOrder: 2),
    (id: 'cat_investments', name: 'Investments', sortOrder: 3),
    (id: 'cat_leisure', name: 'Leisure', sortOrder: 4),
    (id: 'cat_health', name: 'Health', sortOrder: 5),
    (id: 'cat_transport', name: 'Transport', sortOrder: 6),
    (id: 'cat_housing', name: 'Housing', sortOrder: 7),
  ];

  static Future<void> ensureSeedData(AppDatabase db) async {
    final existing = await (db.select(db.categories)..limit(1)).get();
    if (existing.isNotEmpty) {
      return;
    }

    await db.batch((b) {
      for (final c in _categories) {
        b.insert(
          db.categories,
          CategoriesCompanion.insert(
            id: c.id,
            name: c.name,
            sortOrder: Value(c.sortOrder),
          ),
        );
        b.insert(
          db.subcategories,
          SubcategoriesCompanion.insert(
            id: '${c.id}_other',
            categoryId: c.id,
            name: 'Other',
            slug: kOtherSubcategorySlug,
            isSystemReserved: const Value(true),
            sortOrder: const Value(0),
          ),
        );
      }
    });
  }
}
