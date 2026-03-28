import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_app/data/local/app_database.dart';
import 'package:expense_app/data/local/app_database_reset.dart';
import 'package:expense_app/data/local/default_fx_rates_loader.dart';
import 'package:expense_app/data/local/drift_category_repository.dart';
import 'package:expense_app/data/local/drift_expense_repository.dart';
import 'package:expense_app/domain/domain.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  throw StateError('Override appDatabaseProvider in main() or tests.');
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return DriftCategoryRepository(ref.watch(appDatabaseProvider));
});

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return DriftExpenseRepository(ref.watch(appDatabaseProvider));
});

/// Static FX table from assets (replace with API later).
final defaultFxCatalogProvider = FutureProvider<DefaultFxCatalog>((ref) {
  return loadDefaultFxCatalog();
});

/// Development-only: wipe expenses and categories, then re-seed taxonomy.
Future<void> resetLocalAppDatabase(WidgetRef ref) async {
  final db = ref.read(appDatabaseProvider);
  await resetLocalDatabaseToInitialState(db);
}

/// First day of the currently selected calendar month (local).
final selectedMonthProvider = StateProvider<DateTime>((ref) {
  final n = DateTime.now();
  return DateTime(n.year, n.month);
});

/// Calendar year for the Reports annual hub (local).
final selectedReportYearProvider = StateProvider<int>((ref) {
  return DateTime.now().year;
});

final categoriesStreamProvider = StreamProvider<List<Category>>((ref) {
  return ref.watch(categoryRepositoryProvider).watchCategories();
});

final allSubcategoriesStreamProvider = StreamProvider<List<Subcategory>>((ref) {
  return ref.watch(categoryRepositoryProvider).watchAllSubcategories();
});

final expensesForSelectedMonthProvider = StreamProvider<List<Expense>>((ref) {
  final m = ref.watch(selectedMonthProvider);
  return ref
      .watch(expenseRepositoryProvider)
      .watchForMonth(m.year, m.month);
});

final expensesForSelectedReportYearProvider =
    StreamProvider<List<Expense>>((ref) {
  final year = ref.watch(selectedReportYearProvider);
  return ref.watch(expenseRepositoryProvider).watchForYear(year);
});

final subcategoriesForCategoryProvider =
    StreamProvider.family<List<Subcategory>, String>((ref, categoryId) {
  return ref
      .watch(categoryRepositoryProvider)
      .watchSubcategories(categoryId);
});
