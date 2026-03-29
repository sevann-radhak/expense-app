import 'package:expense_app/domain/expense.dart';
import 'package:expense_app/domain/installment_plan.dart';

/// Creates a plan row and materialized [Expense] legs in one transaction.
abstract class InstallmentPlanRepository {
  /// [firstPaymentAmount] is the amount for each leg (equal split).
  Future<void> createPlanWithExpenses({
    required InstallmentPlan plan,
    required List<Expense> expenseLegs,
  });
}
