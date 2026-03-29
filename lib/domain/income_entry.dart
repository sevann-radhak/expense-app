/// Single income line (local-first book). Date is calendar-only like expenses.
class IncomeEntry {
  const IncomeEntry({
    required this.id,
    required this.receivedOn,
    required this.incomeCategoryId,
    required this.incomeSubcategoryId,
    required this.amountOriginal,
    required this.currencyCode,
    required this.manualFxRateToUsd,
    required this.amountUsd,
    this.description = '',
  });

  final String id;
  final DateTime receivedOn;
  final String incomeCategoryId;
  final String incomeSubcategoryId;
  final double amountOriginal;
  final String currencyCode;
  final double manualFxRateToUsd;
  final double amountUsd;
  final String description;

  static double computeUsd(double amountOriginal, double manualFxRateToUsd) {
    return amountOriginal * manualFxRateToUsd;
  }

  IncomeEntry copyWith({
    String? id,
    DateTime? receivedOn,
    String? incomeCategoryId,
    String? incomeSubcategoryId,
    double? amountOriginal,
    String? currencyCode,
    double? manualFxRateToUsd,
    double? amountUsd,
    String? description,
  }) {
    return IncomeEntry(
      id: id ?? this.id,
      receivedOn: receivedOn ?? this.receivedOn,
      incomeCategoryId: incomeCategoryId ?? this.incomeCategoryId,
      incomeSubcategoryId: incomeSubcategoryId ?? this.incomeSubcategoryId,
      amountOriginal: amountOriginal ?? this.amountOriginal,
      currencyCode: currencyCode ?? this.currencyCode,
      manualFxRateToUsd: manualFxRateToUsd ?? this.manualFxRateToUsd,
      amountUsd: amountUsd ?? this.amountUsd,
      description: description ?? this.description,
    );
  }
}
