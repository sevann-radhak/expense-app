import 'package:drift/drift.dart';

import 'package:expense_app/data/local/app_database.dart';
import 'package:expense_app/domain/category.dart';
import 'package:expense_app/domain/income_category.dart';

/// Built-in **income** taxonomy (separate from expense categories).
///
/// English labels in DB (UI can map via i18n later). Every category has a
/// system-reserved **Other** subcategory ([kOtherSubcategorySlug]).
abstract final class IncomeCategorySeeder {
  /// When migrating from income rows that pointed at expense taxonomy.
  static const String kMigrationDefaultCategoryId = 'inc_cat_self_employment';
  static const String kMigrationDefaultSubcategoryId = 'inc_sub_self_other';

  static const _categories = <({String id, String name, int sortOrder})>[
    (id: 'inc_cat_employment', name: 'Employment (salaried)', sortOrder: 0),
    (id: 'inc_cat_self_employment', name: 'Self-employment & freelance', sortOrder: 1),
    (id: 'inc_cat_investment_passive', name: 'Investment & passive income', sortOrder: 2),
    (id: 'inc_cat_benefits_transfers', name: 'Benefits, subsidies & transfers', sortOrder: 3),
    (id: 'inc_cat_refunds_reversals', name: 'Refunds & reversals', sortOrder: 4),
    (id: 'inc_cat_miscellaneous', name: 'Miscellaneous income', sortOrder: 5),
  ];

  static List<
      ({
        String id,
        String name,
        String slug,
        int sortOrder,
        bool isSystemReserved,
      })> _subsForCategory(String categoryId) {
    return switch (categoryId) {
      'inc_cat_employment' => [
          (
            id: 'inc_sub_emp_salary',
            name: 'Scheduled salary / wage',
            slug: 'inc_emp_salary',
            sortOrder: 0,
            isSystemReserved: false,
          ),
          (
            id: 'inc_sub_emp_bonus',
            name: 'Bonus & commission',
            slug: 'inc_emp_bonus',
            sortOrder: 1,
            isSystemReserved: false,
          ),
          (
            id: 'inc_sub_emp_equity',
            name: 'Equity compensation (RSU, options)',
            slug: 'inc_emp_equity',
            sortOrder: 2,
            isSystemReserved: false,
          ),
          (
            id: 'inc_sub_emp_allowance',
            name: 'Allowances & stipends',
            slug: 'inc_emp_allowance',
            sortOrder: 3,
            isSystemReserved: false,
          ),
          (
            id: 'inc_sub_emp_severance',
            name: 'Severance & settlements',
            slug: 'inc_emp_severance',
            sortOrder: 4,
            isSystemReserved: false,
          ),
          (
            id: 'inc_sub_emp_reimbursement',
            name: 'Employer reimbursements (income)',
            slug: 'inc_emp_reimbursement',
            sortOrder: 5,
            isSystemReserved: false,
          ),
          _otherSubRow('inc_cat_employment', 'inc_sub_emp_other'),
        ],
      'inc_cat_self_employment' => [
          (
            id: 'inc_sub_self_scheduled',
            name: 'Recurring client / retainer',
            slug: 'inc_self_scheduled',
            sortOrder: 0,
            isSystemReserved: false,
          ),
          (
            id: 'inc_sub_self_project',
            name: 'One-off project or invoice',
            slug: 'inc_self_project',
            sortOrder: 1,
            isSystemReserved: false,
          ),
          (
            id: 'inc_sub_self_platform',
            name: 'Platform payouts (marketplace, gig)',
            slug: 'inc_self_platform',
            sortOrder: 2,
            isSystemReserved: false,
          ),
          (
            id: 'inc_sub_self_licensing',
            name: 'Royalties & licensing (your work)',
            slug: 'inc_self_licensing',
            sortOrder: 3,
            isSystemReserved: false,
          ),
          (
            id: 'inc_sub_self_consulting',
            name: 'Consulting & professional fees',
            slug: 'inc_self_consulting',
            sortOrder: 4,
            isSystemReserved: false,
          ),
          _otherSubRow('inc_cat_self_employment', 'inc_sub_self_other'),
        ],
      'inc_cat_investment_passive' => [
          (
            id: 'inc_sub_inv_dividends',
            name: 'Dividends',
            slug: 'inc_inv_dividends',
            sortOrder: 0,
            isSystemReserved: false,
          ),
          (
            id: 'inc_sub_inv_interest',
            name: 'Interest income',
            slug: 'inc_inv_interest',
            sortOrder: 1,
            isSystemReserved: false,
          ),
          (
            id: 'inc_sub_inv_rental',
            name: 'Rental income',
            slug: 'inc_inv_rental',
            sortOrder: 2,
            isSystemReserved: false,
          ),
          (
            id: 'inc_sub_inv_capital',
            name: 'Capital gains (cash received)',
            slug: 'inc_inv_capital',
            sortOrder: 3,
            isSystemReserved: false,
          ),
          (
            id: 'inc_sub_inv_return_principal',
            name: 'Return of principal',
            slug: 'inc_inv_return_principal',
            sortOrder: 4,
            isSystemReserved: false,
          ),
          _otherSubRow('inc_cat_investment_passive', 'inc_sub_inv_other'),
        ],
      'inc_cat_benefits_transfers' => [
          (
            id: 'inc_sub_ben_pension',
            name: 'Pension / retirement distribution',
            slug: 'inc_ben_pension',
            sortOrder: 0,
            isSystemReserved: false,
          ),
          (
            id: 'inc_sub_ben_government',
            name: 'Government benefit / subsidy',
            slug: 'inc_ben_government',
            sortOrder: 1,
            isSystemReserved: false,
          ),
          (
            id: 'inc_sub_ben_family',
            name: 'Family support & gifts received',
            slug: 'inc_ben_family',
            sortOrder: 2,
            isSystemReserved: false,
          ),
          (
            id: 'inc_sub_ben_insurance',
            name: 'Insurance payout',
            slug: 'inc_ben_insurance',
            sortOrder: 3,
            isSystemReserved: false,
          ),
          (
            id: 'inc_sub_ben_prize',
            name: 'Prizes & awards',
            slug: 'inc_ben_prize',
            sortOrder: 4,
            isSystemReserved: false,
          ),
          _otherSubRow('inc_cat_benefits_transfers', 'inc_sub_ben_other'),
        ],
      'inc_cat_refunds_reversals' => [
          (
            id: 'inc_sub_ref_purchase',
            name: 'Purchase refund',
            slug: 'inc_ref_purchase',
            sortOrder: 0,
            isSystemReserved: false,
          ),
          (
            id: 'inc_sub_ref_chargeback',
            name: 'Chargeback / dispute credit',
            slug: 'inc_ref_chargeback',
            sortOrder: 1,
            isSystemReserved: false,
          ),
          (
            id: 'inc_sub_ref_tax',
            name: 'Tax refund',
            slug: 'inc_ref_tax',
            sortOrder: 2,
            isSystemReserved: false,
          ),
          (
            id: 'inc_sub_ref_fee',
            name: 'Fee reversal',
            slug: 'inc_ref_fee',
            sortOrder: 3,
            isSystemReserved: false,
          ),
          _otherSubRow('inc_cat_refunds_reversals', 'inc_sub_ref_other'),
        ],
      'inc_cat_miscellaneous' => [
          (
            id: 'inc_sub_misc_general',
            name: 'General miscellaneous',
            slug: 'inc_misc_general',
            sortOrder: 0,
            isSystemReserved: false,
          ),
          _otherSubRow('inc_cat_miscellaneous', 'inc_sub_misc_other'),
        ],
      _ => [_otherSubRow(categoryId, '${categoryId}_other')],
    };
  }

  static ({
    String id,
    String name,
    String slug,
    int sortOrder,
    bool isSystemReserved,
  }) _otherSubRow(String categoryId, String subId) {
    return (
      id: subId,
      name: 'Other',
      slug: kOtherSubcategorySlug,
      sortOrder: 999,
      isSystemReserved: true,
    );
  }

  /// Canonical built-in taxonomy for backup sanitize / import (matches DB seed).
  static List<IncomeCategory> builtInIncomeCategories() {
    return [
      for (final c in _categories)
        IncomeCategory(id: c.id, name: c.name, sortOrder: c.sortOrder),
    ];
  }

  /// Canonical built-in subcategories (includes **Other** per category).
  static List<IncomeSubcategory> builtInIncomeSubcategories() {
    final out = <IncomeSubcategory>[];
    for (final c in _categories) {
      for (final s in _subsForCategory(c.id)) {
        out.add(
          IncomeSubcategory(
            id: s.id,
            categoryId: c.id,
            name: s.name,
            description: null,
            slug: s.slug,
            isSystemReserved: s.isSystemReserved,
            sortOrder: s.sortOrder,
          ),
        );
      }
    }
    return out;
  }

  static Future<void> ensureSeedData(AppDatabase db) async {
    final existing = await (db.select(db.incomeCategories)..limit(1)).get();
    if (existing.isNotEmpty) {
      return;
    }

    await db.batch((b) {
      for (final c in _categories) {
        b.insert(
          db.incomeCategories,
          IncomeCategoriesCompanion.insert(
            id: c.id,
            name: c.name,
            sortOrder: Value(c.sortOrder),
          ),
        );
      }
      for (final c in _categories) {
        for (final s in _subsForCategory(c.id)) {
          b.insert(
            db.incomeSubcategories,
            IncomeSubcategoriesCompanion.insert(
              id: s.id,
              categoryId: c.id,
              name: s.name,
              slug: s.slug,
              isSystemReserved: Value(s.isSystemReserved),
              sortOrder: Value(s.sortOrder),
            ),
          );
        }
      }
    });
  }
}
