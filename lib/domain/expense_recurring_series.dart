import 'package:expense_app/domain/expense.dart';
import 'package:expense_app/domain/recurrence_rule.dart';

/// Template + recurrence for generating materialized [Expense] rows (see Phase 4.1).
final class ExpenseRecurringSeries {
  const ExpenseRecurringSeries({
    required this.id,
    required this.anchorOccurredOn,
    required this.rule,
    required this.endCondition,
    required this.horizonMonths,
    required this.active,
    required this.categoryId,
    required this.subcategoryId,
    required this.amountOriginal,
    required this.currencyCode,
    required this.manualFxRateToUsd,
    required this.amountUsd,
    required this.paidWithCreditCard,
    this.description = '',
    this.paymentInstrumentId,
  });

  final String id;

  /// First occurrence date (date-only); aligns with generated rows.
  final DateTime anchorOccurredOn;
  final RecurrenceRule rule;
  final RecurrenceEndCondition endCondition;

  /// Rolling window: materialize occurrences up to this many months after [referenceDate]
  /// passed to materialization (typically “today”).
  final int horizonMonths;
  final bool active;

  final String categoryId;
  final String subcategoryId;
  final double amountOriginal;
  final String currencyCode;
  final double manualFxRateToUsd;
  final double amountUsd;
  final bool paidWithCreditCard;
  final String description;
  final String? paymentInstrumentId;

  void validate() {
    if (id.isEmpty) {
      throw ArgumentError('id must not be empty');
    }
    if (horizonMonths < 1) {
      throw ArgumentError.value(horizonMonths, 'horizonMonths', 'must be >= 1');
    }
    rule.validate();
    endCondition.validate();
    ExpenseDates.toStorageDate(anchorOccurredOn);
    if (manualFxRateToUsd <= 0) {
      throw ArgumentError.value(
        manualFxRateToUsd,
        'manualFxRateToUsd',
        'must be positive',
      );
    }
  }

  ExpenseRecurringSeries copyWith({
    String? id,
    DateTime? anchorOccurredOn,
    RecurrenceRule? rule,
    RecurrenceEndCondition? endCondition,
    int? horizonMonths,
    bool? active,
    String? categoryId,
    String? subcategoryId,
    double? amountOriginal,
    String? currencyCode,
    double? manualFxRateToUsd,
    double? amountUsd,
    bool? paidWithCreditCard,
    String? description,
    String? paymentInstrumentId,
    bool clearPaymentInstrumentId = false,
  }) {
    return ExpenseRecurringSeries(
      id: id ?? this.id,
      anchorOccurredOn: anchorOccurredOn ?? this.anchorOccurredOn,
      rule: rule ?? this.rule,
      endCondition: endCondition ?? this.endCondition,
      horizonMonths: horizonMonths ?? this.horizonMonths,
      active: active ?? this.active,
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
    );
  }
}
