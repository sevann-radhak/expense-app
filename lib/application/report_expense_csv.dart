import 'package:expense_app/domain/domain.dart';

/// RFC 4180-style escaping for CSV fields.
String csvEscapeField(String value) {
  if (value.contains(',') ||
      value.contains('"') ||
      value.contains('\n') ||
      value.contains('\r')) {
    return '"${value.replaceAll('"', '""')}"';
  }
  return value;
}

String _csvDouble(double v) {
  if (v == v.roundToDouble()) {
    return '${v.round()}';
  }
  return v.toString();
}

/// Builds UTF-8–friendly CSV (comma-separated, LF newlines) for report exports.
/// Columns are stable for spreadsheets and future PDF layouts.
String buildReportExpensesCsv({
  required List<Expense> expenses,
  required Map<String, String> categoryNames,
  required Map<String, String> subcategoryNames,
  required String unknownCategoryLabel,
  required String unknownSubcategoryLabel,
}) {
  const header =
      'occurred_on,category_id,category_name,subcategory_id,subcategory_name,'
      'amount_original,currency_code,fx_rate_to_usd,amount_usd,'
      'paid_with_credit_card,description';

  final sorted = List<Expense>.from(expenses)
    ..sort((a, b) {
      final byDate = a.occurredOn.compareTo(b.occurredOn);
      if (byDate != 0) {
        return byDate;
      }
      return a.id.compareTo(b.id);
    });

  final buf = StringBuffer()..writeln(header);
  for (final e in sorted) {
    final date = ExpenseDates.toStorageDate(e.occurredOn);
    final cName = categoryNames[e.categoryId] ?? unknownCategoryLabel;
    final sName = subcategoryNames[e.subcategoryId] ?? unknownSubcategoryLabel;
    final row = <String>[
      date,
      csvEscapeField(e.categoryId),
      csvEscapeField(cName),
      csvEscapeField(e.subcategoryId),
      csvEscapeField(sName),
      _csvDouble(e.amountOriginal),
      e.currencyCode,
      _csvDouble(e.manualFxRateToUsd),
      _csvDouble(e.amountUsd),
      e.paidWithCreditCard ? 'true' : 'false',
      csvEscapeField(e.description),
    ].join(',');
    buf.writeln(row);
  }
  return buf.toString();
}
