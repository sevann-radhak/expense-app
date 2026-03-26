import 'package:flutter_test/flutter_test.dart';

import 'package:expense_app/presentation/app.dart';

void main() {
  testWidgets('shows placeholder home', (WidgetTester tester) async {
    await tester.pumpWidget(const ExpenseApp());
    expect(find.text('Expense Tracker — web target ready.'), findsOneWidget);
  });
}
