import 'dart:convert';

import 'package:expense_app/application/recurrence_json_codec.dart';
import 'package:expense_app/data/local/app_database.dart';
import 'package:expense_app/domain/domain.dart';

ExpenseRecurringSeries expenseRecurringSeriesFromDriftRow(
  ExpenseRecurringSeriesRow row,
) {
  final decoded = jsonDecode(row.recurrenceJson);
  if (decoded is! Map<String, dynamic>) {
    throw const FormatException('recurrenceJson root');
  }
  final (rule, end) = decodeRecurrencePayloadMap(decoded);
  return ExpenseRecurringSeries(
    id: row.id,
    anchorOccurredOn: ExpenseDates.fromStorageDate(row.anchorOccurredOn),
    rule: rule,
    endCondition: end,
    horizonMonths: row.horizonMonths,
    active: row.active,
    categoryId: row.categoryId,
    subcategoryId: row.subcategoryId,
    amountOriginal: row.amountOriginal,
    currencyCode: row.currencyCode,
    manualFxRateToUsd: row.manualFxRateToUsd,
    amountUsd: row.amountUsd,
    paidWithCreditCard: row.paidWithCreditCard,
    description: row.description,
    paymentInstrumentId: row.paymentInstrumentId,
  );
}
