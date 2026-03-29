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

  PaymentInstrument copyWith({
    String? id,
    String? label,
    String? bankName,
    int? billingCycleDay,
    double? annualFeeAmount,
    double? monthlyFeeAmount,
    String? feeDescription,
    bool clearBankName = false,
    bool clearBillingCycleDay = false,
    bool clearAnnualFeeAmount = false,
    bool clearMonthlyFeeAmount = false,
    bool clearFeeDescription = false,
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
    );
  }
}
