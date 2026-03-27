import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'package:expense_app/data/local/category_seed.dart';

part 'app_database.g.dart';

@DataClassName('CategoryRow')
class Categories extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

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

  TextColumn get slug => text()();

  BoolColumn get isSystemReserved => boolean().withDefault(const Constant(false))();

  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

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

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(tables: [Categories, Subcategories, Expenses])
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
  int get schemaVersion => 3;

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
        },
      );
}

AppDatabase? _appDatabase;

/// Opens the singleton app database. Must be called once from [main] before UI.
Future<AppDatabase> initializeAppDatabase() async {
  if (_appDatabase != null) {
    return _appDatabase!;
  }
  final db = AppDatabase.openDefault();
  await db.customSelect('SELECT 1').getSingle();
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
