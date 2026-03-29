import 'package:drift/drift.dart';

import 'package:expense_app/application/book_backup_snapshot.dart';
import 'package:expense_app/data/local/app_database.dart';
import 'package:expense_app/domain/domain.dart';

/// Result of [sanitizeBookBackupForImport] when the file had inconsistent rows
/// (e.g. expenses pointing at deleted subcategories — possible without SQLite FK enforcement).
final class BookBackupSanitizeReport {
  const BookBackupSanitizeReport({
    required this.snapshot,
    required this.expensesSkipped,
    required this.paymentInstrumentLinksCleared,
    required this.subcategoriesDropped,
  });

  final BookBackupSnapshot snapshot;
  final int expensesSkipped;
  final int paymentInstrumentLinksCleared;
  final int subcategoriesDropped;

  bool get hadRepairs =>
      expensesSkipped > 0 ||
      paymentInstrumentLinksCleared > 0 ||
      subcategoriesDropped > 0;
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

  final keptExpenses = <Expense>[];
  var expensesSkipped = 0;
  var paymentCleared = 0;

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
    final pi = e.paymentInstrumentId;
    if (pi != null && pi.isNotEmpty && !piIds.contains(pi)) {
      keptExpenses.add(e.copyWith(clearPaymentInstrumentId: true));
      paymentCleared++;
    } else {
      keptExpenses.add(e);
    }
  }

  final cleaned = BookBackupSnapshot(
    schemaVersion: raw.schemaVersion,
    exportedAt: raw.exportedAt,
    categories: raw.categories,
    subcategories: keptSubs,
    paymentInstruments: raw.paymentInstruments,
    expenses: keptExpenses,
  );

  return BookBackupSanitizeReport(
    snapshot: cleaned,
    expensesSkipped: expensesSkipped,
    paymentInstrumentLinksCleared: paymentCleared,
    subcategoriesDropped: subDropped,
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
    await db.delete(db.paymentInstruments).go();
    await db.delete(db.subcategories).go();
    await db.delete(db.categories).go();

    await db.batch((b) {
      for (final c in toImport.categories) {
        b.insert(
          db.categories,
          CategoriesCompanion.insert(
            id: c.id,
            name: c.name,
            description: Value(c.description),
            sortOrder: Value(c.sortOrder),
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
          ),
        );
      }
    });
  });
  return report;
}
