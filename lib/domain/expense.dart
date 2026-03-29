import 'package:expense_app/domain/payment_expectation_status.dart';

/// Calendar date for an expense (no time-of-day). Persisted as `YYYY-MM-DD`.
abstract final class ExpenseDates {
  static String toStorageDate(DateTime dateOnly) {
    final y = dateOnly.year.toString().padLeft(4, '0');
    final m = dateOnly.month.toString().padLeft(2, '0');
    final d = dateOnly.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  static DateTime fromStorageDate(String stored) {
    final parts = stored.split('-');
    if (parts.length != 3) {
      throw FormatException('Expected YYYY-MM-DD', stored);
    }
    return DateTime(
      int.parse(parts[0], radix: 10),
      int.parse(parts[1], radix: 10),
      int.parse(parts[2], radix: 10),
    );
  }
}

/// Single expense line (local-first book).
class Expense {
  const Expense({
    required this.id,
    required this.occurredOn,
    required this.categoryId,
    required this.subcategoryId,
    required this.amountOriginal,
    required this.currencyCode,
    required this.manualFxRateToUsd,
    required this.amountUsd,
    required this.paidWithCreditCard,
    this.description = '',
    this.paymentInstrumentId,
    this.recurringSeriesId,
    this.paymentExpectationStatus,
    this.paymentExpectationConfirmedOn,
  });

  final String id;

  /// Date on the local calendar (time-of-day ignored).
  final DateTime occurredOn;
  final String categoryId;
  final String subcategoryId;

  /// Amount in [currencyCode] units.
  final double amountOriginal;
  final String currencyCode;

  /// Multiplier to USD: `amountUsd = amountOriginal * manualFxRateToUsd`.
  /// If the UI uses “1 USD = X local units”, then `manualFxRateToUsd = 1 / X`.
  final double manualFxRateToUsd;

  /// Stored snapshot: `amountOriginal * manualFxRateToUsd` at save time.
  final double amountUsd;
  final bool paidWithCreditCard;

  /// Optional user note (plain text).
  final String description;

  /// Optional link to a card profile (metadata only at rest).
  final String? paymentInstrumentId;

  /// When set, this row was generated from a recurring series (Phase 4.1).
  final String? recurringSeriesId;

  /// User disposition for a recurring-generated row (Phase 4.2).
  final PaymentExpectationStatus? paymentExpectationStatus;

  /// Date-only: when the user marked [PaymentExpectationStatus.confirmedPaid].
  final DateTime? paymentExpectationConfirmedOn;

  static double computeUsd(double amountOriginal, double manualFxRateToUsd) {
    return amountOriginal * manualFxRateToUsd;
  }

  Expense copyWith({
    String? id,
    DateTime? occurredOn,
    String? categoryId,
    String? subcategoryId,
    double? amountOriginal,
    String? currencyCode,
    double? manualFxRateToUsd,
    double? amountUsd,
    bool? paidWithCreditCard,
    String? description,
    String? paymentInstrumentId,
    String? recurringSeriesId,
    PaymentExpectationStatus? paymentExpectationStatus,
    DateTime? paymentExpectationConfirmedOn,
    bool clearPaymentInstrumentId = false,
    bool clearRecurringSeriesId = false,
    bool clearPaymentExpectation = false,
    bool clearPaymentExpectationConfirmedOn = false,
  }) {
    final nextStatus = clearPaymentExpectation
        ? null
        : (paymentExpectationStatus ?? this.paymentExpectationStatus);
    final nextConfirmed = clearPaymentExpectation ||
            clearPaymentExpectationConfirmedOn
        ? null
        : (paymentExpectationConfirmedOn ?? this.paymentExpectationConfirmedOn);
    return Expense(
      id: id ?? this.id,
      occurredOn: occurredOn ?? this.occurredOn,
      categoryId: categoryId ?? this.categoryId,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      amountOriginal: amountOriginal ?? this.amountOriginal,
      currencyCode: currencyCode ?? this.currencyCode,
      manualFxRateToUsd: manualFxRateToUsd ?? this.manualFxRateToUsd,
      amountUsd: amountUsd ?? this.amountUsd,
      paidWithCreditCard: paidWithCreditCard ?? this.paidWithCreditCard,
      description: description ?? this.description,
      paymentInstrumentId: clearPaymentInstrumentId
          ? null
          : (paymentInstrumentId ?? this.paymentInstrumentId),
      recurringSeriesId: clearRecurringSeriesId
          ? null
          : (recurringSeriesId ?? this.recurringSeriesId),
      paymentExpectationStatus: nextStatus,
      paymentExpectationConfirmedOn: nextConfirmed,
    );
  }
}
