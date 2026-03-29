import 'package:expense_app/domain/domain.dart';

/// Full local book export (categories, subcategories, instruments, series, expenses).
///
/// [schemaVersion] is bumped when the JSON shape changes.
final class BookBackupSnapshot {
  const BookBackupSnapshot({
    required this.schemaVersion,
    required this.exportedAt,
    required this.categories,
    required this.subcategories,
    this.incomeCategories = const [],
    this.incomeSubcategories = const [],
    required this.paymentInstruments,
    required this.expenseRecurringSeries,
    required this.expenses,
    required this.incomeEntries,
    this.incomeRecurringSeries = const [],
    required this.installmentPlans,
    required this.partialPayments,
  });

  static const int currentSchemaVersion = 8;

  final int schemaVersion;
  final DateTime exportedAt;
  final List<Category> categories;
  final List<Subcategory> subcategories;
  final List<IncomeCategory> incomeCategories;
  final List<IncomeSubcategory> incomeSubcategories;
  final List<PaymentInstrument> paymentInstruments;
  final List<ExpenseRecurringSeries> expenseRecurringSeries;
  final List<Expense> expenses;
  final List<IncomeEntry> incomeEntries;
  final List<IncomeRecurringSeries> incomeRecurringSeries;
  final List<InstallmentPlan> installmentPlans;

  /// Reserved for Phase 5+; export uses an empty array in Phase 4.8.
  final List<PartialPayment> partialPayments;
}
