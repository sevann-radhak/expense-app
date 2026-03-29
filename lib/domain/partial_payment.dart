// Partial settlement of an expense across multiple payments.
// Product spec: docs/04-phase-4-analysis.md §8. Phase 4.8: interfaces only (no persistence).

/// One recorded partial settlement toward an expense (USD snapshot).
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

  /// Calendar date only (local).
  final DateTime paidOn;
  final String note;
}

/// Future repository for partial payments; not wired to Drift in Phase 4.
abstract class PartialPaymentRepository {
  Stream<List<PartialPayment>> watchForExpense(String expenseId);

  Future<void> upsert(PartialPayment payment);

  Future<void> deleteById(String id);
}
