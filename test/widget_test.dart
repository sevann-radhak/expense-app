import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:expense_app/data/local/app_database.dart';
import 'package:expense_app/l10n/app_localizations.dart';
import 'package:expense_app/presentation/app.dart';
import 'package:expense_app/presentation/providers/providers.dart';

void main() {
  Future<AppDatabase> openTestDatabase() async {
    final db = AppDatabase(NativeDatabase.memory());
    await db.customSelect('SELECT 1').getSingle();
    return db;
  }

  /// Drift stream teardown schedules zero-duration timers; flush them while the
  /// test binding is still active, then close the database.
  Future<void> disposeUiAndDb(WidgetTester tester, AppDatabase db) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
    await db.close();
  }

  testWidgets('home shows seeded categories from database', (WidgetTester tester) async {
    final db = await openTestDatabase();
    try {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
          ],
          child: const ExpenseApp(),
        ),
      );
      await tester.pumpAndSettle();
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      expect(find.byKey(const ValueKey<String>('selected-month-label')), findsOneWidget);
      expect(find.text(l10n.categoriesDebugHeading), findsOneWidget);
      await tester.tap(find.text(l10n.categoriesDebugHeading));
      await tester.pumpAndSettle();
      expect(find.text('Formation'), findsOneWidget);
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
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
          ],
          child: const ExpenseApp(),
        ),
      );
      await tester.pumpAndSettle();
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      await tester.tap(find.text(l10n.navSettings));
      await tester.pumpAndSettle();

      expect(find.text(l10n.settingsPlaceholder), findsOneWidget);
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
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
          ],
          child: const ExpenseApp(),
        ),
      );
      await tester.pumpAndSettle();
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      await tester.tap(
        find.descendant(
          of: find.byType(NavigationRail),
          matching: find.text(l10n.navSettings),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(l10n.settingsPlaceholder), findsOneWidget);
    } finally {
      await disposeUiAndDb(tester, db);
    }
  });
}
