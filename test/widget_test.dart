import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:expense_app/l10n/app_localizations.dart';
import 'package:expense_app/presentation/app.dart';

void main() {
  testWidgets('home shows empty state', (WidgetTester tester) async {
    await tester.pumpWidget(const ExpenseApp());
    await tester.pumpAndSettle();
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.homeEmptyState), findsOneWidget);
  });

  testWidgets('navigates to settings with bottom bar', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ExpenseApp());
    await tester.pumpAndSettle();
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    await tester.tap(find.text(l10n.navSettings));
    await tester.pumpAndSettle();

    expect(find.text(l10n.settingsPlaceholder), findsOneWidget);
  });

  testWidgets('navigates with navigation rail on wide layout', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ExpenseApp());
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
  });
}
