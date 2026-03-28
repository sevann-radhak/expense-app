import 'package:drift/drift.dart';

import 'package:expense_app/data/local/app_database.dart';
import 'package:expense_app/domain/category.dart';

/// Built-in default taxonomy for **Argentina-style** everyday expenses.
///
/// Template id: [kDefaultTaxonomyTemplateId]. Future: load a different template
/// from settings / remote config while keeping the same schema.
const String kDefaultTaxonomyTemplateId = 'argent_basic_v1';

/// English labels in DB (UI can map via i18n later).
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

  /// (localKey, display name, slug, sortOrder). [isOther] marks the reserved row.
  static List<
      ({
        String key,
        String name,
        String slug,
        int sortOrder,
        bool isOther,
      })> _subsForCategory(String categoryId) {
    return switch (categoryId) {
      'cat_formation' => [
          (key: 'courses', name: 'Courses & training', slug: 'formation_courses', sortOrder: 0, isOther: false),
          (key: 'books', name: 'Books & materials', slug: 'formation_books', sortOrder: 1, isOther: false),
          _otherRow(),
        ],
      'cat_fixed_expenses' => [
          (key: 'water', name: 'Water', slug: 'fixed_water', sortOrder: 0, isOther: false),
          (key: 'rent', name: 'Rent', slug: 'fixed_rent', sortOrder: 1, isOther: false),
          (key: 'cellphone', name: 'Cell phone', slug: 'fixed_cellphone', sortOrder: 2, isOther: false),
          (key: 'hoa', name: 'HOA & building fees', slug: 'fixed_hoa', sortOrder: 3, isOther: false),
          (key: 'gas', name: 'Natural gas', slug: 'fixed_natural_gas', sortOrder: 4, isOther: false),
          (key: 'internet_tv', name: 'Internet & TV', slug: 'fixed_internet_tv', sortOrder: 5, isOther: false),
          (key: 'electricity', name: 'Electricity', slug: 'fixed_electricity', sortOrder: 6, isOther: false),
          (key: 'groceries', name: 'Groceries & supermarket', slug: 'fixed_groceries', sortOrder: 7, isOther: false),
          (key: 'education', name: 'Education & tuition', slug: 'fixed_education', sortOrder: 8, isOther: false),
          (key: 'subscriptions', name: 'Subscriptions & apps', slug: 'fixed_subscriptions', sortOrder: 9, isOther: false),
          _otherRow(),
        ],
      'cat_taxes' => [
          (key: 'national', name: 'National taxes', slug: 'taxes_national', sortOrder: 0, isOther: false),
          (key: 'provincial', name: 'Provincial & municipal', slug: 'taxes_provincial', sortOrder: 1, isOther: false),
          (key: 'vehicle', name: 'Vehicle taxes & fees', slug: 'taxes_vehicle', sortOrder: 2, isOther: false),
          (key: 'property', name: 'Property-related taxes', slug: 'taxes_property', sortOrder: 3, isOther: false),
          _otherRow(),
        ],
      'cat_investments' => [
          (key: 'brokerage', name: 'Brokerage & securities', slug: 'inv_brokerage', sortOrder: 0, isOther: false),
          (key: 'funds', name: 'Funds & depositary assets', slug: 'inv_funds', sortOrder: 1, isOther: false),
          (key: 'crypto', name: 'Crypto assets', slug: 'inv_crypto', sortOrder: 2, isOther: false),
          (key: 'fixed_income', name: 'Fixed income', slug: 'inv_fixed_income', sortOrder: 3, isOther: false),
          _otherRow(),
        ],
      'cat_leisure' => [
          (key: 'entertainment', name: 'Entertainment', slug: 'leisure_entertainment', sortOrder: 0, isOther: false),
          (key: 'dining', name: 'Dining out', slug: 'leisure_dining', sortOrder: 1, isOther: false),
          (key: 'travel', name: 'Travel', slug: 'leisure_travel', sortOrder: 2, isOther: false),
          (key: 'hobbies', name: 'Hobbies', slug: 'leisure_hobbies', sortOrder: 3, isOther: false),
          _otherRow(),
        ],
      'cat_health' => [
          (key: 'personal_care', name: 'Personal care', slug: 'health_personal_care', sortOrder: 0, isOther: false),
          (key: 'pharmacy', name: 'Pharmacy', slug: 'health_pharmacy', sortOrder: 1, isOther: false),
          (key: 'gym', name: 'Gym & sports', slug: 'health_gym', sortOrder: 2, isOther: false),
          (key: 'health_plan', name: 'Health plan & prepaid medicine', slug: 'health_plan', sortOrder: 3, isOther: false),
          _otherRow(),
        ],
      'cat_transport' => [
          (key: 'public', name: 'Public transport', slug: 'transport_public', sortOrder: 0, isOther: false),
          (key: 'private_vehicle', name: 'Private vehicle', slug: 'transport_private_vehicle', sortOrder: 1, isOther: false),
          (key: 'fuel', name: 'Fuel', slug: 'transport_fuel', sortOrder: 2, isOther: false),
          (key: 'parking', name: 'Parking & tolls', slug: 'transport_parking', sortOrder: 3, isOther: false),
          (key: 'maintenance', name: 'Vehicle maintenance', slug: 'transport_maintenance', sortOrder: 4, isOther: false),
          _otherRow(),
        ],
      'cat_housing' => [
          (key: 'decoration', name: 'Decoration', slug: 'housing_decoration', sortOrder: 0, isOther: false),
          (key: 'appliances', name: 'Appliances', slug: 'housing_appliances', sortOrder: 1, isOther: false),
          (key: 'cleaning', name: 'Cleaning supplies', slug: 'housing_cleaning', sortOrder: 2, isOther: false),
          (key: 'furniture', name: 'Furniture', slug: 'housing_furniture', sortOrder: 3, isOther: false),
          (key: 'repairs', name: 'Repairs & improvements', slug: 'housing_repairs', sortOrder: 4, isOther: false),
          _otherRow(),
        ],
      _ => [_otherRow()],
    };
  }

  static ({String key, String name, String slug, int sortOrder, bool isOther}) _otherRow() {
    return (
      key: 'other',
      name: 'Other',
      slug: kOtherSubcategorySlug,
      sortOrder: 999,
      isOther: true,
    );
  }

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
        final subs = _subsForCategory(c.id);
        for (final s in subs) {
          b.insert(
            db.subcategories,
            SubcategoriesCompanion.insert(
              id: '${c.id}_${s.key}',
              categoryId: c.id,
              name: s.name,
              slug: s.slug,
              isSystemReserved: Value(s.isOther),
              sortOrder: Value(s.sortOrder),
            ),
          );
        }
      }
    });
  }
}
