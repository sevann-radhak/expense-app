import 'dart:convert';

import 'package:expense_app/application/book_backup_snapshot.dart';
import 'package:expense_app/application/recurrence_json_codec.dart';
import 'package:expense_app/domain/domain.dart';

/// JSON keys for the backup document (stable for importers).
abstract final class BookBackupJsonKeys {
  static const schemaVersion = 'schemaVersion';
  static const exportedAt = 'exportedAt';
  static const categories = 'categories';
  static const subcategories = 'subcategories';
  static const paymentInstruments = 'paymentInstruments';
  static const expenseRecurringSeries = 'expenseRecurringSeries';
  static const expenses = 'expenses';
  static const incomeEntries = 'incomeEntries';
  static const installmentPlans = 'installmentPlans';
  static const partialPayments = 'partialPayments';
  static const incomeCategories = 'incomeCategories';
  static const incomeSubcategories = 'incomeSubcategories';
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
  if (v is! int || v < 1 || v > BookBackupSnapshot.currentSchemaVersion) {
    throw FormatException(
      'Unsupported backup schemaVersion: $v (expected 1–${BookBackupSnapshot.currentSchemaVersion})',
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

  List<IncomeCategory> incomeCategories = const [];
  List<IncomeSubcategory> incomeSubcategories = const [];
  final incCatRaw = root[BookBackupJsonKeys.incomeCategories];
  if (incCatRaw != null) {
    if (incCatRaw is! List) {
      throw const FormatException('incomeCategories must be an array');
    }
    incomeCategories = incCatRaw.map((e) => _incomeCategoryFromJson(e)).toList();
  }
  final incSubRaw = root[BookBackupJsonKeys.incomeSubcategories];
  if (incSubRaw != null) {
    if (incSubRaw is! List) {
      throw const FormatException('incomeSubcategories must be an array');
    }
    incomeSubcategories =
        incSubRaw.map((e) => _incomeSubcategoryFromJson(e)).toList();
  }

  final piList = root[BookBackupJsonKeys.paymentInstruments];
  if (piList is! List) {
    throw const FormatException('paymentInstruments must be an array');
  }
  final paymentInstruments = piList.map((e) => _paymentInstrumentFromJson(e)).toList();

  List<ExpenseRecurringSeries> expenseRecurringSeries = const [];
  if (v >= 2) {
    final sList = root[BookBackupJsonKeys.expenseRecurringSeries];
    if (sList is! List) {
      throw const FormatException('expenseRecurringSeries must be an array');
    }
    expenseRecurringSeries =
        sList.map((e) => _expenseRecurringSeriesFromJson(e)).toList();
  }

  final expList = root[BookBackupJsonKeys.expenses];
  if (expList is! List) {
    throw const FormatException('expenses must be an array');
  }
  final expenses = expList.map((e) => _expenseFromJson(e)).toList();

  List<IncomeEntry> incomeEntries = const [];
  final incRaw = root[BookBackupJsonKeys.incomeEntries];
  if (incRaw != null) {
    if (incRaw is! List) {
      throw const FormatException('incomeEntries must be an array');
    }
    incomeEntries = incRaw.map((e) => _incomeEntryFromJson(e)).toList();
  }

  List<InstallmentPlan> installmentPlans = const [];
  final instRaw = root[BookBackupJsonKeys.installmentPlans];
  if (instRaw != null) {
    if (instRaw is! List) {
      throw const FormatException('installmentPlans must be an array');
    }
    installmentPlans = instRaw.map((e) => _installmentPlanFromJson(e)).toList();
  }

  List<PartialPayment> partialPayments = const [];
  final partRaw = root[BookBackupJsonKeys.partialPayments];
  if (partRaw != null) {
    if (partRaw is! List) {
      throw const FormatException('partialPayments must be an array');
    }
    partialPayments = partRaw.map((e) => _partialPaymentFromJson(e)).toList();
  }

  return BookBackupSnapshot(
    schemaVersion: v,
    exportedAt: exportedAt,
    categories: categories,
    subcategories: subcategories,
    incomeCategories: incomeCategories,
    incomeSubcategories: incomeSubcategories,
    paymentInstruments: paymentInstruments,
    expenseRecurringSeries: expenseRecurringSeries,
    expenses: expenses,
    incomeEntries: incomeEntries,
    installmentPlans: installmentPlans,
    partialPayments: partialPayments,
  );
}

Map<String, dynamic> _snapshotToMap(BookBackupSnapshot s) {
  return <String, dynamic>{
    BookBackupJsonKeys.schemaVersion: s.schemaVersion,
    BookBackupJsonKeys.exportedAt: s.exportedAt.toUtc().toIso8601String(),
    BookBackupJsonKeys.categories: s.categories.map(_categoryToMap).toList(),
    BookBackupJsonKeys.subcategories: s.subcategories.map(_subcategoryToMap).toList(),
    BookBackupJsonKeys.incomeCategories:
        s.incomeCategories.map(_incomeCategoryToMap).toList(),
    BookBackupJsonKeys.incomeSubcategories:
        s.incomeSubcategories.map(_incomeSubcategoryToMap).toList(),
    BookBackupJsonKeys.paymentInstruments:
        s.paymentInstruments.map(_paymentInstrumentToMap).toList(),
    BookBackupJsonKeys.expenseRecurringSeries:
        s.expenseRecurringSeries.map(_expenseRecurringSeriesToMap).toList(),
    BookBackupJsonKeys.expenses: s.expenses.map(_expenseToMap).toList(),
    BookBackupJsonKeys.incomeEntries: s.incomeEntries.map(_incomeEntryToMap).toList(),
    BookBackupJsonKeys.installmentPlans:
        s.installmentPlans.map(_installmentPlanToMap).toList(),
    BookBackupJsonKeys.partialPayments:
        s.partialPayments.map(_partialPaymentToMap).toList(),
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

Map<String, dynamic> _incomeCategoryToMap(IncomeCategory c) {
  return <String, dynamic>{
    'id': c.id,
    'name': c.name,
    'description': c.description,
    'sortOrder': c.sortOrder,
  };
}

IncomeCategory _incomeCategoryFromJson(dynamic e) {
  if (e is! Map<String, dynamic>) {
    throw const FormatException('income category entry must be an object');
  }
  final id = e['id'];
  final name = e['name'];
  final sortOrder = e['sortOrder'];
  if (id is! String || id.isEmpty) {
    throw const FormatException('incomeCategory.id');
  }
  if (name is! String) {
    throw const FormatException('incomeCategory.name');
  }
  if (sortOrder is! int) {
    throw const FormatException('incomeCategory.sortOrder');
  }
  final desc = e['description'];
  return IncomeCategory(
    id: id,
    name: name,
    description: desc is String ? desc : null,
    sortOrder: sortOrder,
  );
}

Map<String, dynamic> _incomeSubcategoryToMap(IncomeSubcategory s) {
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

IncomeSubcategory _incomeSubcategoryFromJson(dynamic e) {
  if (e is! Map<String, dynamic>) {
    throw const FormatException('income subcategory entry must be an object');
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
    throw const FormatException('incomeSubcategory required fields');
  }
  final desc = e['description'];
  return IncomeSubcategory(
    id: id,
    categoryId: categoryId,
    name: name,
    description: desc is String ? desc : null,
    slug: slug,
    isSystemReserved: isRes,
    sortOrder: sortOrder,
  );
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
    'isActive': p.isActive,
    'isDefault': p.isDefault,
    'statementClosingDay': p.statementClosingDay,
    'paymentDueDay': p.paymentDueDay,
    'nominalAprPercent': p.nominalAprPercent,
    'creditLimit': p.creditLimit,
    'displaySuffix': p.displaySuffix,
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
  final isActive = e['isActive'];
  final isDefault = e['isDefault'];
  return PaymentInstrument(
    id: id,
    label: label,
    bankName: e['bankName'] as String?,
    billingCycleDay: e['billingCycleDay'] as int?,
    annualFeeAmount: (e['annualFeeAmount'] as num?)?.toDouble(),
    monthlyFeeAmount: (e['monthlyFeeAmount'] as num?)?.toDouble(),
    feeDescription: e['feeDescription'] as String?,
    isActive: isActive is bool ? isActive : true,
    isDefault: isDefault is bool ? isDefault : false,
    statementClosingDay: e['statementClosingDay'] as int?,
    paymentDueDay: e['paymentDueDay'] as int?,
    nominalAprPercent: (e['nominalAprPercent'] as num?)?.toDouble(),
    creditLimit: (e['creditLimit'] as num?)?.toDouble(),
    displaySuffix: e['displaySuffix'] as String?,
  );
}

Map<String, dynamic> _expenseRecurringSeriesToMap(ExpenseRecurringSeries s) {
  return <String, dynamic>{
    'id': s.id,
    'anchorOccurredOn': ExpenseDates.toStorageDate(s.anchorOccurredOn),
    'recurrence': encodeRecurrencePayload(
      rule: s.rule,
      endCondition: s.endCondition,
    ),
    'horizonMonths': s.horizonMonths,
    'active': s.active,
    'categoryId': s.categoryId,
    'subcategoryId': s.subcategoryId,
    'amountOriginal': s.amountOriginal,
    'currencyCode': s.currencyCode,
    'manualFxRateToUsd': s.manualFxRateToUsd,
    'amountUsd': s.amountUsd,
    'paidWithCreditCard': s.paidWithCreditCard,
    'description': s.description,
    'paymentInstrumentId': s.paymentInstrumentId,
  };
}

ExpenseRecurringSeries _expenseRecurringSeriesFromJson(dynamic e) {
  if (e is! Map<String, dynamic>) {
    throw const FormatException('expenseRecurringSeries entry must be an object');
  }
  final id = e['id'];
  final anchor = e['anchorOccurredOn'];
  final rec = e['recurrence'];
  final hm = e['horizonMonths'];
  final active = e['active'];
  final categoryId = e['categoryId'];
  final subcategoryId = e['subcategoryId'];
  final amountOriginal = e['amountOriginal'];
  final currencyCode = e['currencyCode'];
  final manualFx = e['manualFxRateToUsd'];
  final amountUsd = e['amountUsd'];
  final paidCard = e['paidWithCreditCard'];
  if (id is! String ||
      anchor is! String ||
      rec is! Map<String, dynamic> ||
      hm is! int ||
      active is! bool ||
      categoryId is! String ||
      subcategoryId is! String ||
      amountOriginal is! num ||
      currencyCode is! String ||
      manualFx is! num ||
      amountUsd is! num ||
      paidCard is! bool) {
    throw const FormatException('expenseRecurringSeries required fields');
  }
  final (rule, end) = decodeRecurrencePayloadMap(rec);
  final desc = e['description'];
  final pi = e['paymentInstrumentId'];
  return ExpenseRecurringSeries(
    id: id,
    anchorOccurredOn: ExpenseDates.fromStorageDate(anchor),
    rule: rule,
    endCondition: end,
    horizonMonths: hm,
    active: active,
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

Map<String, dynamic> _expenseToMap(Expense x) {
  final m = <String, dynamic>{
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
  final rs = x.recurringSeriesId;
  if (rs != null && rs.isNotEmpty) {
    m['recurringSeriesId'] = rs;
  }
  final ps = x.paymentExpectationStatus;
  if (ps != null) {
    m['paymentExpectationStatus'] = ps.storageName;
  }
  final pc = x.paymentExpectationConfirmedOn;
  if (pc != null) {
    m['paymentExpectationConfirmedOn'] = ExpenseDates.toStorageDate(pc);
  }
  final ip = x.installmentPlanId;
  if (ip != null && ip.isNotEmpty) {
    m['installmentPlanId'] = ip;
  }
  final ii = x.installmentIndex;
  if (ii != null) {
    m['installmentIndex'] = ii;
  }
  return m;
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
  final rs = e['recurringSeriesId'];
  final pxs = e['paymentExpectationStatus'];
  final pxc = e['paymentExpectationConfirmedOn'];
  final ipl = e['installmentPlanId'];
  final iix = e['installmentIndex'];
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
    recurringSeriesId: rs is String && rs.isNotEmpty ? rs : null,
    paymentExpectationStatus: pxs is String
        ? paymentExpectationStatusFromStorage(pxs)
        : null,
    paymentExpectationConfirmedOn: pxc is String && pxc.isNotEmpty
        ? ExpenseDates.fromStorageDate(pxc)
        : null,
    installmentPlanId: ipl is String && ipl.isNotEmpty ? ipl : null,
    installmentIndex: iix is int ? iix : (iix is num ? iix.toInt() : null),
  );
}

Map<String, dynamic> _incomeEntryToMap(IncomeEntry x) {
  return <String, dynamic>{
    'id': x.id,
    'receivedOn': ExpenseDates.toStorageDate(x.receivedOn),
    'incomeCategoryId': x.incomeCategoryId,
    'incomeSubcategoryId': x.incomeSubcategoryId,
    'amountOriginal': x.amountOriginal,
    'currencyCode': x.currencyCode,
    'manualFxRateToUsd': x.manualFxRateToUsd,
    'amountUsd': x.amountUsd,
    'description': x.description,
  };
}

IncomeEntry _incomeEntryFromJson(dynamic e) {
  if (e is! Map<String, dynamic>) {
    throw const FormatException('income entry must be an object');
  }
  final id = e['id'];
  final receivedOn = e['receivedOn'];
  final incomeCategoryId = e['incomeCategoryId'] ?? e['categoryId'];
  final incomeSubcategoryId = e['incomeSubcategoryId'] ?? e['subcategoryId'];
  final amountOriginal = e['amountOriginal'];
  final currencyCode = e['currencyCode'];
  final manualFx = e['manualFxRateToUsd'];
  final amountUsd = e['amountUsd'];
  if (id is! String ||
      receivedOn is! String ||
      incomeCategoryId is! String ||
      incomeSubcategoryId is! String ||
      amountOriginal is! num ||
      currencyCode is! String ||
      manualFx is! num ||
      amountUsd is! num) {
    throw const FormatException('income required fields');
  }
  final desc = e['description'];
  return IncomeEntry(
    id: id,
    receivedOn: ExpenseDates.fromStorageDate(receivedOn),
    incomeCategoryId: incomeCategoryId,
    incomeSubcategoryId: incomeSubcategoryId,
    amountOriginal: amountOriginal.toDouble(),
    currencyCode: currencyCode,
    manualFxRateToUsd: manualFx.toDouble(),
    amountUsd: amountUsd.toDouble(),
    description: desc is String ? desc : '',
  );
}

Map<String, dynamic> _installmentPlanToMap(InstallmentPlan p) {
  return <String, dynamic>{
    'id': p.id,
    'paymentCount': p.paymentCount,
    'intervalMonths': p.intervalMonths,
    'anchorOccurredOn': ExpenseDates.toStorageDate(p.anchorOccurredOn),
    'categoryId': p.categoryId,
    'subcategoryId': p.subcategoryId,
    'paymentInstrumentId': p.paymentInstrumentId,
    'perPaymentAmountOriginal': p.perPaymentAmountOriginal,
    'currencyCode': p.currencyCode,
    'manualFxRateToUsd': p.manualFxRateToUsd,
    'perPaymentAmountUsd': p.perPaymentAmountUsd,
    'description': p.description,
  };
}

InstallmentPlan _installmentPlanFromJson(dynamic e) {
  if (e is! Map<String, dynamic>) {
    throw const FormatException('installmentPlan entry must be an object');
  }
  final id = e['id'];
  final pc = e['paymentCount'];
  final im = e['intervalMonths'];
  final anchor = e['anchorOccurredOn'];
  final categoryId = e['categoryId'];
  final subcategoryId = e['subcategoryId'];
  final ppo = e['perPaymentAmountOriginal'];
  final currencyCode = e['currencyCode'];
  final manualFx = e['manualFxRateToUsd'];
  final ppusd = e['perPaymentAmountUsd'];
  if (id is! String ||
      pc is! int ||
      anchor is! String ||
      categoryId is! String ||
      subcategoryId is! String ||
      ppo is! num ||
      currencyCode is! String ||
      manualFx is! num ||
      ppusd is! num) {
    throw const FormatException('installmentPlan required fields');
  }
  final interval = im is int ? im : (im is num ? im.toInt() : 1);
  final pi = e['paymentInstrumentId'];
  final desc = e['description'];
  return InstallmentPlan(
    id: id,
    paymentCount: pc,
    intervalMonths: interval < 1 ? 1 : interval,
    anchorOccurredOn: ExpenseDates.fromStorageDate(anchor),
    categoryId: categoryId,
    subcategoryId: subcategoryId,
    paymentInstrumentId: pi is String ? pi : null,
    perPaymentAmountOriginal: ppo.toDouble(),
    currencyCode: currencyCode,
    manualFxRateToUsd: manualFx.toDouble(),
    perPaymentAmountUsd: ppusd.toDouble(),
    description: desc is String ? desc : '',
  );
}

Map<String, dynamic> _partialPaymentToMap(PartialPayment p) {
  return <String, dynamic>{
    'id': p.id,
    'expenseId': p.expenseId,
    'amountUsd': p.amountUsd,
    'paidOn': ExpenseDates.toStorageDate(p.paidOn),
    'note': p.note,
  };
}

PartialPayment _partialPaymentFromJson(dynamic e) {
  if (e is! Map<String, dynamic>) {
    throw const FormatException('partialPayment entry must be an object');
  }
  final id = e['id'];
  final expenseId = e['expenseId'];
  final amountUsd = e['amountUsd'];
  final paidOn = e['paidOn'];
  if (id is! String || expenseId is! String || amountUsd is! num || paidOn is! String) {
    throw const FormatException('partialPayment required fields');
  }
  final note = e['note'];
  return PartialPayment(
    id: id,
    expenseId: expenseId,
    amountUsd: amountUsd.toDouble(),
    paidOn: ExpenseDates.fromStorageDate(paidOn),
    note: note is String ? note : '',
  );
}
