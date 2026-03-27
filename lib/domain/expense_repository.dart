import 'package:expense_app/domain/expense.dart';

/// Thrown when [Expense.subcategoryId] does not belong to [Expense.categoryId].
class InvalidSubcategoryPairingException implements Exception {
  InvalidSubcategoryPairingException(this.message);
  final String message;

  @override
  String toString() => 'InvalidSubcategoryPairingException: $message';
}

/// Persistence port for expenses.
abstract class ExpenseRepository {
  /// Expenses with [Expense.occurredOn] in the given **local** calendar month.
  Stream<List<Expense>> watchForMonth(int year, int month);

  Future<void> create(Expense expense);

  Future<void> update(Expense expense);

  Future<void> delete(String id);
}
