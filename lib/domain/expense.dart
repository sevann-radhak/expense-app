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
  });

  final String id;

  /// Date on the local calendar (time-of-day ignored).
  final DateTime occurredOn;
  final String categoryId;
  final String subcategoryId;

  /// Amount in [currencyCode] units.
  final double amountOriginal;
  final String currencyCode;

  /// Multiply [amountOriginal] by this rate to get USD (manual override).
  final double manualFxRateToUsd;

  /// Stored snapshot: `amountOriginal * manualFxRateToUsd` at save time.
  final double amountUsd;
  final bool paidWithCreditCard;

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
  }) {
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
    );
  }
}
