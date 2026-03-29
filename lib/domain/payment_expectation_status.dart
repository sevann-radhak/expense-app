/// User disposition for a materialized recurring expense (Phase 4.2; Phase 5 alerts).
enum PaymentExpectationStatus {
  /// Default for generated future rows until the user acts.
  expected,

  /// User marked the obligation as paid (on schedule or early; see [Expense.paymentExpectationConfirmedOn]).
  confirmedPaid,

  /// User skipped this occurrence.
  skipped,

  /// User waived this occurrence (e.g. not charging).
  waived,
}

extension PaymentExpectationStatusStorage on PaymentExpectationStatus {
  String get storageName => name;
}

PaymentExpectationStatus? paymentExpectationStatusFromStorage(String? raw) {
  if (raw == null || raw.isEmpty) {
    return null;
  }
  for (final v in PaymentExpectationStatus.values) {
    if (v.name == raw) {
      return v;
    }
  }
  return null;
}
