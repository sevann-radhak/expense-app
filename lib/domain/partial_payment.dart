/// One partial settlement toward an expense (USD). See `docs/04-phase-4-analysis.md` §8; no Drift in Phase 4.
class PartialPayment {
  const PartialPayment({
    required this.id,
    required this.expenseId,
    required this.amountUsd,
    required this.paidOn,
    this.note = '',
  });

  final String id;
  final String expenseId;
  final double amountUsd;

  final DateTime paidOn;
  final String note;
}

abstract class PartialPaymentRepository {
  Stream<List<PartialPayment>> watchForExpense(String expenseId);

  Future<void> upsert(PartialPayment payment);

  Future<void> deleteById(String id);
}
