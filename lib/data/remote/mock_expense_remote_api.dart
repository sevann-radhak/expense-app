import 'package:expense_app/application/expense_api_dto.dart';

/// Future real API (HTTP + auth). This mock is for serialization / UI spikes only.
abstract class ExpenseRemoteApi {
  Future<List<ExpenseApiDto>> fetchSampleExpenses();
}

/// Returns a fixed payload without network I/O.
final class MockExpenseRemoteApi implements ExpenseRemoteApi {
  const MockExpenseRemoteApi();

  @override
  Future<List<ExpenseApiDto>> fetchSampleExpenses() async {
    await Future<void>.value();
    return const [
      ExpenseApiDto(
        id: 'mock_api_exp_1',
        occurredOn: '2026-03-01',
        categoryId: 'cat_demo',
        subcategoryId: 'sub_demo',
        amountOriginal: 99.5,
        currencyCode: 'USD',
        manualFxRateToUsd: 1,
        amountUsd: 99.5,
        paidWithCreditCard: true,
        description: 'Mock API row',
        paymentInstrumentId: 'pi_mock',
      ),
    ];
  }
}
