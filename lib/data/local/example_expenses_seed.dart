// DEMO_ONLY — Remove this file, Settings actions, and tests when demo data is no
// longer needed. Config: change [kExampleDemoExpenseYear] or row builders below.

import 'package:drift/drift.dart';

import 'package:expense_app/data/local/app_database.dart';
import 'package:expense_app/domain/domain.dart';

/// Calendar year used for all demo expense dates (stable for tests and reports).
const int kExampleDemoExpenseYear = 2025;

const double _fxArsToUsd = 0.001;
const double _fxUsd = 1.0;
const double _fxEurToUsd = 1.08;

/// Replaces any previous demo rows (`id` LIKE `exp_demo%`) and inserts fresh data.
/// Does not modify categories. Requires taxonomy seed present (valid subcategory ids).
Future<void> populateExampleExpenses(AppDatabase db) async {
  await db.transaction(() async {
    await db.customStatement("DELETE FROM expenses WHERE id LIKE 'exp_demo%'");
    for (final companion in _buildExampleExpenseRows()) {
      await db.into(db.expenses).insert(companion);
    }
  });
  await syncDemoExpectationsWithLocalToday(db);
}

/// Marks demo income/expense rows on or before local today as confirmed paid/received.
/// Idempotent; run after demo inserts so materialized series and rows stay consistent.
Future<void> syncDemoExpectationsWithLocalToday(AppDatabase db) async {
  final todayIso = ExpenseDates.toStorageDate(calendarTodayLocal());
  final confirmed = PaymentExpectationStatus.confirmedPaid.storageName;
  try {
    await db.customStatement(
      'UPDATE expenses SET payment_expectation_status = \'$confirmed\', '
      'payment_expectation_confirmed_on = occurred_on '
      'WHERE id LIKE \'exp_demo%\' AND occurred_on <= \'$todayIso\'',
    );
    await db.customStatement(
      'UPDATE income_entries SET expectation_status = \'$confirmed\', '
      'expectation_confirmed_on = received_on '
      'WHERE (id LIKE \'inc_demo%\' OR id LIKE \'sir_inc_demo%\') '
      'AND received_on <= \'$todayIso\'',
    );
  } catch (e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('no such table') || msg.contains('no such column')) {
      return;
    }
    rethrow;
  }
}

List<ExpensesCompanion> _buildExampleExpenseRows() {
  final out = <ExpensesCompanion>[];
  var seq = 0;

  void add(
    int month,
    int day,
    String categoryId,
    String subcategoryId,
    double amountOriginal,
    String currencyCode,
    double manualFxRateToUsd,
    bool paidWithCreditCard,
    String description,
  ) {
    seq++;
    final id = 'exp_demo_${seq.toString().padLeft(3, '0')}';
    final usd = amountOriginal * manualFxRateToUsd;
    final rowDate = DateTime(kExampleDemoExpenseYear, month, day);
    final today = calendarTodayLocal();
    final settled =
        !calendarDateOnly(rowDate).isAfter(calendarDateOnly(today));
    out.add(
      ExpensesCompanion.insert(
        id: id,
        occurredOn: ExpenseDates.toStorageDate(rowDate),
        categoryId: categoryId,
        subcategoryId: subcategoryId,
        amountOriginal: amountOriginal,
        currencyCode: Value(currencyCode),
        manualFxRateToUsd: Value(manualFxRateToUsd),
        amountUsd: usd,
        paidWithCreditCard: Value(paidWithCreditCard),
        description: Value(description),
        paymentExpectationStatus: Value(
          settled
              ? PaymentExpectationStatus.confirmedPaid.storageName
              : PaymentExpectationStatus.expected.storageName,
        ),
        paymentExpectationConfirmedOn: settled
            ? Value(ExpenseDates.toStorageDate(calendarDateOnly(rowDate)))
            : const Value.absent(),
      ),
    );
  }

  for (var m = 1; m <= 12; m++) {
    add(
      m,
      3,
      'cat_fixed_expenses',
      'cat_fixed_expenses_rent',
      450000 + m * 1500,
      'ARS',
      _fxArsToUsd,
      false,
      'Monthly rent',
    );
    add(
      m,
      9,
      'cat_fixed_expenses',
      'cat_fixed_expenses_groceries',
      140000 + m * 2200,
      'ARS',
      _fxArsToUsd,
      false,
      'Groceries & supermarket',
    );
    add(
      m,
      20,
      'cat_fixed_expenses',
      'cat_fixed_expenses_subscriptions',
      8999 + m * 50,
      'ARS',
      _fxArsToUsd,
      true,
      'Apps & cloud subscriptions',
    );
  }

  for (final m in [1, 3, 5, 7, 9, 11]) {
    add(
      m,
      15,
      'cat_fixed_expenses',
      'cat_fixed_expenses_electricity',
      18000 + m * 400,
      'ARS',
      _fxArsToUsd,
      false,
      'Electricity bill',
    );
  }

  for (var m = 1; m <= 12; m++) {
    if (m == 8) {
      continue;
    }
    add(
      m,
      12,
      'cat_fixed_expenses',
      'cat_fixed_expenses_internet_tv',
      12999 + m * 100,
      'ARS',
      _fxArsToUsd,
      true,
      'Internet & TV',
    );
  }

  for (final m in [1, 2, 3, 4, 10, 11]) {
    add(
      m,
      18,
      'cat_transport',
      'cat_transport_fuel',
      28000 + m * 800,
      'ARS',
      _fxArsToUsd,
      true,
      'Fuel',
    );
  }

  add(4, 8, 'cat_taxes', 'cat_taxes_national', 95000, 'ARS', _fxArsToUsd, false, 'National tax installment');
  add(8, 10, 'cat_taxes', 'cat_taxes_provincial', 42000, 'ARS', _fxArsToUsd, false, 'Provincial fees');

  add(3, 7, 'cat_health', 'cat_health_gym', 35999, 'ARS', _fxArsToUsd, true, 'Gym membership');
  add(9, 7, 'cat_health', 'cat_health_gym', 37999, 'ARS', _fxArsToUsd, true, 'Gym membership renewal');

  add(5, 22, 'cat_leisure', 'cat_leisure_travel', 185000, 'ARS', _fxArsToUsd, true, 'Long weekend — domestic flights');

  add(6, 2, 'cat_leisure', 'cat_leisure_travel', 1180, 'EUR', _fxEurToUsd, true, 'International flight (summer trip)');
  add(6, 3, 'cat_leisure', 'cat_leisure_travel', 920, 'EUR', _fxEurToUsd, true, 'Hotel — four nights abroad');
  add(6, 5, 'cat_leisure', 'cat_leisure_dining', 185, 'EUR', _fxEurToUsd, false, 'Restaurants on trip');
  add(6, 6, 'cat_transport', 'cat_transport_public', 45, 'EUR', _fxEurToUsd, false, 'Local transit passes');
  add(6, 14, 'cat_leisure', 'cat_leisure_entertainment', 60, 'EUR', _fxEurToUsd, true, 'Museum entries');
  add(6, 18, 'cat_fixed_expenses', 'cat_fixed_expenses_cellphone', 25, 'USD', _fxUsd, true, 'Travel eSIM top-up');

  add(7, 11, 'cat_housing', 'cat_housing_repairs', 125000, 'ARS', _fxArsToUsd, false, 'AC service & minor repair');

  add(10, 6, 'cat_formation', 'cat_formation_courses', 89000, 'ARS', _fxArsToUsd, true, 'Online certification course');

  add(11, 14, 'cat_investments', 'cat_investments_funds', 250000, 'ARS', _fxArsToUsd, true, 'Fund contribution');

  add(2, 25, 'cat_health', 'cat_health_pharmacy', 12450, 'ARS', _fxArsToUsd, false, 'Pharmacy');
  add(10, 19, 'cat_health', 'cat_health_pharmacy', 18900, 'ARS', _fxArsToUsd, true, 'Pharmacy — card');

  add(12, 20, 'cat_leisure', 'cat_leisure_travel', 680, 'EUR', _fxEurToUsd, true, 'Year-end regional flight');
  add(12, 22, 'cat_leisure', 'cat_leisure_dining', 195, 'EUR', _fxEurToUsd, false, 'Holiday dinner (EUR)');
  add(12, 24, 'cat_housing', 'cat_housing_decoration', 140, 'USD', _fxUsd, true, 'Decor gifts — USD store');
  add(12, 26, 'cat_leisure', 'cat_leisure_travel', 420000, 'ARS', _fxArsToUsd, false, 'Intercity bus — family visit');
  add(12, 28, 'cat_health', 'cat_health_pharmacy', 55, 'USD', _fxUsd, true, 'Travel health supplies (USD)');

  add(1, 28, 'cat_fixed_expenses', 'cat_fixed_expenses_water', 8900, 'ARS', _fxArsToUsd, false, 'Water utility');
  add(8, 8, 'cat_leisure', 'cat_leisure_dining', 67000, 'ARS', _fxArsToUsd, true, 'Dining while on leave');

  return out;
}
