import 'package:drift/drift.dart';

import 'package:expense_app/application/book_backup_snapshot.dart';
import 'package:expense_app/data/local/app_database.dart';
import 'package:expense_app/data/local/expense_recurring_series_drift_mapper.dart';
import 'package:expense_app/data/local/income_recurring_series_drift_mapper.dart';
import 'package:expense_app/domain/domain.dart';

/// Reads the full Drift book into a [BookBackupSnapshot].
Future<BookBackupSnapshot> exportFullBookSnapshot(AppDatabase db) async {
  final catRows = await (db.select(db.categories)
        ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
      .get();
  final subRows = await (db.select(db.subcategories)
        ..orderBy([
          (t) => OrderingTerm.asc(t.categoryId),
          (t) => OrderingTerm.asc(t.sortOrder),
        ]))
      .get();
  final piRows = await (db.select(db.paymentInstruments)
        ..orderBy([(t) => OrderingTerm.asc(t.label)]))
      .get();
  final seriesRows = await (db.select(db.recExpenseSeries)
        ..orderBy([(t) => OrderingTerm.asc(t.id)]))
      .get();
  final expRows = await (db.select(db.expenses)
        ..orderBy([
          (t) => OrderingTerm.asc(t.occurredOn),
          (t) => OrderingTerm.asc(t.id),
        ]))
      .get();
  final planRows = await (db.select(db.installmentPlans)
        ..orderBy([(t) => OrderingTerm.asc(t.id)]))
      .get();
  final incomeRows = await (db.select(db.incomeEntries)
        ..orderBy([
          (t) => OrderingTerm.asc(t.receivedOn),
          (t) => OrderingTerm.asc(t.id),
        ]))
      .get();
  final incCatRows = await (db.select(db.incomeCategories)
        ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
      .get();
  final incSubRows = await (db.select(db.incomeSubcategories)
        ..orderBy([
          (t) => OrderingTerm.asc(t.categoryId),
          (t) => OrderingTerm.asc(t.sortOrder),
        ]))
      .get();
  final incSeriesRows = await (db.select(db.incomeRecSeries)
        ..orderBy([(t) => OrderingTerm.asc(t.id)]))
      .get();

  final categories = catRows
      .map(
        (r) => Category(
          id: r.id,
          name: r.name,
          description: r.description,
          sortOrder: r.sortOrder,
          isActive: r.isActive,
        ),
      )
      .toList();

  final subcategories = subRows
      .map(
        (r) => Subcategory(
          id: r.id,
          categoryId: r.categoryId,
          name: r.name,
          description: r.description,
          slug: r.slug,
          isSystemReserved: r.isSystemReserved,
          sortOrder: r.sortOrder,
          isActive: r.isActive,
        ),
      )
      .toList();

  final paymentInstruments = piRows
      .map(
        (r) => PaymentInstrument(
          id: r.id,
          label: r.label,
          bankName: r.bankName,
          billingCycleDay: r.billingCycleDay,
          annualFeeAmount: r.annualFeeAmount,
          monthlyFeeAmount: r.monthlyFeeAmount,
          feeDescription: r.feeDescription.isEmpty ? null : r.feeDescription,
          isActive: r.isActive,
          isDefault: r.isDefault,
          statementClosingDay: r.statementClosingDay,
          paymentDueDay: r.paymentDueDay,
          nominalAprPercent: r.nominalAprPercent,
          creditLimit: r.creditLimit,
          displaySuffix: r.displaySuffix,
        ),
      )
      .toList();

  final expenseRecurringSeriesRaw = seriesRows
      .map(expenseRecurringSeriesFromDriftRow)
      .toList();

  final expensesRaw = expRows
      .map(
        (r) => Expense(
          id: r.id,
          occurredOn: ExpenseDates.fromStorageDate(r.occurredOn),
          categoryId: r.categoryId,
          subcategoryId: r.subcategoryId,
          amountOriginal: r.amountOriginal,
          currencyCode: r.currencyCode,
          manualFxRateToUsd: r.manualFxRateToUsd,
          amountUsd: r.amountUsd,
          paidWithCreditCard: r.paidWithCreditCard,
          description: r.description,
          paymentInstrumentId: r.paymentInstrumentId,
          recurringSeriesId: r.recurringSeriesId,
          paymentExpectationStatus:
              paymentExpectationStatusFromStorage(r.paymentExpectationStatus),
          paymentExpectationConfirmedOn:
              r.paymentExpectationConfirmedOn != null &&
                      r.paymentExpectationConfirmedOn!.isNotEmpty
                  ? ExpenseDates.fromStorageDate(r.paymentExpectationConfirmedOn!)
                  : null,
          installmentPlanId: r.installmentPlanId,
          installmentIndex: r.installmentIndex,
        ),
      )
      .toList();

  final incomeCategories = incCatRows
      .map(
        (r) => IncomeCategory(
          id: r.id,
          name: r.name,
          description: r.description,
          sortOrder: r.sortOrder,
          isActive: r.isActive,
        ),
      )
      .toList();
  final incomeSubcategories = incSubRows
      .map(
        (r) => IncomeSubcategory(
          id: r.id,
          categoryId: r.categoryId,
          name: r.name,
          description: r.description,
          slug: r.slug,
          isSystemReserved: r.isSystemReserved,
          sortOrder: r.sortOrder,
          isActive: r.isActive,
        ),
      )
      .toList();

  final catIds = categories.map((c) => c.id).toSet();
  final subIds = subcategories.map((s) => s.id).toSet();
  final incCatIds = incomeCategories.map((c) => c.id).toSet();
  final incSubIds = incomeSubcategories.map((s) => s.id).toSet();

  final incomeRecurringSeriesRaw =
      incSeriesRows.map(incomeRecurringSeriesFromDriftRow).toList();
  final incomeRecurringSeries = <IncomeRecurringSeries>[];
  for (final s in incomeRecurringSeriesRaw) {
    if (!incCatIds.contains(s.incomeCategoryId) ||
        !incSubIds.contains(s.incomeSubcategoryId)) {
      continue;
    }
    if (s.manualFxRateToUsd <= 0) {
      continue;
    }
    incomeRecurringSeries.add(s);
  }
  final incomeSeriesIds = incomeRecurringSeries.map((s) => s.id).toSet();
  final piIds = paymentInstruments.map((p) => p.id).toSet();

  final installmentPlansRaw = planRows
      .map(
        (r) => InstallmentPlan(
          id: r.id,
          paymentCount: r.paymentCount,
          intervalMonths: r.intervalMonths,
          anchorOccurredOn: ExpenseDates.fromStorageDate(r.anchorOccurredOn),
          categoryId: r.categoryId,
          subcategoryId: r.subcategoryId,
          paymentInstrumentId: r.paymentInstrumentId,
          perPaymentAmountOriginal: r.perPaymentAmountOriginal,
          currencyCode: r.currencyCode,
          manualFxRateToUsd: r.manualFxRateToUsd,
          perPaymentAmountUsd: r.perPaymentAmountUsd,
          description: r.description,
        ),
      )
      .toList();

  final installmentPlans = <InstallmentPlan>[];
  for (final p in installmentPlansRaw) {
    if (!catIds.contains(p.categoryId) || !subIds.contains(p.subcategoryId)) {
      continue;
    }
    final pip = p.paymentInstrumentId;
    if (pip != null && pip.isNotEmpty && !piIds.contains(pip)) {
      installmentPlans.add(
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
      installmentPlans.add(p);
    }
  }
  final planIds = installmentPlans.map((p) => p.id).toSet();

  final incomeEntriesRaw = incomeRows
      .map(
        (r) => IncomeEntry(
          id: r.id,
          receivedOn: ExpenseDates.fromStorageDate(r.receivedOn),
          incomeCategoryId: r.incomeCategoryId,
          incomeSubcategoryId: r.incomeSubcategoryId,
          amountOriginal: r.amountOriginal,
          currencyCode: r.currencyCode,
          manualFxRateToUsd: r.manualFxRateToUsd,
          amountUsd: r.amountUsd,
          description: r.description,
          recurringSeriesId: r.recurringSeriesId,
          expectationStatus:
              paymentExpectationStatusFromStorage(r.expectationStatus),
          expectationConfirmedOn:
              r.expectationConfirmedOn != null &&
                      r.expectationConfirmedOn!.isNotEmpty
                  ? ExpenseDates.fromStorageDate(r.expectationConfirmedOn!)
                  : null,
        ),
      )
      .toList();

  final incomeEntries = <IncomeEntry>[];
  for (final inc in incomeEntriesRaw) {
    if (!incCatIds.contains(inc.incomeCategoryId) ||
        !incSubIds.contains(inc.incomeSubcategoryId)) {
      continue;
    }
    if (inc.manualFxRateToUsd <= 0) {
      continue;
    }
    var next = inc;
    final rs = inc.recurringSeriesId;
    if (rs != null && rs.isNotEmpty && !incomeSeriesIds.contains(rs)) {
      next = next.copyWith(clearRecurringSeriesId: true, clearExpectation: true);
    }
    incomeEntries.add(next);
  }

  final expenseRecurringSeries = <ExpenseRecurringSeries>[];
  for (final s in expenseRecurringSeriesRaw) {
    if (!catIds.contains(s.categoryId)) {
      continue;
    }
    if (!subIds.contains(s.subcategoryId)) {
      continue;
    }
    final pi = s.paymentInstrumentId;
    if (pi != null && pi.isNotEmpty && !piIds.contains(pi)) {
      expenseRecurringSeries.add(s.copyWith(clearPaymentInstrumentId: true));
    } else {
      expenseRecurringSeries.add(s);
    }
  }

  final seriesIds = expenseRecurringSeries.map((s) => s.id).toSet();

  final expenses = <Expense>[];
  for (final e in expensesRaw) {
    if (!catIds.contains(e.categoryId)) {
      continue;
    }
    if (!subIds.contains(e.subcategoryId)) {
      continue;
    }
    if (e.manualFxRateToUsd <= 0) {
      continue;
    }
    var next = e;
    final pi = e.paymentInstrumentId;
    if (pi != null && pi.isNotEmpty && !piIds.contains(pi)) {
      next = next.copyWith(clearPaymentInstrumentId: true);
    }
    final rs = next.recurringSeriesId;
    if (rs != null && rs.isNotEmpty && !seriesIds.contains(rs)) {
      next = next.copyWith(clearRecurringSeriesId: true);
    }
    final ipl = next.installmentPlanId;
    if (ipl != null && ipl.isNotEmpty && !planIds.contains(ipl)) {
      next = next.copyWith(clearInstallmentPlan: true, clearInstallmentIndex: true);
    }
    expenses.add(next);
  }

  return BookBackupSnapshot(
    schemaVersion: BookBackupSnapshot.currentSchemaVersion,
    exportedAt: DateTime.now().toUtc(),
    categories: categories,
    subcategories: subcategories,
    incomeCategories: incomeCategories,
    incomeSubcategories: incomeSubcategories,
    paymentInstruments: paymentInstruments,
    expenseRecurringSeries: expenseRecurringSeries,
    expenses: expenses,
    incomeEntries: incomeEntries,
    incomeRecurringSeries: incomeRecurringSeries,
    installmentPlans: installmentPlans,
    partialPayments: const [],
  );
}
