import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Minimal anchor table so schema v1 exists and migrations have a target.
class SchemaAnchors extends Table {
  IntColumn get id => integer().autoIncrement()();
}

@DriftDatabase(tables: [SchemaAnchors])
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
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
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
