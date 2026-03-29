import 'package:expense_app/domain/expense.dart';

/// Installment purchase plan: N equal legs linked via [Expense.installmentPlanId].
class InstallmentPlan {
  const InstallmentPlan({
    required this.id,
    required this.paymentCount,
    required this.intervalMonths,
    required this.anchorOccurredOn,
    required this.categoryId,
    required this.subcategoryId,
    required this.perPaymentAmountOriginal,
    required this.currencyCode,
    required this.manualFxRateToUsd,
    required this.perPaymentAmountUsd,
    this.paymentInstrumentId,
    this.description = '',
  });

  final String id;
  final int paymentCount;
  final int intervalMonths;

  /// First payment calendar date.
  final DateTime anchorOccurredOn;
  final String categoryId;
  final String subcategoryId;
  final String? paymentInstrumentId;

  final double perPaymentAmountOriginal;
  final String currencyCode;
  final double manualFxRateToUsd;
  final double perPaymentAmountUsd;
  final String description;
}
