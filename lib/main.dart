import 'package:flutter/widgets.dart';

import 'package:expense_app/data/local/app_database.dart';
import 'package:expense_app/presentation/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = await initializeAppDatabase();
  assert(() {
    debugPrint('Drift: database ready (schemaVersion=${db.schemaVersion})');
    return true;
  }());
  runApp(const ExpenseApp());
}
