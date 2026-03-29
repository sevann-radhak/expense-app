import 'package:flutter_test/flutter_test.dart';

import 'package:expense_app/application/expense_api_dto.dart';
import 'package:expense_app/data/remote/mock_expense_remote_api.dart';

void main() {
  test('MockExpenseRemoteApi returns serializable DTOs', () async {
    const api = MockExpenseRemoteApi();
    final rows = await api.fetchSampleExpenses();
    expect(rows, isNotEmpty);
    final roundTrip = ExpenseApiDto.listFromJsonUtf8(
      ExpenseApiDto.listToJsonUtf8(rows),
    );
    expect(roundTrip.first.id, rows.first.id);
    expect(roundTrip.first.categoryId, rows.first.categoryId);
  });
}
