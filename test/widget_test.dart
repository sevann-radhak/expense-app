import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:expense_app/data/local/app_database.dart';
import 'package:expense_app/l10n/app_localizations.dart';
import 'package:expense_app/presentation/app.dart';
import 'package:expense_app/presentation/providers/providers.dart';
import 'package:expense_app/presentation/router/app_router.dart';

void main() {
  Future<AppDatabase> openTestDatabase() async {
    final db = AppDatabase(NativeDatabase.memory());
    await db.customSelect('SELECT 1').getSingle();
    return db;
  }

  /// [appRouter] is process-singleton; shell branch survives across tests unless
  /// we reset the location.
  Future<void> pumpExpenseApp(
    WidgetTester tester, {
    required AppDatabase db,
    SharedPreferences? prefs,
  }) async {
    SharedPreferences.setMockInitialValues({});
    final p = prefs ?? await SharedPreferences.getInstance();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          sharedPreferencesProvider.overrideWithValue(p),
        ],
        child: const ExpenseApp(),
      ),
    );
    await tester.pumpAndSettle();
    appRouter.go('/home');
    await tester.pumpAndSettle();
  }

  /// Drift stream teardown schedules zero-duration timers; flush them while the
  /// test binding is still active, then close the database.
  Future<void> disposeUiAndDb(WidgetTester tester, AppDatabase db) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
    await db.close();
  }

  testWidgets('reports screen shows annual hub', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final db = await openTestDatabase();
    try {
      await pumpExpenseApp(tester, db: db);
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      await tester.tap(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text(l10n.navReports),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text(l10n.reportsTitle),
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('selected-report-year-label')),
        findsOneWidget,
      );
      expect(find.text(l10n.reportsByMonthHeading), findsNothing);
    } finally {
      await disposeUiAndDb(tester, db);
    }
  });

  testWidgets('categories screen lists seeded taxonomy', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final db = await openTestDatabase();
    try {
      await pumpExpenseApp(tester, db: db);
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      expect(find.byKey(const ValueKey<String>('selected-month-label')), findsOneWidget);
      await tester.tap(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text(l10n.navCategories),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Formation'), findsOneWidget);
      expect(find.textContaining('cat_'), findsNothing);
    } finally {
      await disposeUiAndDb(tester, db);
    }
  });

  testWidgets('navigates to settings with bottom bar', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final db = await openTestDatabase();
    try {
      await pumpExpenseApp(tester, db: db);
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      await tester.tap(find.text(l10n.navSettings));
      await tester.pumpAndSettle();

      expect(find.text(l10n.settingsPreferencesSectionTitle), findsOneWidget);
    } finally {
      await disposeUiAndDb(tester, db);
    }
  });

  testWidgets('navigates with navigation rail on wide layout', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final db = await openTestDatabase();
    try {
      await pumpExpenseApp(tester, db: db);
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      await tester.tap(
        find.descendant(
          of: find.byType(NavigationRail),
          matching: find.text(l10n.navSettings),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(l10n.settingsPreferencesSectionTitle), findsOneWidget);
    } finally {
      await disposeUiAndDb(tester, db);
    }
  });
}
