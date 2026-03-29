/// Credit card (or similar) profile: **metadata only** — no PAN, CVV, or PIN.
class PaymentInstrument {
  const PaymentInstrument({
    required this.id,
    required this.label,
    this.bankName,
    this.billingCycleDay,
    this.annualFeeAmount,
    this.monthlyFeeAmount,
    this.feeDescription,
    this.isActive = true,
    this.isDefault = false,
    this.statementClosingDay,
    this.paymentDueDay,
    this.nominalAprPercent,
    this.creditLimit,
    this.displaySuffix,
  });

  final String id;
  final String label;
  final String? bankName;

  /// Day of month the statement or cycle closes (1–31), if known.
  final int? billingCycleDay;

  final double? annualFeeAmount;
  final double? monthlyFeeAmount;

  /// Free text for percentage-based fees (e.g. foreign transaction %).
  final String? feeDescription;

  /// When false, hidden from pickers but retained in history / backup.
  final bool isActive;

  /// At most one active default should exist when any instrument is active.
  final bool isDefault;

  final int? statementClosingDay;
  final int? paymentDueDay;

  /// Nominal APR as a percentage (e.g. 19.99), not a fraction.
  final double? nominalAprPercent;
  final double? creditLimit;

  /// Short suffix for statements (e.g. last four — not full PAN).
  final String? displaySuffix;

  PaymentInstrument copyWith({
    String? id,
    String? label,
    String? bankName,
    int? billingCycleDay,
    double? annualFeeAmount,
    double? monthlyFeeAmount,
    String? feeDescription,
    bool? isActive,
    bool? isDefault,
    int? statementClosingDay,
    int? paymentDueDay,
    double? nominalAprPercent,
    double? creditLimit,
    String? displaySuffix,
    bool clearBankName = false,
    bool clearBillingCycleDay = false,
    bool clearAnnualFeeAmount = false,
    bool clearMonthlyFeeAmount = false,
    bool clearFeeDescription = false,
    bool clearStatementClosingDay = false,
    bool clearPaymentDueDay = false,
    bool clearNominalAprPercent = false,
    bool clearCreditLimit = false,
    bool clearDisplaySuffix = false,
  }) {
    return PaymentInstrument(
      id: id ?? this.id,
      label: label ?? this.label,
      bankName: clearBankName ? null : (bankName ?? this.bankName),
      billingCycleDay: clearBillingCycleDay
          ? null
          : (billingCycleDay ?? this.billingCycleDay),
      annualFeeAmount: clearAnnualFeeAmount
          ? null
          : (annualFeeAmount ?? this.annualFeeAmount),
      monthlyFeeAmount: clearMonthlyFeeAmount
          ? null
          : (monthlyFeeAmount ?? this.monthlyFeeAmount),
      feeDescription: clearFeeDescription
          ? null
          : (feeDescription ?? this.feeDescription),
      isActive: isActive ?? this.isActive,
      isDefault: isDefault ?? this.isDefault,
      statementClosingDay: clearStatementClosingDay
          ? null
          : (statementClosingDay ?? this.statementClosingDay),
      paymentDueDay:
          clearPaymentDueDay ? null : (paymentDueDay ?? this.paymentDueDay),
      nominalAprPercent: clearNominalAprPercent
          ? null
          : (nominalAprPercent ?? this.nominalAprPercent),
      creditLimit: clearCreditLimit ? null : (creditLimit ?? this.creditLimit),
      displaySuffix:
          clearDisplaySuffix ? null : (displaySuffix ?? this.displaySuffix),
    );
  }
}
