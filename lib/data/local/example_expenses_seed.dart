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

int _dim(int month) => DateTime(kExampleDemoExpenseYear, month + 1, 0).day;

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
    final id = 'exp_demo_${seq.toString().padLeft(4, '0')}';
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
    final last = _dim(m);

    add(
      m,
      3,
      'cat_fixed_expenses',
      'cat_fixed_expenses_rent',
      520000 + m * 2000,
      'ARS',
      _fxArsToUsd,
      false,
      'Monthly rent',
    );

    add(
      m,
      5,
      'cat_fixed_expenses',
      'cat_fixed_expenses_cellphone',
      18900 + m * 350,
      'ARS',
      _fxArsToUsd,
      true,
      'Mobile plan',
    );

    for (final d in [6, 13, 20, 27]) {
      if (d <= last) {
        add(
          m,
          d,
          'cat_fixed_expenses',
          'cat_fixed_expenses_groceries',
          38000 + (m + d) * 420 + (d % 4) * 1800,
          'ARS',
          _fxArsToUsd,
          false,
          'Supermarket run',
        );
      }
    }

    add(
      m,
      14,
      'cat_fixed_expenses',
      'cat_fixed_expenses_electricity',
      21500 + (m % 4) * 2200,
      'ARS',
      _fxArsToUsd,
      false,
      'Electricity',
    );

    if (m != 8) {
      add(
        m,
        11,
        'cat_fixed_expenses',
        'cat_fixed_expenses_internet_tv',
        14200 + m * 90,
        'ARS',
        _fxArsToUsd,
        true,
        'Internet & TV',
      );
    }

    if (m % 2 == 1) {
      final w = m == 1 ? 28 : 16;
      if (w <= last) {
        add(
          m,
          w,
          'cat_fixed_expenses',
          'cat_fixed_expenses_water',
          9200 + m * 200,
          'ARS',
          _fxArsToUsd,
          false,
          'Water utility',
        );
      }
    }

    if (m >= 5 && m <= 9) {
      add(
        m,
        18,
        'cat_fixed_expenses',
        'cat_fixed_expenses_gas',
        11000 + (9 - m).abs() * 800,
        'ARS',
        _fxArsToUsd,
        false,
        'Natural gas (winter)',
      );
    }

    if (m % 3 == 0) {
      add(
        m,
        22,
        'cat_fixed_expenses',
        'cat_fixed_expenses_hoa',
        28500,
        'ARS',
        _fxArsToUsd,
        false,
        'Building & HOA fees',
      );
    }

    add(
      m,
      4,
      'cat_subscriptions_digital',
      'cat_subscriptions_digital_streaming',
      5200 + (m % 3) * 400,
      'ARS',
      _fxArsToUsd,
      true,
      'Streaming (video)',
    );
    add(
      m,
      7,
      'cat_subscriptions_digital',
      'cat_subscriptions_digital_music',
      3299,
      'ARS',
      _fxArsToUsd,
      true,
      'Music & podcasts',
    );
    add(
      m,
      8,
      'cat_subscriptions_digital',
      'cat_subscriptions_digital_cloud',
      4100 + m * 50,
      'ARS',
      _fxArsToUsd,
      true,
      'Cloud storage',
    );
    if (m % 2 == 0) {
      add(
        m,
        9,
        'cat_subscriptions_digital',
        'cat_subscriptions_digital_software',
        11500 + m * 200,
        'ARS',
        _fxArsToUsd,
        true,
        'Productivity software',
      );
    }
    if (m % 4 == 0) {
      add(
        m,
        10,
        'cat_subscriptions_digital',
        'cat_subscriptions_digital_gaming',
        4500,
        'ARS',
        _fxArsToUsd,
        true,
        'Online gaming pass',
      );
    }
    if (m == 6 || m == 12) {
      add(
        m,
        12,
        'cat_subscriptions_digital',
        'cat_subscriptions_digital_news',
        2500,
        'ARS',
        _fxArsToUsd,
        true,
        'Digital news',
      );
    }

    for (final d in [2, 4, 8, 10, 15, 17, 21, 24, 26]) {
      if (d <= last) {
        add(
          m,
          d,
          'cat_delivery_convenience',
          'cat_delivery_convenience_meal_delivery',
          11200 + (m + d) * 180 + (d % 5) * 900,
          'ARS',
          _fxArsToUsd,
          true,
          'Meal delivery',
        );
      }
    }

    for (final d in [9, 23]) {
      if (d <= last) {
        add(
          m,
          d,
          'cat_delivery_convenience',
          'cat_delivery_convenience_grocery_quick',
          6200 + m * 250,
          'ARS',
          _fxArsToUsd,
          true,
          'Quick commerce / market delivery',
        );
      }
    }

    add(
      m,
      last >= 19 ? 19 : last,
      'cat_delivery_convenience',
      'cat_delivery_convenience_courier',
      4200 + m * 120,
      'ARS',
      _fxArsToUsd,
      true,
      'Courier / errands',
    );

    if (m % 2 == 0) {
      final d = 16 <= last ? 16 : last;
      add(
        m,
        d,
        'cat_delivery_convenience',
        'cat_delivery_convenience_laundry',
        9800,
        'ARS',
        _fxArsToUsd,
        false,
        'Laundry & dry cleaning',
      );
    }

    add(
      m,
      1,
      'cat_transport',
      'cat_transport_public',
      16800 + m * 450,
      'ARS',
      _fxArsToUsd,
      false,
      'Transit pass / SUBE',
    );

    for (final d in [3, 6, 11, 14, 18, 22, 25, 28]) {
      if (d <= last) {
        add(
          m,
          d,
          'cat_transport',
          'cat_transport_rideshare',
          4800 + m * 40 + (d % 6) * 350,
          'ARS',
          _fxArsToUsd,
          true,
          'Rideshare / taxi',
        );
      }
    }

    for (final d in [7, 21]) {
      if (d <= last && m != 8) {
        add(
          m,
          d,
          'cat_transport',
          'cat_transport_fuel',
          31000 + m * 700,
          'ARS',
          _fxArsToUsd,
          true,
          'Fuel',
        );
      }
    }

    if (m % 3 == 0) {
      add(
        m,
        12,
        'cat_transport',
        'cat_transport_parking',
        4500,
        'ARS',
        _fxArsToUsd,
        true,
        'Parking',
      );
    }

    add(
      m,
      13,
      'cat_pets',
      'cat_pets_food',
      26500 + m * 500,
      'ARS',
      _fxArsToUsd,
      false,
      'Pet food & litter',
    );

    if (m == 3) {
      add(
        3,
        25,
        'cat_pets',
        'cat_pets_vet',
        195000,
        'ARS',
        _fxArsToUsd,
        true,
        'Vet — annual checkup & vaccines',
      );
    }
    if (m == 9) {
      add(
        9,
        16,
        'cat_pets',
        'cat_pets_vet',
        52000,
        'ARS',
        _fxArsToUsd,
        true,
        'Vet — follow-up',
      );
    }

    if (m % 3 == 0) {
      add(
        m,
        11,
        'cat_pets',
        'cat_pets_grooming',
        13500 + m * 400,
        'ARS',
        _fxArsToUsd,
        true,
        'Pet grooming',
      );
    }

    if (m % 4 == 0) {
      add(
        m,
        20,
        'cat_pets',
        'cat_pets_toys',
        16800,
        'ARS',
        _fxArsToUsd,
        true,
        'Toys & accessories',
      );
    }

    if (m == 6) {
      add(
        6,
        29,
        'cat_pets',
        'cat_pets_insurance',
        8900,
        'ARS',
        _fxArsToUsd,
        true,
        'Pet liability add-on',
      );
    }

    for (final d in [7, 14, 21]) {
      if (d <= last) {
        add(
          m,
          d,
          'cat_leisure',
          'cat_leisure_dining',
          32000 + d * 900 + m * 200,
          'ARS',
          _fxArsToUsd,
          true,
          'Dining out',
        );
      }
    }

    if (m % 2 == 1) {
      final d = 19 <= last ? 19 : last;
      add(
        m,
        d,
        'cat_leisure',
        'cat_leisure_entertainment',
        18500 + m * 300,
        'ARS',
        _fxArsToUsd,
        true,
        'Cinema / events',
      );
    }

    if (m % 3 == 0) {
      add(
        m,
        15,
        'cat_health',
        'cat_health_personal_care',
        12000,
        'ARS',
        _fxArsToUsd,
        false,
        'Personal care',
      );
    }

    add(
      m,
      17,
      'cat_health',
      'cat_health_pharmacy',
      6500 + (m % 5) * 1800,
      'ARS',
      _fxArsToUsd,
      m.isEven,
      'Pharmacy',
    );
  }

  add(3, 7, 'cat_health', 'cat_health_gym', 36999, 'ARS', _fxArsToUsd, true, 'Gym membership');
  add(9, 7, 'cat_health', 'cat_health_gym', 38999, 'ARS', _fxArsToUsd, true, 'Gym renewal');

  add(4, 8, 'cat_taxes', 'cat_taxes_national', 98000, 'ARS', _fxArsToUsd, false, 'National tax installment');
  add(8, 10, 'cat_taxes', 'cat_taxes_provincial', 44500, 'ARS', _fxArsToUsd, false, 'Provincial & municipal');
  add(11, 5, 'cat_taxes', 'cat_taxes_vehicle', 32000, 'ARS', _fxArsToUsd, false, 'Vehicle registration');

  add(5, 22, 'cat_leisure', 'cat_leisure_travel', 198000, 'ARS', _fxArsToUsd, true, 'Long weekend — domestic flights');

  add(6, 2, 'cat_leisure', 'cat_leisure_travel', 1180, 'EUR', _fxEurToUsd, true, 'International flight');
  add(6, 3, 'cat_leisure', 'cat_leisure_travel', 940, 'EUR', _fxEurToUsd, true, 'Hotel — four nights');
  add(6, 5, 'cat_leisure', 'cat_leisure_dining', 185, 'EUR', _fxEurToUsd, false, 'Restaurants on trip');
  add(6, 6, 'cat_transport', 'cat_transport_public', 45, 'EUR', _fxEurToUsd, false, 'Local transit');
  add(6, 8, 'cat_transport', 'cat_transport_rideshare', 32, 'EUR', _fxEurToUsd, true, 'Airport rideshare');
  add(6, 14, 'cat_leisure', 'cat_leisure_entertainment', 62, 'EUR', _fxEurToUsd, true, 'Museums');
  add(6, 18, 'cat_fixed_expenses', 'cat_fixed_expenses_cellphone', 25, 'USD', _fxUsd, true, 'Travel eSIM top-up');

  add(7, 11, 'cat_housing', 'cat_housing_repairs', 132000, 'ARS', _fxArsToUsd, false, 'AC service & minor repair');

  add(10, 6, 'cat_formation', 'cat_formation_courses', 92000, 'ARS', _fxArsToUsd, true, 'Online certification');

  add(11, 14, 'cat_investments', 'cat_investments_funds', 265000, 'ARS', _fxArsToUsd, true, 'Fund contribution');

  add(2, 25, 'cat_health', 'cat_health_pharmacy', 13200, 'ARS', _fxArsToUsd, false, 'Pharmacy');
  add(10, 19, 'cat_health', 'cat_health_pharmacy', 20100, 'ARS', _fxArsToUsd, true, 'Pharmacy — card');

  add(1, 10, 'cat_formation', 'cat_formation_books', 18500, 'ARS', _fxArsToUsd, true, 'Technical books');

  add(4, 14, 'cat_transport', 'cat_transport_maintenance', 78000, 'ARS', _fxArsToUsd, true, 'Vehicle service');

  add(12, 20, 'cat_leisure', 'cat_leisure_travel', 695, 'EUR', _fxEurToUsd, true, 'Regional flight');
  add(12, 22, 'cat_leisure', 'cat_leisure_dining', 198, 'EUR', _fxEurToUsd, false, 'Holiday dinner');
  add(12, 24, 'cat_housing', 'cat_housing_decoration', 145, 'USD', _fxUsd, true, 'Decor — USD');
  add(12, 26, 'cat_leisure', 'cat_leisure_travel', 445000, 'ARS', _fxArsToUsd, false, 'Intercity travel');
  add(12, 28, 'cat_health', 'cat_health_pharmacy', 58, 'USD', _fxUsd, true, 'Travel health supplies');

  add(8, 8, 'cat_leisure', 'cat_leisure_dining', 72000, 'ARS', _fxArsToUsd, true, 'Dining while on leave');

  add(3, 22, 'cat_leisure', 'cat_leisure_hobbies', 24000, 'ARS', _fxArsToUsd, true, 'Hobby supplies');

  add(5, 8, 'cat_investments', 'cat_investments_brokerage', 150000, 'ARS', _fxArsToUsd, true, 'Brokerage contribution');

  return out;
}
