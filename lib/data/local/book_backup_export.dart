import 'package:drift/drift.dart';

import 'package:expense_app/application/book_backup_snapshot.dart';
import 'package:expense_app/data/local/app_database.dart';
import 'package:expense_app/data/local/expense_recurring_series_drift_mapper.dart';
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

  final categories = catRows
      .map(
        (r) => Category(
          id: r.id,
          name: r.name,
          description: r.description,
          sortOrder: r.sortOrder,
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
        ),
      )
      .toList();

  final catIds = categories.map((c) => c.id).toSet();
  final subIds = subcategories.map((s) => s.id).toSet();
  final piIds = paymentInstruments.map((p) => p.id).toSet();

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
    expenses.add(next);
  }

  return BookBackupSnapshot(
    schemaVersion: BookBackupSnapshot.currentSchemaVersion,
    exportedAt: DateTime.now().toUtc(),
    categories: categories,
    subcategories: subcategories,
    paymentInstruments: paymentInstruments,
    expenseRecurringSeries: expenseRecurringSeries,
    expenses: expenses,
  );
}
