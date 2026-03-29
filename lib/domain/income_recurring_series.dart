import 'package:expense_app/domain/expense.dart';
import 'package:expense_app/domain/recurrence_rule.dart';

/// Template + recurrence for generating materialized [IncomeEntry] rows.
final class IncomeRecurringSeries {
  const IncomeRecurringSeries({
    required this.id,
    required this.anchorReceivedOn,
    required this.rule,
    required this.endCondition,
    required this.horizonMonths,
    required this.active,
    required this.incomeCategoryId,
    required this.incomeSubcategoryId,
    required this.amountOriginal,
    required this.currencyCode,
    required this.manualFxRateToUsd,
    required this.amountUsd,
    this.description = '',
  });

  final String id;
  final DateTime anchorReceivedOn;
  final RecurrenceRule rule;
  final RecurrenceEndCondition endCondition;
  final int horizonMonths;
  final bool active;

  final String incomeCategoryId;
  final String incomeSubcategoryId;
  final double amountOriginal;
  final String currencyCode;
  final double manualFxRateToUsd;
  final double amountUsd;
  final String description;

  void validate() {
    if (id.isEmpty) {
      throw ArgumentError('id must not be empty');
    }
    if (horizonMonths < 1) {
      throw ArgumentError.value(horizonMonths, 'horizonMonths', 'must be >= 1');
    }
    rule.validate();
    endCondition.validate();
    ExpenseDates.toStorageDate(anchorReceivedOn);
    if (manualFxRateToUsd <= 0) {
      throw ArgumentError.value(
        manualFxRateToUsd,
        'manualFxRateToUsd',
        'must be positive',
      );
    }
  }

  IncomeRecurringSeries copyWith({
    String? id,
    DateTime? anchorReceivedOn,
    RecurrenceRule? rule,
    RecurrenceEndCondition? endCondition,
    int? horizonMonths,
    bool? active,
    String? incomeCategoryId,
    String? incomeSubcategoryId,
    double? amountOriginal,
    String? currencyCode,
    double? manualFxRateToUsd,
    double? amountUsd,
    String? description,
  }) {
    return IncomeRecurringSeries(
      id: id ?? this.id,
      anchorReceivedOn: anchorReceivedOn ?? this.anchorReceivedOn,
      rule: rule ?? this.rule,
      endCondition: endCondition ?? this.endCondition,
      horizonMonths: horizonMonths ?? this.horizonMonths,
      active: active ?? this.active,
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
