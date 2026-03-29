import 'dart:convert';

import 'package:expense_app/application/book_backup_snapshot.dart';
import 'package:expense_app/domain/domain.dart';

/// JSON keys for the v1 backup document (stable for importers).
abstract final class BookBackupJsonKeys {
  static const schemaVersion = 'schemaVersion';
  static const exportedAt = 'exportedAt';
  static const categories = 'categories';
  static const subcategories = 'subcategories';
  static const paymentInstruments = 'paymentInstruments';
  static const expenses = 'expenses';
}

String encodeBookBackupPretty(BookBackupSnapshot snapshot) {
  final map = _snapshotToMap(snapshot);
  return const JsonEncoder.withIndent('  ').convert(map);
}

BookBackupSnapshot decodeBookBackup(String jsonUtf8) {
  final dynamic root = jsonDecode(jsonUtf8);
  if (root is! Map<String, dynamic>) {
    throw const FormatException('Backup root must be a JSON object');
  }
  final v = root[BookBackupJsonKeys.schemaVersion];
  if (v is! int || v != BookBackupSnapshot.currentSchemaVersion) {
    throw FormatException(
      'Unsupported backup schemaVersion: $v (expected ${BookBackupSnapshot.currentSchemaVersion})',
    );
  }
  final at = root[BookBackupJsonKeys.exportedAt];
  if (at is! String) {
    throw const FormatException('Missing exportedAt');
  }
  final exportedAt = DateTime.tryParse(at);
  if (exportedAt == null) {
    throw FormatException('Invalid exportedAt: $at');
  }

  final catList = root[BookBackupJsonKeys.categories];
  if (catList is! List) {
    throw const FormatException('categories must be an array');
  }
  final categories = catList.map((e) => _categoryFromJson(e)).toList();

  final subList = root[BookBackupJsonKeys.subcategories];
  if (subList is! List) {
    throw const FormatException('subcategories must be an array');
  }
  final subcategories = subList.map((e) => _subcategoryFromJson(e)).toList();

  final piList = root[BookBackupJsonKeys.paymentInstruments];
  if (piList is! List) {
    throw const FormatException('paymentInstruments must be an array');
  }
  final paymentInstruments = piList.map((e) => _paymentInstrumentFromJson(e)).toList();

  final expList = root[BookBackupJsonKeys.expenses];
  if (expList is! List) {
    throw const FormatException('expenses must be an array');
  }
  final expenses = expList.map((e) => _expenseFromJson(e)).toList();

  return BookBackupSnapshot(
    schemaVersion: BookBackupSnapshot.currentSchemaVersion,
    exportedAt: exportedAt,
    categories: categories,
    subcategories: subcategories,
    paymentInstruments: paymentInstruments,
    expenses: expenses,
  );
}

Map<String, dynamic> _snapshotToMap(BookBackupSnapshot s) {
  return <String, dynamic>{
    BookBackupJsonKeys.schemaVersion: s.schemaVersion,
    BookBackupJsonKeys.exportedAt: s.exportedAt.toUtc().toIso8601String(),
    BookBackupJsonKeys.categories: s.categories.map(_categoryToMap).toList(),
    BookBackupJsonKeys.subcategories: s.subcategories.map(_subcategoryToMap).toList(),
    BookBackupJsonKeys.paymentInstruments:
        s.paymentInstruments.map(_paymentInstrumentToMap).toList(),
    BookBackupJsonKeys.expenses: s.expenses.map(_expenseToMap).toList(),
  };
}

Map<String, dynamic> _categoryToMap(Category c) {
  return <String, dynamic>{
    'id': c.id,
    'name': c.name,
    'description': c.description,
    'sortOrder': c.sortOrder,
  };
}

Category _categoryFromJson(dynamic e) {
  if (e is! Map<String, dynamic>) {
    throw const FormatException('category entry must be an object');
  }
  final id = e['id'];
  final name = e['name'];
  final sortOrder = e['sortOrder'];
  if (id is! String || id.isEmpty) {
    throw const FormatException('category.id');
  }
  if (name is! String) {
    throw const FormatException('category.name');
  }
  if (sortOrder is! int) {
    throw const FormatException('category.sortOrder');
  }
  final desc = e['description'];
  return Category(
    id: id,
    name: name,
    description: desc is String ? desc : null,
    sortOrder: sortOrder,
  );
}

Map<String, dynamic> _subcategoryToMap(Subcategory s) {
  return <String, dynamic>{
    'id': s.id,
    'categoryId': s.categoryId,
    'name': s.name,
    'description': s.description,
    'slug': s.slug,
    'isSystemReserved': s.isSystemReserved,
    'sortOrder': s.sortOrder,
  };
}

Subcategory _subcategoryFromJson(dynamic e) {
  if (e is! Map<String, dynamic>) {
    throw const FormatException('subcategory entry must be an object');
  }
  final id = e['id'];
  final categoryId = e['categoryId'];
  final name = e['name'];
  final slug = e['slug'];
  final sortOrder = e['sortOrder'];
  final isRes = e['isSystemReserved'];
  if (id is! String ||
      categoryId is! String ||
      name is! String ||
      slug is! String ||
      sortOrder is! int ||
      isRes is! bool) {
    throw const FormatException('subcategory fields');
  }
  final desc = e['description'];
  return Subcategory(
    id: id,
    categoryId: categoryId,
    name: name,
    description: desc is String ? desc : null,
    slug: slug,
    isSystemReserved: isRes,
    sortOrder: sortOrder,
  );
}

Map<String, dynamic> _paymentInstrumentToMap(PaymentInstrument p) {
  return <String, dynamic>{
    'id': p.id,
    'label': p.label,
    'bankName': p.bankName,
    'billingCycleDay': p.billingCycleDay,
    'annualFeeAmount': p.annualFeeAmount,
    'monthlyFeeAmount': p.monthlyFeeAmount,
    'feeDescription': p.feeDescription,
  };
}

PaymentInstrument _paymentInstrumentFromJson(dynamic e) {
  if (e is! Map<String, dynamic>) {
    throw const FormatException('paymentInstrument entry must be an object');
  }
  final id = e['id'];
  final label = e['label'];
  if (id is! String || label is! String) {
    throw const FormatException('paymentInstrument id/label');
  }
  return PaymentInstrument(
    id: id,
    label: label,
    bankName: e['bankName'] as String?,
    billingCycleDay: e['billingCycleDay'] as int?,
    annualFeeAmount: (e['annualFeeAmount'] as num?)?.toDouble(),
    monthlyFeeAmount: (e['monthlyFeeAmount'] as num?)?.toDouble(),
    feeDescription: e['feeDescription'] as String?,
  );
}

Map<String, dynamic> _expenseToMap(Expense x) {
  return <String, dynamic>{
    'id': x.id,
    'occurredOn': ExpenseDates.toStorageDate(x.occurredOn),
    'categoryId': x.categoryId,
    'subcategoryId': x.subcategoryId,
    'amountOriginal': x.amountOriginal,
    'currencyCode': x.currencyCode,
    'manualFxRateToUsd': x.manualFxRateToUsd,
    'amountUsd': x.amountUsd,
    'paidWithCreditCard': x.paidWithCreditCard,
    'description': x.description,
    'paymentInstrumentId': x.paymentInstrumentId,
  };
}

Expense _expenseFromJson(dynamic e) {
  if (e is! Map<String, dynamic>) {
    throw const FormatException('expense entry must be an object');
  }
  final id = e['id'];
  final occurredOn = e['occurredOn'];
  final categoryId = e['categoryId'];
  final subcategoryId = e['subcategoryId'];
  final amountOriginal = e['amountOriginal'];
  final currencyCode = e['currencyCode'];
  final manualFx = e['manualFxRateToUsd'];
  final amountUsd = e['amountUsd'];
  final paidCard = e['paidWithCreditCard'];
  if (id is! String ||
      occurredOn is! String ||
      categoryId is! String ||
      subcategoryId is! String ||
      amountOriginal is! num ||
      currencyCode is! String ||
      manualFx is! num ||
      amountUsd is! num ||
      paidCard is! bool) {
    throw const FormatException('expense required fields');
  }
  final desc = e['description'];
  final pi = e['paymentInstrumentId'];
  return Expense(
    id: id,
    occurredOn: ExpenseDates.fromStorageDate(occurredOn),
    categoryId: categoryId,
    subcategoryId: subcategoryId,
    amountOriginal: amountOriginal.toDouble(),
    currencyCode: currencyCode,
    manualFxRateToUsd: manualFx.toDouble(),
    amountUsd: amountUsd.toDouble(),
    paidWithCreditCard: paidCard,
    description: desc is String ? desc : '',
    paymentInstrumentId: pi is String ? pi : null,
  );
}
