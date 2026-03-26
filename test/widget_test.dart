import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:expense_app/l10n/app_localizations.dart';
import 'package:expense_app/presentation/app.dart';

void main() {
  testWidgets('shows placeholder home', (WidgetTester tester) async {
    await tester.pumpWidget(const ExpenseApp());
    await tester.pumpAndSettle();
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.placeholderHomeBody), findsOneWidget);
  });
}
