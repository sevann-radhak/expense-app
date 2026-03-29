import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'package:expense_app/data/local/category_seed.dart';

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

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Categories,
    Subcategories,
    Expenses,
    PaymentInstruments,
    RecExpenseSeries,
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
  int get schemaVersion => 10;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await CategorySeeder.ensureSeedData(this);
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
        },
        beforeOpen: (OpeningDetails details) async {
          await ensureExpenseDescriptionColumn();
          await ensureCategoryAndSubcategoryDescriptionColumns();
          await ensureExpensePaymentInstrumentIdColumn();
          await ensureExpenseRecurringSeriesIdColumn();
          await ensureExpenseSeriesOccurredUniqueIndex();
          await ensureExpensePaymentExpectationColumns();
        },
      );

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
