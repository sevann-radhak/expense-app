import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:expense_app/data/local/app_database.dart';
import 'package:expense_app/presentation/app.dart';
import 'package:expense_app/presentation/providers/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final db = await initializeAppDatabase();
  assert(() {
    debugPrint('Drift: database ready (schemaVersion=${db.schemaVersion})');
    return true;
  }());
  runApp(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const ExpenseApp(),
    ),
  );
}
