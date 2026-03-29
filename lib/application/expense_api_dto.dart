import 'dart:convert';

import 'package:expense_app/domain/domain.dart';

/// Wire-format DTO for a future HTTP API (Phase 7). Kept separate from [Expense] persistence.
final class ExpenseApiDto {
  const ExpenseApiDto({
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
  });

  final String id;

  /// ISO `YYYY-MM-DD` (calendar date only).
  final String occurredOn;
  final String categoryId;
  final String subcategoryId;
  final double amountOriginal;
  final String currencyCode;
  final double manualFxRateToUsd;
  final double amountUsd;
  final bool paidWithCreditCard;
  final String description;
  final String? paymentInstrumentId;

  factory ExpenseApiDto.fromExpense(Expense e) {
    return ExpenseApiDto(
      id: e.id,
      occurredOn: ExpenseDates.toStorageDate(e.occurredOn),
      categoryId: e.categoryId,
      subcategoryId: e.subcategoryId,
      amountOriginal: e.amountOriginal,
      currencyCode: e.currencyCode,
      manualFxRateToUsd: e.manualFxRateToUsd,
      amountUsd: e.amountUsd,
      paidWithCreditCard: e.paidWithCreditCard,
      description: e.description,
      paymentInstrumentId: e.paymentInstrumentId,
    );
  }

  Expense toExpense() {
    return Expense(
      id: id,
      occurredOn: ExpenseDates.fromStorageDate(occurredOn),
      categoryId: categoryId,
      subcategoryId: subcategoryId,
      amountOriginal: amountOriginal,
      currencyCode: currencyCode,
      manualFxRateToUsd: manualFxRateToUsd,
      amountUsd: amountUsd,
      paidWithCreditCard: paidWithCreditCard,
      description: description,
      paymentInstrumentId: paymentInstrumentId,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'occurredOn': occurredOn,
      'categoryId': categoryId,
      'subcategoryId': subcategoryId,
      'amountOriginal': amountOriginal,
      'currencyCode': currencyCode,
      'manualFxRateToUsd': manualFxRateToUsd,
      'amountUsd': amountUsd,
      'paidWithCreditCard': paidWithCreditCard,
      'description': description,
      'paymentInstrumentId': paymentInstrumentId,
    };
  }

  factory ExpenseApiDto.fromJson(Map<String, dynamic> json) {
    return ExpenseApiDto(
      id: json['id'] as String,
      occurredOn: json['occurredOn'] as String,
      categoryId: json['categoryId'] as String,
      subcategoryId: json['subcategoryId'] as String,
      amountOriginal: (json['amountOriginal'] as num).toDouble(),
      currencyCode: json['currencyCode'] as String,
      manualFxRateToUsd: (json['manualFxRateToUsd'] as num).toDouble(),
      amountUsd: (json['amountUsd'] as num).toDouble(),
      paidWithCreditCard: json['paidWithCreditCard'] as bool,
      description: json['description'] as String? ?? '',
      paymentInstrumentId: json['paymentInstrumentId'] as String?,
    );
  }

  static List<ExpenseApiDto> listFromJsonUtf8(String utf8) {
    final decoded = jsonDecode(utf8);
    if (decoded is! List) {
      throw const FormatException('Expected JSON array of expenses');
    }
    return decoded
        .map((e) => ExpenseApiDto.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  static String listToJsonUtf8(List<ExpenseApiDto> list) {
    return jsonEncode(list.map((e) => e.toJson()).toList());
  }
}
