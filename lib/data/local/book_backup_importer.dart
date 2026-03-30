import 'dart:convert';

import 'package:drift/drift.dart';

import 'package:expense_app/application/book_backup_snapshot.dart';
import 'package:expense_app/application/recurrence_json_codec.dart';
import 'package:expense_app/data/local/app_database.dart';
import 'package:expense_app/data/local/income_category_seed.dart';
import 'package:expense_app/domain/domain.dart';

/// Result of [sanitizeBookBackupForImport] when the file had inconsistent rows
/// (e.g. expenses pointing at deleted subcategories — possible without SQLite FK enforcement).
final class BookBackupSanitizeReport {
  const BookBackupSanitizeReport({
    required this.snapshot,
    required this.expensesSkipped,
    required this.paymentInstrumentLinksCleared,
    required this.subcategoriesDropped,
    required this.recurringSeriesSkipped,
    required this.recurringSeriesLinksCleared,
    required this.installmentLinksCleared,
    required this.incomeSkipped,
  });

  final BookBackupSnapshot snapshot;
  final int expensesSkipped;
  final int paymentInstrumentLinksCleared;
  final int subcategoriesDropped;
  final int recurringSeriesSkipped;
  final int recurringSeriesLinksCleared;
  final int installmentLinksCleared;
  final int incomeSkipped;

  bool get hadRepairs =>
      expensesSkipped > 0 ||
      paymentInstrumentLinksCleared > 0 ||
      subcategoriesDropped > 0 ||
      recurringSeriesSkipped > 0 ||
      recurringSeriesLinksCleared > 0 ||
      installmentLinksCleared > 0 ||
      incomeSkipped > 0;
}

/// Drops orphan subcategories and expenses with broken links; clears invalid
/// [Expense.paymentInstrumentId] instead of dropping the expense.
BookBackupSanitizeReport sanitizeBookBackupForImport(BookBackupSnapshot raw) {
  if (raw.categories.isEmpty) {
    throw ArgumentError('Backup must contain at least one category');
  }
  final catIds = raw.categories.map((c) => c.id).toSet();

  final keptSubs =
      raw.subcategories.where((s) => catIds.contains(s.categoryId)).toList();
  final subDropped = raw.subcategories.length - keptSubs.length;
  final subIds = keptSubs.map((s) => s.id).toSet();

  final piIds = raw.paymentInstruments.map((p) => p.id).toSet();

  final keptPlans = <InstallmentPlan>[];
  for (final p in raw.installmentPlans) {
    if (!catIds.contains(p.categoryId) || !subIds.contains(p.subcategoryId)) {
      continue;
    }
    final pip = p.paymentInstrumentId;
    if (pip != null && pip.isNotEmpty && !piIds.contains(pip)) {
      keptPlans.add(
        InstallmentPlan(
          id: p.id,
          paymentCount: p.paymentCount,
          intervalMonths: p.intervalMonths,
          anchorOccurredOn: p.anchorOccurredOn,
          categoryId: p.categoryId,
          subcategoryId: p.subcategoryId,
          paymentInstrumentId: null,
          perPaymentAmountOriginal: p.perPaymentAmountOriginal,
          currencyCode: p.currencyCode,
          manualFxRateToUsd: p.manualFxRateToUsd,
          perPaymentAmountUsd: p.perPaymentAmountUsd,
          description: p.description,
        ),
      );
    } else {
      keptPlans.add(p);
    }
  }
  final planIds = keptPlans.map((p) => p.id).toSet();

  final keptSeries = raw.expenseRecurringSeries.where((s) {
    return catIds.contains(s.categoryId) && subIds.contains(s.subcategoryId);
  }).toList();
  final seriesSkipped = raw.expenseRecurringSeries.length - keptSeries.length;
  final seriesIds = keptSeries.map((s) => s.id).toSet();

  final keptExpenses = <Expense>[];
  var expensesSkipped = 0;
  var paymentCleared = 0;
  var seriesLinksCleared = 0;
  var installmentLinksCleared = 0;

  for (final e in raw.expenses) {
    if (!catIds.contains(e.categoryId)) {
      expensesSkipped++;
      continue;
    }
    if (!subIds.contains(e.subcategoryId)) {
      expensesSkipped++;
      continue;
    }
    if (e.manualFxRateToUsd <= 0) {
      expensesSkipped++;
      continue;
    }
    Expense next = e;
    final pi = e.paymentInstrumentId;
    if (pi != null && pi.isNotEmpty && !piIds.contains(pi)) {
      next = next.copyWith(clearPaymentInstrumentId: true);
      paymentCleared++;
    }
    final rs = next.recurringSeriesId;
    if (rs != null && rs.isNotEmpty && !seriesIds.contains(rs)) {
      next = next.copyWith(clearRecurringSeriesId: true);
      seriesLinksCleared++;
    }
    final ipl = next.installmentPlanId;
    if (ipl != null && ipl.isNotEmpty && !planIds.contains(ipl)) {
      next = next.copyWith(clearInstallmentPlan: true, clearInstallmentIndex: true);
      installmentLinksCleared++;
    }
    keptExpenses.add(next);
  }

  final cleanedSeries = <ExpenseRecurringSeries>[];
  for (final s in keptSeries) {
    final pii = s.paymentInstrumentId;
    if (pii != null && pii.isNotEmpty && !piIds.contains(pii)) {
      cleanedSeries.add(s.copyWith(clearPaymentInstrumentId: true));
      paymentCleared++;
    } else {
      cleanedSeries.add(s);
    }
  }

  var incomeCats = raw.incomeCategories;
  var incomeSubs = raw.incomeSubcategories;
  if (incomeCats.isEmpty) {
    incomeCats = IncomeCategorySeeder.builtInIncomeCategories();
    incomeSubs = IncomeCategorySeeder.builtInIncomeSubcategories();
  }
  final incCatIds = incomeCats.map((c) => c.id).toSet();
  final keptIncSubs =
      incomeSubs.where((s) => incCatIds.contains(s.categoryId)).toList();
  final incSubIds = keptIncSubs.map((s) => s.id).toSet();

  final defIncCat = IncomeCategorySeeder.kMigrationDefaultCategoryId;
  final defIncSub = IncomeCategorySeeder.kMigrationDefaultSubcategoryId;

  final keptIncomeRecurring = <IncomeRecurringSeries>[];
  for (final s in raw.incomeRecurringSeries) {
    if (!incCatIds.contains(s.incomeCategoryId) ||
        !incSubIds.contains(s.incomeSubcategoryId) ||
        s.manualFxRateToUsd <= 0) {
      continue;
    }
    try {
      s.validate();
    } catch (_) {
      continue;
    }
    keptIncomeRecurring.add(s);
  }
  final incomeSeriesIds = keptIncomeRecurring.map((x) => x.id).toSet();

  final keptIncome = <IncomeEntry>[];
  var incomeSkipped = 0;
  for (final inc in raw.incomeEntries) {
    if (inc.manualFxRateToUsd <= 0) {
      incomeSkipped++;
      continue;
    }
    var catId = inc.incomeCategoryId;
    var subId = inc.incomeSubcategoryId;
    if (!incCatIds.contains(catId) || !incSubIds.contains(subId)) {
      catId = defIncCat;
      subId = defIncSub;
    }
    var next = inc.copyWith(incomeCategoryId: catId, incomeSubcategoryId: subId);
    final rec = next.recurringSeriesId;
    if (rec != null && rec.isNotEmpty && !incomeSeriesIds.contains(rec)) {
      next = next.copyWith(clearRecurringSeriesId: true, clearExpectation: true);
    }
    keptIncome.add(next);
  }

  final cleaned = BookBackupSnapshot(
    schemaVersion: BookBackupSnapshot.currentSchemaVersion,
    exportedAt: raw.exportedAt,
    categories: raw.categories,
    subcategories: keptSubs,
    incomeCategories: incomeCats,
    incomeSubcategories: keptIncSubs,
    paymentInstruments: raw.paymentInstruments,
    expenseRecurringSeries: cleanedSeries,
    expenses: keptExpenses,
    incomeEntries: keptIncome,
    incomeRecurringSeries: keptIncomeRecurring,
    installmentPlans: keptPlans,
    partialPayments: const [],
  );

  return BookBackupSanitizeReport(
    snapshot: cleaned,
    expensesSkipped: expensesSkipped,
    paymentInstrumentLinksCleared: paymentCleared,
    subcategoriesDropped: subDropped,
    recurringSeriesSkipped: seriesSkipped,
    recurringSeriesLinksCleared: seriesLinksCleared,
    installmentLinksCleared: installmentLinksCleared,
    incomeSkipped: incomeSkipped,
  );
}

/// Validates [snapshot] referential integrity before writing.
void validateBookBackupSnapshot(BookBackupSnapshot snapshot) {
  if (snapshot.categories.isEmpty) {
    throw ArgumentError('Backup must contain at least one category');
  }
  final catIds = snapshot.categories.map((c) => c.id).toSet();
  final subIds = <String>{};
  for (final s in snapshot.subcategories) {
    if (!catIds.contains(s.categoryId)) {
      throw ArgumentError(
        'Subcategory ${s.id} references missing category ${s.categoryId}',
      );
    }
    subIds.add(s.id);
  }
  final piIds = snapshot.paymentInstruments.map((p) => p.id).toSet();
  final planIds = <String>{};
  for (final p in snapshot.installmentPlans) {
    if (!catIds.contains(p.categoryId)) {
      throw ArgumentError('Installment plan ${p.id} references missing category');
    }
    if (!subIds.contains(p.subcategoryId)) {
      throw ArgumentError('Installment plan ${p.id} references missing subcategory');
    }
    final pip = p.paymentInstrumentId;
    if (pip != null && pip.isNotEmpty && !piIds.contains(pip)) {
      throw ArgumentError('Installment plan ${p.id} references missing payment instrument');
    }
    if (p.manualFxRateToUsd <= 0) {
      throw ArgumentError('Installment plan ${p.id} has invalid FX');
    }
    if (p.paymentCount < 2) {
      throw ArgumentError('Installment plan ${p.id} has invalid paymentCount');
    }
    planIds.add(p.id);
  }
  final incCatIds = snapshot.incomeCategories.map((c) => c.id).toSet();
  final incSubIds = <String>{};
  for (final s in snapshot.incomeSubcategories) {
    if (!incCatIds.contains(s.categoryId)) {
      throw ArgumentError(
        'Income subcategory ${s.id} references missing income category ${s.categoryId}',
      );
    }
    incSubIds.add(s.id);
  }
  final incomeSeriesIds = <String>{};
  for (final s in snapshot.incomeRecurringSeries) {
    if (!incCatIds.contains(s.incomeCategoryId)) {
      throw ArgumentError(
        'Income recurring series ${s.id} references missing income category',
      );
    }
    if (!incSubIds.contains(s.incomeSubcategoryId)) {
      throw ArgumentError(
        'Income recurring series ${s.id} references missing income subcategory',
      );
    }
    if (s.manualFxRateToUsd <= 0) {
      throw ArgumentError('Income recurring series ${s.id} has invalid FX');
    }
    s.validate();
    incomeSeriesIds.add(s.id);
  }
  for (final inc in snapshot.incomeEntries) {
    if (!incCatIds.contains(inc.incomeCategoryId)) {
      throw ArgumentError('Income ${inc.id} references missing income category');
    }
    if (!incSubIds.contains(inc.incomeSubcategoryId)) {
      throw ArgumentError('Income ${inc.id} references missing income subcategory');
    }
    if (inc.manualFxRateToUsd <= 0) {
      throw ArgumentError('Income ${inc.id} has invalid FX');
    }
    final irs = inc.recurringSeriesId;
    if (irs != null && irs.isNotEmpty && !incomeSeriesIds.contains(irs)) {
      throw ArgumentError('Income ${inc.id} references missing income recurring series');
    }
  }
  final seriesIds = <String>{};
  for (final s in snapshot.expenseRecurringSeries) {
    if (!catIds.contains(s.categoryId)) {
      throw ArgumentError('Recurring series ${s.id} references missing category');
    }
    if (!subIds.contains(s.subcategoryId)) {
      throw ArgumentError('Recurring series ${s.id} references missing subcategory');
    }
    final pi = s.paymentInstrumentId;
    if (pi != null && pi.isNotEmpty && !piIds.contains(pi)) {
      throw ArgumentError('Recurring series ${s.id} references missing payment instrument');
    }
    if (s.manualFxRateToUsd <= 0) {
      throw ArgumentError('Recurring series ${s.id} has invalid FX');
    }
    s.validate();
    seriesIds.add(s.id);
  }
  for (final e in snapshot.expenses) {
    if (!catIds.contains(e.categoryId)) {
      throw ArgumentError('Expense ${e.id} references missing category');
    }
    if (!subIds.contains(e.subcategoryId)) {
      throw ArgumentError('Expense ${e.id} references missing subcategory');
    }
    final pi = e.paymentInstrumentId;
    if (pi != null && pi.isNotEmpty && !piIds.contains(pi)) {
      throw ArgumentError('Expense ${e.id} references missing payment instrument');
    }
    if (e.manualFxRateToUsd <= 0) {
      throw ArgumentError('Expense ${e.id} has invalid FX');
    }
    final rs = e.recurringSeriesId;
    if (rs != null && rs.isNotEmpty && !seriesIds.contains(rs)) {
      throw ArgumentError('Expense ${e.id} references missing recurring series');
    }
    final ipl = e.installmentPlanId;
    if (ipl != null && ipl.isNotEmpty && !planIds.contains(ipl)) {
      throw ArgumentError('Expense ${e.id} references missing installment plan');
    }
  }
}

/// Replaces **all** book data with [snapshot]. Same destructive scope as reset + seed.
///
/// Always runs [sanitizeBookBackupForImport] first so legacy or inconsistent backups
/// (orphan expenses, bad card links) can still be restored.
Future<BookBackupSanitizeReport> importBookBackupReplacingAll(
  AppDatabase db,
  BookBackupSnapshot snapshot,
) async {
  final report = sanitizeBookBackupForImport(snapshot);
  validateBookBackupSnapshot(report.snapshot);
  final toImport = report.snapshot;
  await db.transaction(() async {
    await db.delete(db.expenses).go();
    await db.delete(db.incomeEntries).go();
    await db.delete(db.incomeRecSeries).go();
    await db.delete(db.recExpenseSeries).go();
    await db.delete(db.installmentPlans).go();
    await db.delete(db.paymentInstruments).go();
    await db.delete(db.subcategories).go();
    await db.delete(db.categories).go();
    await db.delete(db.incomeSubcategories).go();
    await db.delete(db.incomeCategories).go();

    await db.batch((b) {
      for (final c in toImport.categories) {
        b.insert(
          db.categories,
          CategoriesCompanion.insert(
            id: c.id,
            name: c.name,
            description: Value(c.description),
            sortOrder: Value(c.sortOrder),
            isActive: Value(c.isActive),
          ),
        );
      }
      for (final s in toImport.subcategories) {
        b.insert(
          db.subcategories,
          SubcategoriesCompanion.insert(
            id: s.id,
            categoryId: s.categoryId,
            name: s.name,
            description: Value(s.description),
            slug: s.slug,
            isSystemReserved: Value(s.isSystemReserved),
            sortOrder: Value(s.sortOrder),
            isActive: Value(s.isActive),
          ),
        );
      }
      for (final c in toImport.incomeCategories) {
        b.insert(
          db.incomeCategories,
          IncomeCategoriesCompanion.insert(
            id: c.id,
            name: c.name,
            description: Value(c.description),
            sortOrder: Value(c.sortOrder),
            isActive: Value(c.isActive),
          ),
        );
      }
      for (final s in toImport.incomeSubcategories) {
        b.insert(
          db.incomeSubcategories,
          IncomeSubcategoriesCompanion.insert(
            id: s.id,
            categoryId: s.categoryId,
            name: s.name,
            description: Value(s.description),
            slug: s.slug,
            isSystemReserved: Value(s.isSystemReserved),
            sortOrder: Value(s.sortOrder),
            isActive: Value(s.isActive),
          ),
        );
      }
      for (final p in toImport.paymentInstruments) {
        b.insert(
          db.paymentInstruments,
          PaymentInstrumentsCompanion.insert(
            id: p.id,
            label: p.label,
            bankName: Value(p.bankName),
            billingCycleDay: Value(p.billingCycleDay),
            annualFeeAmount: Value(p.annualFeeAmount),
            monthlyFeeAmount: Value(p.monthlyFeeAmount),
            feeDescription: Value(p.feeDescription ?? ''),
            isActive: Value(p.isActive),
            isDefault: Value(p.isDefault),
            statementClosingDay: Value(p.statementClosingDay),
            paymentDueDay: Value(p.paymentDueDay),
            nominalAprPercent: Value(p.nominalAprPercent),
            creditLimit: Value(p.creditLimit),
            displaySuffix: Value(p.displaySuffix),
          ),
        );
      }
      for (final pl in toImport.installmentPlans) {
        b.insert(
          db.installmentPlans,
          InstallmentPlansCompanion.insert(
            id: pl.id,
            paymentCount: pl.paymentCount,
            intervalMonths: Value(pl.intervalMonths),
            anchorOccurredOn: ExpenseDates.toStorageDate(pl.anchorOccurredOn),
            categoryId: pl.categoryId,
            subcategoryId: pl.subcategoryId,
            paymentInstrumentId: Value(pl.paymentInstrumentId),
            perPaymentAmountOriginal: pl.perPaymentAmountOriginal,
            currencyCode: Value(pl.currencyCode),
            manualFxRateToUsd: Value(pl.manualFxRateToUsd),
            perPaymentAmountUsd: pl.perPaymentAmountUsd,
            description: Value(pl.description),
          ),
        );
      }
      for (final s in toImport.expenseRecurringSeries) {
        final payload = encodeRecurrencePayload(
          rule: s.rule,
          endCondition: s.endCondition,
        );
        b.insert(
          db.recExpenseSeries,
          RecExpenseSeriesCompanion.insert(
            id: s.id,
            anchorOccurredOn: ExpenseDates.toStorageDate(s.anchorOccurredOn),
            recurrenceJson: jsonEncode(payload),
            horizonMonths: s.horizonMonths,
            categoryId: s.categoryId,
            subcategoryId: s.subcategoryId,
            amountOriginal: s.amountOriginal,
            amountUsd: s.amountUsd,
            active: Value(s.active),
            currencyCode: Value(s.currencyCode),
            manualFxRateToUsd: Value(s.manualFxRateToUsd),
            paidWithCreditCard: Value(s.paidWithCreditCard),
            description: Value(s.description),
            paymentInstrumentId: Value(s.paymentInstrumentId),
          ),
        );
      }
      for (final s in toImport.incomeRecurringSeries) {
        final payload = encodeRecurrencePayload(
          rule: s.rule,
          endCondition: s.endCondition,
        );
        b.insert(
          db.incomeRecSeries,
          IncomeRecSeriesCompanion.insert(
            id: s.id,
            anchorReceivedOn:
                ExpenseDates.toStorageDate(s.anchorReceivedOn),
            recurrenceJson: jsonEncode(payload),
            horizonMonths: s.horizonMonths,
            incomeCategoryId: s.incomeCategoryId,
            incomeSubcategoryId: s.incomeSubcategoryId,
            amountOriginal: s.amountOriginal,
            amountUsd: s.amountUsd,
            active: Value(s.active),
            currencyCode: Value(s.currencyCode),
            manualFxRateToUsd: Value(s.manualFxRateToUsd),
            description: Value(s.description),
          ),
        );
      }
      for (final inc in toImport.incomeEntries) {
        b.insert(
          db.incomeEntries,
          IncomeEntriesCompanion.insert(
            id: inc.id,
            receivedOn: ExpenseDates.toStorageDate(inc.receivedOn),
            incomeCategoryId: inc.incomeCategoryId,
            incomeSubcategoryId: inc.incomeSubcategoryId,
            amountOriginal: inc.amountOriginal,
            currencyCode: Value(inc.currencyCode),
            manualFxRateToUsd: Value(inc.manualFxRateToUsd),
            amountUsd: inc.amountUsd,
            description: Value(inc.description),
            recurringSeriesId: Value(inc.recurringSeriesId),
            expectationStatus: Value(inc.expectationStatus?.storageName),
            expectationConfirmedOn: Value(
              inc.expectationConfirmedOn != null
                  ? ExpenseDates.toStorageDate(inc.expectationConfirmedOn!)
                  : null,
            ),
          ),
        );
      }
      for (final e in toImport.expenses) {
        b.insert(
          db.expenses,
          ExpensesCompanion.insert(
            id: e.id,
            occurredOn: ExpenseDates.toStorageDate(e.occurredOn),
            categoryId: e.categoryId,
            subcategoryId: e.subcategoryId,
            amountOriginal: e.amountOriginal,
            currencyCode: Value(e.currencyCode),
            manualFxRateToUsd: Value(e.manualFxRateToUsd),
            amountUsd: e.amountUsd,
            paidWithCreditCard: Value(e.paidWithCreditCard),
            description: Value(e.description),
            paymentInstrumentId: Value(e.paymentInstrumentId),
            recurringSeriesId: Value(e.recurringSeriesId),
            paymentExpectationStatus: Value(e.paymentExpectationStatus?.storageName),
            paymentExpectationConfirmedOn: Value(
              e.paymentExpectationConfirmedOn != null
                  ? ExpenseDates.toStorageDate(e.paymentExpectationConfirmedOn!)
                  : null,
            ),
            installmentPlanId: Value(e.installmentPlanId),
            installmentIndex: Value(e.installmentIndex),
          ),
        );
      }
    });
  });
  return report;
}
