import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'package:expense_app/data/local/category_seed.dart';
import 'package:expense_app/data/local/income_category_seed.dart';
import 'package:expense_app/domain/expense.dart';
import 'package:expense_app/domain/expense_inclusion.dart';
import 'package:expense_app/domain/payment_expectation_status.dart';

part 'app_database.g.dart';

@DataClassName('CategoryRow')
class Categories extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  TextColumn get description => text().nullable()();

  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('SubcategoryRow')
class Subcategories extends Table {
  TextColumn get id => text()();

  TextColumn get categoryId => text().references(
        Categories,
        #id,
        onDelete: KeyAction.cascade,
      )();

  TextColumn get name => text()();

  TextColumn get description => text().nullable()();

  TextColumn get slug => text()();

  BoolColumn get isSystemReserved => boolean().withDefault(const Constant(false))();

  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('IncomeCategoryRow')
class IncomeCategories extends Table {
  @override
  String get tableName => 'income_categories';

  TextColumn get id => text()();

  TextColumn get name => text()();

  TextColumn get description => text().nullable()();

  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('IncomeSubcategoryRow')
class IncomeSubcategories extends Table {
  @override
  String get tableName => 'income_subcategories';

  TextColumn get id => text()();

  TextColumn get categoryId => text().references(
        IncomeCategories,
        #id,
        onDelete: KeyAction.cascade,
      )();

  TextColumn get name => text()();

  TextColumn get description => text().nullable()();

  TextColumn get slug => text()();

  BoolColumn get isSystemReserved => boolean().withDefault(const Constant(false))();

  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Card / wallet profile for attribution only (no PAN, CVV, PIN).
@DataClassName('PaymentInstrumentRow')
class PaymentInstruments extends Table {
  TextColumn get id => text()();

  TextColumn get label => text()();

  TextColumn get bankName => text().nullable()();

  IntColumn get billingCycleDay => integer().nullable()();

  RealColumn get annualFeeAmount => real().nullable()();

  RealColumn get monthlyFeeAmount => real().nullable()();

  TextColumn get feeDescription => text().withDefault(const Constant(''))();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();

  IntColumn get statementClosingDay => integer().nullable()();

  IntColumn get paymentDueDay => integer().nullable()();

  RealColumn get nominalAprPercent => real().nullable()();

  RealColumn get creditLimit => real().nullable()();

  TextColumn get displaySuffix => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('InstallmentPlanRow')
class InstallmentPlans extends Table {
  TextColumn get id => text()();

  IntColumn get paymentCount => integer()();

  IntColumn get intervalMonths => integer().withDefault(const Constant(1))();

  TextColumn get anchorOccurredOn => text()();

  TextColumn get categoryId => text().references(
        Categories,
        #id,
        onDelete: KeyAction.restrict,
      )();

  TextColumn get subcategoryId => text().references(
        Subcategories,
        #id,
        onDelete: KeyAction.restrict,
      )();

  TextColumn get paymentInstrumentId => text().nullable().references(
        PaymentInstruments,
        #id,
        onDelete: KeyAction.setNull,
      )();

  RealColumn get perPaymentAmountOriginal => real()();

  TextColumn get currencyCode => text().withDefault(const Constant('USD'))();

  RealColumn get manualFxRateToUsd => real().withDefault(const Constant(1.0))();

  RealColumn get perPaymentAmountUsd => real()();

  TextColumn get description => text().withDefault(const Constant(''))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('ExpenseRecurringSeriesRow')
class RecExpenseSeries extends Table {
  @override
  String get tableName => 'expense_recurring_series';

  TextColumn get id => text()();

  TextColumn get anchorOccurredOn => text()();

  /// Recurrence payload JSON (application/recurrence_json_codec.dart v1).
  TextColumn get recurrenceJson => text()();

  IntColumn get horizonMonths => integer()();

  BoolColumn get active => boolean().withDefault(const Constant(true))();

  TextColumn get categoryId => text().references(
        Categories,
        #id,
        onDelete: KeyAction.restrict,
      )();

  TextColumn get subcategoryId => text().references(
        Subcategories,
        #id,
        onDelete: KeyAction.restrict,
      )();

  RealColumn get amountOriginal => real()();

  TextColumn get currencyCode => text().withDefault(const Constant('USD'))();

  RealColumn get manualFxRateToUsd => real().withDefault(const Constant(1.0))();

  RealColumn get amountUsd => real()();

  BoolColumn get paidWithCreditCard => boolean().withDefault(const Constant(false))();

  TextColumn get description => text().withDefault(const Constant(''))();

  TextColumn get paymentInstrumentId => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('IncomeRecurringSeriesRow')
class IncomeRecSeries extends Table {
  @override
  String get tableName => 'income_recurring_series';

  TextColumn get id => text()();

  TextColumn get anchorReceivedOn => text()();

  /// Recurrence payload JSON (application/recurrence_json_codec.dart v1).
  TextColumn get recurrenceJson => text()();

  IntColumn get horizonMonths => integer()();

  BoolColumn get active => boolean().withDefault(const Constant(true))();

  TextColumn get incomeCategoryId => text().references(
        IncomeCategories,
        #id,
        onDelete: KeyAction.restrict,
      )();

  TextColumn get incomeSubcategoryId => text().references(
        IncomeSubcategories,
        #id,
        onDelete: KeyAction.restrict,
      )();

  RealColumn get amountOriginal => real()();

  TextColumn get currencyCode => text().withDefault(const Constant('USD'))();

  RealColumn get manualFxRateToUsd => real().withDefault(const Constant(1.0))();

  RealColumn get amountUsd => real()();

  TextColumn get description => text().withDefault(const Constant(''))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('ExpenseRow')
class Expenses extends Table {
  TextColumn get id => text()();

  /// `YYYY-MM-DD` (local calendar date).
  TextColumn get occurredOn => text()();

  TextColumn get categoryId => text().references(
        Categories,
        #id,
        onDelete: KeyAction.restrict,
      )();

  TextColumn get subcategoryId => text().references(
        Subcategories,
        #id,
        onDelete: KeyAction.restrict,
      )();

  RealColumn get amountOriginal => real()();

  TextColumn get currencyCode => text().withDefault(const Constant('USD'))();

  RealColumn get manualFxRateToUsd => real().withDefault(const Constant(1.0))();

  RealColumn get amountUsd => real()();

  BoolColumn get paidWithCreditCard => boolean().withDefault(const Constant(false))();

  TextColumn get description => text().withDefault(const Constant(''))();

  /// Optional card profile id; validated in [DriftExpenseRepository].
  TextColumn get paymentInstrumentId => text().nullable()();

  /// Generated from [RecExpenseSeries] when non-null.
  TextColumn get recurringSeriesId => text().nullable().references(
        RecExpenseSeries,
        #id,
        onDelete: KeyAction.cascade,
      )();

  TextColumn get paymentExpectationStatus => text().nullable()();

  TextColumn get paymentExpectationConfirmedOn => text().nullable()();

  TextColumn get installmentPlanId => text().nullable().references(
        InstallmentPlans,
        #id,
        onDelete: KeyAction.setNull,
      )();

  IntColumn get installmentIndex => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('IncomeEntryRow')
class IncomeEntries extends Table {
  TextColumn get id => text()();

  TextColumn get receivedOn => text()();

  TextColumn get incomeCategoryId => text().references(
        IncomeCategories,
        #id,
        onDelete: KeyAction.restrict,
      )();

  TextColumn get incomeSubcategoryId => text().references(
        IncomeSubcategories,
        #id,
        onDelete: KeyAction.restrict,
      )();

  RealColumn get amountOriginal => real()();

  TextColumn get currencyCode => text().withDefault(const Constant('USD'))();

  RealColumn get manualFxRateToUsd => real().withDefault(const Constant(1.0))();

  RealColumn get amountUsd => real()();

  TextColumn get description => text().withDefault(const Constant(''))();

  TextColumn get recurringSeriesId => text().nullable().references(
        IncomeRecSeries,
        #id,
        onDelete: KeyAction.cascade,
      )();

  TextColumn get expectationStatus => text().nullable()();

  TextColumn get expectationConfirmedOn => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Categories,
    Subcategories,
    IncomeCategories,
    IncomeSubcategories,
    PaymentInstruments,
    InstallmentPlans,
    RecExpenseSeries,
    IncomeRecSeries,
    Expenses,
    IncomeEntries,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  factory AppDatabase.openDefault() {
    return AppDatabase(
      driftDatabase(
        name: 'expense_app',
        web: DriftWebOptions(
          sqlite3Wasm: Uri.parse('sqlite3.wasm'),
          driftWorker: Uri.parse('drift_worker.js'),
        ),
      ),
    );
  }

  @override
  int get schemaVersion => 15;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await CategorySeeder.ensureSeedData(this);
          await IncomeCategorySeeder.ensureSeedData(this);
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.createTable(categories);
            await m.createTable(subcategories);
            await CategorySeeder.ensureSeedData(this);
            await customStatement('DROP TABLE IF EXISTS schema_anchors');
          }
          if (from < 3) {
            await m.createTable(expenses);
          }
          if (from < 5) {
            await ensureExpenseDescriptionColumn();
          }
          if (from < 6) {
            await ensureCategoryAndSubcategoryDescriptionColumns();
          }
          if (from < 7) {
            await m.createTable(paymentInstruments);
          }
          if (from < 8) {
            await m.addColumn(expenses, expenses.paymentInstrumentId);
          }
          if (from < 9) {
            await m.createTable(recExpenseSeries);
            await m.addColumn(expenses, expenses.recurringSeriesId);
            await customStatement(
              'CREATE UNIQUE INDEX IF NOT EXISTS ux_expense_series_occurred '
              'ON expenses (recurring_series_id, occurred_on) '
              'WHERE recurring_series_id IS NOT NULL',
            );
          }
          if (from < 10) {
            await m.addColumn(expenses, expenses.paymentExpectationStatus);
            await m.addColumn(expenses, expenses.paymentExpectationConfirmedOn);
          }
          if (from < 11) {
            await m.createTable(incomeEntries);
          }
          // Note: from 11–13, income_entries referenced expense categories; v14 replaces.
          if (from < 12) {
            await ensurePaymentInstrumentV2Columns();
            await backfillPaymentInstrumentDefaultsIfNeeded();
          }
          if (from < 13) {
            await m.createTable(installmentPlans);
            await m.addColumn(expenses, expenses.installmentPlanId);
            await m.addColumn(expenses, expenses.installmentIndex);
          }
          if (from < 14) {
            await m.createTable(incomeRecSeries);
            await m.createTable(incomeCategories);
            await m.createTable(incomeSubcategories);
            await IncomeCategorySeeder.ensureSeedData(this);
            await migrateIncomeEntriesToIncomeTaxonomyV14(m);
          }
          if (from < 15) {
            if (from >= 14) {
              await m.createTable(incomeRecSeries);
            }
            await m.addColumn(incomeEntries, incomeEntries.recurringSeriesId);
            await m.addColumn(incomeEntries, incomeEntries.expectationStatus);
            await m.addColumn(incomeEntries, incomeEntries.expectationConfirmedOn);
            await ensureIncomeSeriesReceivedUniqueIndex();
          }
        },
        beforeOpen: (OpeningDetails details) async {
          await ensureExpenseDescriptionColumn();
          await ensureCategoryAndSubcategoryDescriptionColumns();
          await ensureExpensePaymentInstrumentIdColumn();
          await ensureExpenseRecurringSeriesIdColumn();
          await ensureExpenseSeriesOccurredUniqueIndex();
          await ensureExpensePaymentExpectationColumns();
          await ensurePaymentInstrumentV2Columns();
          await ensureExpenseInstallmentColumns();
          await backfillPaymentInstrumentDefaultsIfNeeded();
          await ensureIncomeTaxonomyDescriptionColumns();
          await ensureIncomeRecurringSeriesColumns();
          await ensureIncomeSeriesReceivedUniqueIndex();
          await IncomeCategorySeeder.ensureSeedData(this);
        },
      );

  /// Migrates `income_entries` from expense taxonomy FKs to dedicated income taxonomy.
  Future<void> migrateIncomeEntriesToIncomeTaxonomyV14(Migrator m) async {
    final defCat = IncomeCategorySeeder.kMigrationDefaultCategoryId;
    final defSub = IncomeCategorySeeder.kMigrationDefaultSubcategoryId;
    try {
      final rows = await customSelect(
        'SELECT id, received_on, category_id, subcategory_id, amount_original, '
        'currency_code, manual_fx_rate_to_usd, amount_usd, description FROM income_entries',
      ).get();
      await customStatement('DROP TABLE income_entries');
      await m.createTable(incomeEntries);
      for (final row in rows) {
        await into(incomeEntries).insert(
          IncomeEntriesCompanion.insert(
            id: row.read<String>('id'),
            receivedOn: row.read<String>('received_on'),
            incomeCategoryId: defCat,
            incomeSubcategoryId: defSub,
            amountOriginal: row.read<double>('amount_original'),
            currencyCode: Value(row.read<String>('currency_code')),
            manualFxRateToUsd: Value(row.read<double>('manual_fx_rate_to_usd')),
            amountUsd: row.read<double>('amount_usd'),
            description: Value(row.readNullable<String>('description') ?? ''),
          ),
        );
      }
    } catch (e) {
      final msg = e.toString().toLowerCase();
      if (msg.contains('no such table')) {
        await m.createTable(incomeEntries);
        return;
      }
      if (msg.contains('no such column')) {
        try {
          await customStatement('DROP TABLE IF EXISTS income_entries');
        } catch (_) {}
        await m.createTable(incomeEntries);
        return;
      }
      rethrow;
    }
  }

  Future<void> ensureIncomeRecurringSeriesColumns() async {
    const stmts = <String>[
      'ALTER TABLE income_entries ADD COLUMN recurring_series_id TEXT '
          'REFERENCES income_recurring_series (id) ON DELETE CASCADE',
      'ALTER TABLE income_entries ADD COLUMN expectation_status TEXT',
      'ALTER TABLE income_entries ADD COLUMN expectation_confirmed_on TEXT',
    ];
    for (final sql in stmts) {
      try {
        await customStatement(sql);
      } catch (e) {
        final msg = e.toString().toLowerCase();
        if (msg.contains('duplicate column') || msg.contains('already exists')) {
          continue;
        }
        if (msg.contains('no such table')) {
          continue;
        }
        rethrow;
      }
    }
  }

  Future<void> ensureIncomeSeriesReceivedUniqueIndex() async {
    try {
      await customStatement(
        'CREATE UNIQUE INDEX IF NOT EXISTS ux_income_series_received '
        'ON income_entries (recurring_series_id, received_on) '
        'WHERE recurring_series_id IS NOT NULL',
      );
    } catch (e) {
      final msg = e.toString().toLowerCase();
      if (msg.contains('no such column')) {
        return;
      }
      rethrow;
    }
  }

  Future<void> ensureIncomeTaxonomyDescriptionColumns() async {
    const stmts = <String>[
      'ALTER TABLE income_categories ADD COLUMN description TEXT',
      'ALTER TABLE income_subcategories ADD COLUMN description TEXT',
    ];
    for (final sql in stmts) {
      try {
        await customStatement(sql);
      } catch (e) {
        final msg = e.toString().toLowerCase();
        if (msg.contains('duplicate column') || msg.contains('already exists')) {
          continue;
        }
        if (msg.contains('no such table')) {
          continue;
        }
        rethrow;
      }
    }
  }

  /// Ensures [Expenses.description] exists (WASM/web can report schema v4+ without the column).
  /// Safe to call repeatedly: ignores duplicate-column and missing-table errors.
  Future<void> ensureExpenseDescriptionColumn() async {
    try {
      await customStatement(
        "ALTER TABLE expenses ADD COLUMN description TEXT NOT NULL DEFAULT ''",
      );
    } catch (e) {
      final msg = e.toString().toLowerCase();
      if (msg.contains('duplicate column') ||
          msg.contains('already exists')) {
        return;
      }
      if (msg.contains('no such table')) {
        return;
      }
      rethrow;
    }
  }

  /// Ensures nullable taxonomy description columns (upgrades + WASM quirks).
  Future<void> ensureExpensePaymentInstrumentIdColumn() async {
    try {
      await customStatement(
        'ALTER TABLE expenses ADD COLUMN payment_instrument_id TEXT',
      );
    } catch (e) {
      final msg = e.toString().toLowerCase();
      if (msg.contains('duplicate column') || msg.contains('already exists')) {
        return;
      }
      if (msg.contains('no such table')) {
        return;
      }
      rethrow;
    }
  }

  Future<void> ensureExpenseSeriesOccurredUniqueIndex() async {
    try {
      await customStatement(
        'CREATE UNIQUE INDEX IF NOT EXISTS ux_expense_series_occurred '
        'ON expenses (recurring_series_id, occurred_on) '
        'WHERE recurring_series_id IS NOT NULL',
      );
    } catch (e) {
      final msg = e.toString().toLowerCase();
      if (msg.contains('no such column')) {
        return;
      }
      rethrow;
    }
  }

  Future<void> ensureExpensePaymentExpectationColumns() async {
    try {
      await customStatement(
        'ALTER TABLE expenses ADD COLUMN payment_expectation_status TEXT',
      );
    } catch (e) {
      final msg = e.toString().toLowerCase();
      if (msg.contains('duplicate column') || msg.contains('already exists')) {
        return;
      }
      if (msg.contains('no such table')) {
        return;
      }
      rethrow;
    }
    try {
      await customStatement(
        'ALTER TABLE expenses ADD COLUMN payment_expectation_confirmed_on TEXT',
      );
    } catch (e) {
      final msg = e.toString().toLowerCase();
      if (msg.contains('duplicate column') || msg.contains('already exists')) {
        return;
      }
      if (msg.contains('no such table')) {
        return;
      }
      rethrow;
    }
  }

  Future<void> ensureExpenseRecurringSeriesIdColumn() async {
    try {
      await customStatement(
        'ALTER TABLE expenses ADD COLUMN recurring_series_id TEXT '
        'REFERENCES expense_recurring_series (id) ON DELETE CASCADE',
      );
    } catch (e) {
      final msg = e.toString().toLowerCase();
      if (msg.contains('duplicate column') || msg.contains('already exists')) {
        return;
      }
      if (msg.contains('no such table')) {
        return;
      }
      rethrow;
    }
  }

  Future<void> ensurePaymentInstrumentV2Columns() async {
    const stmts = <String>[
      'ALTER TABLE payment_instruments ADD COLUMN is_active INTEGER NOT NULL DEFAULT 1',
      'ALTER TABLE payment_instruments ADD COLUMN is_default INTEGER NOT NULL DEFAULT 0',
      'ALTER TABLE payment_instruments ADD COLUMN statement_closing_day INTEGER',
      'ALTER TABLE payment_instruments ADD COLUMN payment_due_day INTEGER',
      'ALTER TABLE payment_instruments ADD COLUMN nominal_apr_percent REAL',
      'ALTER TABLE payment_instruments ADD COLUMN credit_limit REAL',
      'ALTER TABLE payment_instruments ADD COLUMN display_suffix TEXT',
    ];
    for (final sql in stmts) {
      try {
        await customStatement(sql);
      } catch (e) {
        final msg = e.toString().toLowerCase();
        if (msg.contains('duplicate column') || msg.contains('already exists')) {
          continue;
        }
        if (msg.contains('no such table')) {
          continue;
        }
        rethrow;
      }
    }
  }

  Future<void> ensureExpenseInstallmentColumns() async {
    try {
      await customStatement(
        'ALTER TABLE expenses ADD COLUMN installment_plan_id TEXT '
        'REFERENCES installment_plans (id) ON DELETE SET NULL',
      );
    } catch (e) {
      final msg = e.toString().toLowerCase();
      if (msg.contains('duplicate column') || msg.contains('already exists')) {
        return;
      }
      if (msg.contains('no such table')) {
        return;
      }
      rethrow;
    }
    try {
      await customStatement(
        'ALTER TABLE expenses ADD COLUMN installment_index INTEGER',
      );
    } catch (e) {
      final msg = e.toString().toLowerCase();
      if (msg.contains('duplicate column') || msg.contains('already exists')) {
        return;
      }
      if (msg.contains('no such table')) {
        return;
      }
      rethrow;
    }
  }

  /// Ensures exactly one [PaymentInstruments.isDefault] when any row exists and none set.
  /// Recurring rows dated on or before local today that are still [expected] are
  /// marked confirmed (paid/received) with confirmation date = occurrence date.
  /// Standalone rows (no series) with null status and date on or before today are
  /// marked confirmed the same way (legacy one-off rows).
  /// Idempotent; repairs books created before materialization defaulted past rows.
  Future<void> backfillRecurringPastExpectationsSettled() async {
    final todayIso = ExpenseDates.toStorageDate(calendarTodayLocal());
    final confirmed = PaymentExpectationStatus.confirmedPaid.storageName;
    try {
      await customStatement(
        'UPDATE income_entries SET expectation_status = \'$confirmed\', '
        'expectation_confirmed_on = received_on '
        'WHERE recurring_series_id IS NOT NULL AND TRIM(recurring_series_id) != \'\' '
        'AND (expectation_status IS NULL OR expectation_status = \'expected\') '
        'AND received_on <= \'$todayIso\'',
      );
      await customStatement(
        'UPDATE expenses SET payment_expectation_status = \'$confirmed\', '
        'payment_expectation_confirmed_on = occurred_on '
        'WHERE recurring_series_id IS NOT NULL AND TRIM(recurring_series_id) != \'\' '
        'AND (payment_expectation_status IS NULL OR payment_expectation_status = \'expected\') '
        'AND occurred_on <= \'$todayIso\'',
      );
      await customStatement(
        'UPDATE income_entries SET expectation_status = \'$confirmed\', '
        'expectation_confirmed_on = received_on '
        'WHERE (recurring_series_id IS NULL OR TRIM(recurring_series_id) = \'\') '
        'AND expectation_status IS NULL '
        'AND received_on <= \'$todayIso\'',
      );
      await customStatement(
        'UPDATE expenses SET payment_expectation_status = \'$confirmed\', '
        'payment_expectation_confirmed_on = occurred_on '
        'WHERE (recurring_series_id IS NULL OR TRIM(recurring_series_id) = \'\') '
        'AND payment_expectation_status IS NULL '
        'AND occurred_on <= \'$todayIso\'',
      );
    } catch (e) {
      final msg = e.toString().toLowerCase();
      if (msg.contains('no such table') || msg.contains('no such column')) {
        return;
      }
      rethrow;
    }
  }

  Future<void> backfillPaymentInstrumentDefaultsIfNeeded() async {
    try {
      final rows = await select(paymentInstruments).get();
      if (rows.isEmpty) {
        return;
      }
      if (rows.any((r) => r.isDefault)) {
        return;
      }
      final sorted = [...rows]..sort((a, b) => a.label.compareTo(b.label));
      final id = sorted.first.id;
      await (update(paymentInstruments)..where((t) => t.id.equals(id))).write(
        const PaymentInstrumentsCompanion(isDefault: Value(true)),
      );
    } catch (e) {
      final msg = e.toString().toLowerCase();
      if (msg.contains('no such table')) {
        return;
      }
      rethrow;
    }
  }

  Future<void> ensureCategoryAndSubcategoryDescriptionColumns() async {
    const stmts = <String>[
      'ALTER TABLE categories ADD COLUMN description TEXT',
      'ALTER TABLE subcategories ADD COLUMN description TEXT',
    ];
    for (final sql in stmts) {
      try {
        await customStatement(sql);
      } catch (e) {
        final msg = e.toString().toLowerCase();
        if (msg.contains('duplicate column') || msg.contains('already exists')) {
          continue;
        }
        if (msg.contains('no such table')) {
          continue;
        }
        rethrow;
      }
    }
  }
}

AppDatabase? _appDatabase;

/// Opens the singleton app database. Must be called once from [main] before UI.
Future<AppDatabase> initializeAppDatabase() async {
  if (_appDatabase != null) {
    return _appDatabase!;
  }
  final db = AppDatabase.openDefault();
  await db.customSelect('SELECT 1').getSingle();
  await db.ensureExpenseDescriptionColumn();
  await db.ensureCategoryAndSubcategoryDescriptionColumns();
  await db.ensureExpensePaymentInstrumentIdColumn();
  await db.ensureExpenseRecurringSeriesIdColumn();
  await db.ensureExpenseSeriesOccurredUniqueIndex();
  await db.ensureExpensePaymentExpectationColumns();
  await db.ensurePaymentInstrumentV2Columns();
  await db.ensureExpenseInstallmentColumns();
  await db.backfillPaymentInstrumentDefaultsIfNeeded();
  await db.ensureIncomeTaxonomyDescriptionColumns();
  await db.ensureIncomeRecurringSeriesColumns();
  await db.ensureIncomeSeriesReceivedUniqueIndex();
  await db.backfillRecurringPastExpectationsSettled();
  await IncomeCategorySeeder.ensureSeedData(db);
  _appDatabase = db;
  return db;
}

AppDatabase get appDatabase {
  final db = _appDatabase;
  if (db == null) {
    throw StateError('initializeAppDatabase() was not called.');
  }
  return db;
}
