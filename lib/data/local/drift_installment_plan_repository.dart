import 'package:drift/drift.dart';

import 'package:expense_app/data/local/app_database.dart';
import 'package:expense_app/data/local/drift_expense_repository.dart';
import 'package:expense_app/domain/domain.dart';

class DriftInstallmentPlanRepository implements InstallmentPlanRepository {
  DriftInstallmentPlanRepository(this._db);

  final AppDatabase _db;

  @override
  Future<void> createPlanWithExpenses({
    required InstallmentPlan plan,
    required List<Expense> expenseLegs,
  }) async {
    if (plan.paymentCount < 2) {
      throw ArgumentError.value(plan.paymentCount, 'paymentCount', 'must be >= 2');
    }
    if (expenseLegs.length != plan.paymentCount) {
      throw ArgumentError(
        'expenseLegs.length (${expenseLegs.length}) must equal paymentCount (${plan.paymentCount})',
      );
    }
    if (plan.manualFxRateToUsd <= 0) {
      throw ArgumentError('plan.manualFxRateToUsd must be positive');
    }
    await _db.transaction(() async {
      await _db.into(_db.installmentPlans).insert(
            InstallmentPlansCompanion.insert(
              id: plan.id,
              paymentCount: plan.paymentCount,
              intervalMonths: Value(plan.intervalMonths),
              anchorOccurredOn: ExpenseDates.toStorageDate(plan.anchorOccurredOn),
              categoryId: plan.categoryId,
              subcategoryId: plan.subcategoryId,
              paymentInstrumentId: Value(plan.paymentInstrumentId),
              perPaymentAmountOriginal: plan.perPaymentAmountOriginal,
              currencyCode: Value(plan.currencyCode),
              manualFxRateToUsd: Value(plan.manualFxRateToUsd),
              perPaymentAmountUsd: plan.perPaymentAmountUsd,
              description: Value(plan.description),
            ),
          );
      final repo = DriftExpenseRepository(_db);
      for (final e in expenseLegs) {
        await repo.create(e);
      }
    });
  }
}
