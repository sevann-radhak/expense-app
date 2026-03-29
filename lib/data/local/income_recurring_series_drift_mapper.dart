import 'dart:convert';

import 'package:expense_app/application/recurrence_json_codec.dart';
import 'package:expense_app/data/local/app_database.dart';
import 'package:expense_app/domain/domain.dart';

IncomeRecurringSeries incomeRecurringSeriesFromDriftRow(
  IncomeRecurringSeriesRow row,
) {
  final decoded = jsonDecode(row.recurrenceJson);
  if (decoded is! Map<String, dynamic>) {
    throw const FormatException('recurrenceJson root');
  }
  final (rule, end) = decodeRecurrencePayloadMap(decoded);
  return IncomeRecurringSeries(
    id: row.id,
    anchorReceivedOn: ExpenseDates.fromStorageDate(row.anchorReceivedOn),
    rule: rule,
    endCondition: end,
    horizonMonths: row.horizonMonths,
    active: row.active,
    incomeCategoryId: row.incomeCategoryId,
    incomeSubcategoryId: row.incomeSubcategoryId,
    amountOriginal: row.amountOriginal,
    currencyCode: row.currencyCode,
    manualFxRateToUsd: row.manualFxRateToUsd,
    amountUsd: row.amountUsd,
    description: row.description,
  );
}
