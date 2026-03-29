// DEMO_ONLY — paired with [example_expenses_seed.dart] for coherent 2025 demo data.

import 'package:drift/drift.dart';

import 'package:expense_app/data/local/app_database.dart';
import 'package:expense_app/data/local/drift_recurring_income_series_repository.dart';
import 'package:expense_app/data/local/example_expenses_seed.dart';
import 'package:expense_app/domain/domain.dart';

const double _fxArsToUsd = 0.001;
const double _fxUsd = 1.0;
const double _fxEurToUsd = 1.08;

const String _demoSalarySeriesId = 'inc_demo_series_salary';

/// Clears prior demo income rows and series, inserts sporadic income + a 12-month
/// salary series (materialized as of mid-2025; Jan–Sep paychecks marked received).
Future<void> populateExampleIncomes(AppDatabase db) async {
  await db.transaction(() async {
    await db.customStatement(
      "DELETE FROM income_entries WHERE id LIKE 'inc_demo%' "
      "OR id LIKE 'sir_inc_demo%' "
      "OR recurring_series_id LIKE 'inc_demo%'",
    );
    await db.customStatement(
      "DELETE FROM income_recurring_series WHERE id LIKE 'inc_demo%'",
    );
    for (final row in _standaloneRows()) {
      await db.into(db.incomeEntries).insert(row);
    }
  });

  final recurringRepo = DriftRecurringIncomeSeriesRepository(db);
  final salaryUsd = 1_250_000 * _fxArsToUsd;
  final series = IncomeRecurringSeries(
    id: _demoSalarySeriesId,
    anchorReceivedOn: DateTime(kExampleDemoExpenseYear, 1, 10),
    rule: const RecurrenceMonthlyByCalendarDay(calendarDay: 10),
    endCondition: const RecurrenceEndNever(),
    horizonMonths: 12,
    active: true,
    incomeCategoryId: 'inc_cat_employment',
    incomeSubcategoryId: 'inc_sub_emp_salary',
    amountOriginal: 1_250_000,
    currencyCode: 'ARS',
    manualFxRateToUsd: _fxArsToUsd,
    amountUsd: salaryUsd,
    description: 'Employment contract — monthly salary (demo)',
  );
  await recurringRepo.upsertAndRematerialize(
    series,
    DateTime(kExampleDemoExpenseYear, 10, 1),
  );
}

List<IncomeEntriesCompanion> _standaloneRows() {
  final y = kExampleDemoExpenseYear;
  IncomeEntriesCompanion row(
    String id,
    int month,
    int day,
    String categoryId,
    String subId,
    double amountOriginal,
    String currency,
    double fx,
    String description,
  ) {
    final usd = amountOriginal * fx;
    return IncomeEntriesCompanion.insert(
      id: id,
      receivedOn: ExpenseDates.toStorageDate(DateTime(y, month, day)),
      incomeCategoryId: categoryId,
      incomeSubcategoryId: subId,
      amountOriginal: amountOriginal,
      currencyCode: Value(currency),
      manualFxRateToUsd: Value(fx),
      amountUsd: usd,
      description: Value(description),
    );
  }

  return [
    row(
      'inc_demo_001',
      2,
      14,
      'inc_cat_employment',
      'inc_sub_emp_bonus',
      180_000,
      'ARS',
      _fxArsToUsd,
      'Q1 performance bonus',
    ),
    row(
      'inc_demo_002',
      4,
      22,
      'inc_cat_self_employment',
      'inc_sub_self_project',
      340_000,
      'ARS',
      _fxArsToUsd,
      'Freelance project — invoice paid',
    ),
    row(
      'inc_demo_003',
      5,
      18,
      'inc_cat_investment_passive',
      'inc_sub_inv_dividends',
      95_000,
      'ARS',
      _fxArsToUsd,
      'Dividend distribution',
    ),
    row(
      'inc_demo_004',
      7,
      8,
      'inc_cat_employment',
      'inc_sub_emp_bonus',
      220_000,
      'ARS',
      _fxArsToUsd,
      'Mid-year bonus',
    ),
    row(
      'inc_demo_005',
      8,
      5,
      'inc_cat_investment_passive',
      'inc_sub_inv_interest',
      42_000,
      'ARS',
      _fxArsToUsd,
      'Savings interest credit',
    ),
    row(
      'inc_demo_006',
      9,
      12,
      'inc_cat_refunds_reversals',
      'inc_sub_ref_tax',
      115_000,
      'ARS',
      _fxArsToUsd,
      'Annual tax refund (estimate)',
    ),
    row(
      'inc_demo_007',
      11,
      3,
      'inc_cat_self_employment',
      'inc_sub_self_platform',
      185_000,
      'ARS',
      _fxArsToUsd,
      'Platform payout — side gig',
    ),
    row(
      'inc_demo_008',
      12,
      20,
      'inc_cat_benefits_transfers',
      'inc_sub_ben_family',
      350,
      'EUR',
      _fxEurToUsd,
      'Holiday gift (family)',
    ),
    row(
      'inc_demo_009',
      6,
      28,
      'inc_cat_miscellaneous',
      'inc_sub_misc_general',
      120,
      'USD',
      _fxUsd,
      'Cashback / promo credit',
    ),
  ];
}
