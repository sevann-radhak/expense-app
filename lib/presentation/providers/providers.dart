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

/// Month 1–12 within [selectedReportYearProvider] for report drill-downs.
final selectedReportDetailMonthProvider = StateProvider<int>((ref) {
  return DateTime.now().month;
});

/// Whether the category report uses the full year or a single month.
enum ReportCategoryPeriodScope { fullYear, singleMonth }

final reportCategoryPeriodScopeProvider =
    StateProvider<ReportCategoryPeriodScope>((ref) {
      return ReportCategoryPeriodScope.fullYear;
    });

/// Realized vs scheduled filter for Reports (local calendar date; see ARB footnote).
final reportExpenseInclusionProvider =
    StateProvider<ExpenseInclusion>((ref) => ExpenseInclusion.all);

/// Expenses for the selected report year and detail month (same bounds as Home month list).
final expensesForReportDetailMonthProvider = StreamProvider<List<Expense>>((
  ref,
) {
  final year = ref.watch(selectedReportYearProvider);
  final month = ref.watch(selectedReportDetailMonthProvider);
  final inc = ref.watch(reportExpenseInclusionProvider);
  return ref.watch(expenseRepositoryProvider).watchForMonth(year, month).map(
        (list) => applyExpenseInclusion(list, inc, calendarTodayLocal()),
      );
});

/// Expenses driving the category / % table (year vs single month).
final expensesForReportCategoryScopeProvider = StreamProvider<List<Expense>>((
  ref,
) {
  final inc = ref.watch(reportExpenseInclusionProvider);
  final scope = ref.watch(reportCategoryPeriodScopeProvider);
  final year = ref.watch(selectedReportYearProvider);
  final repo = ref.watch(expenseRepositoryProvider);
  final Stream<List<Expense>> base = scope == ReportCategoryPeriodScope.fullYear
      ? repo.watchForYear(year)
      : repo.watchForMonth(year, ref.watch(selectedReportDetailMonthProvider));
  return base.map(
    (list) => applyExpenseInclusion(list, inc, calendarTodayLocal()),
  );
});

final categoriesStreamProvider = StreamProvider<List<Category>>((ref) {
  return ref.watch(categoryRepositoryProvider).watchCategories();
});

final allSubcategoriesStreamProvider = StreamProvider<List<Subcategory>>((ref) {
  return ref.watch(categoryRepositoryProvider).watchAllSubcategories();
});

final expensesForSelectedMonthProvider = StreamProvider<List<Expense>>((ref) {
  final m = ref.watch(selectedMonthProvider);
  return ref.watch(expenseRepositoryProvider).watchForMonth(m.year, m.month);
});

final expensesForSelectedReportYearProvider = StreamProvider<List<Expense>>((
  ref,
) {
  final year = ref.watch(selectedReportYearProvider);
  final inc = ref.watch(reportExpenseInclusionProvider);
  return ref.watch(expenseRepositoryProvider).watchForYear(year).map(
        (list) => applyExpenseInclusion(list, inc, calendarTodayLocal()),
      );
});

final subcategoriesForCategoryProvider =
    StreamProvider.family<List<Subcategory>, String>((ref, categoryId) {
      return ref
          .watch(categoryRepositoryProvider)
          .watchSubcategories(categoryId);
    });

/// Active Reports tab: 0 Annual, 1 By month, 2 By category (drives CSV export scope).
final reportsExportTabIndexProvider = StateProvider<int>((ref) => 0);

/// Expenses for the current Reports tab, respecting year/month/category scope and inclusion filter.
final reportExportExpensesProvider = Provider<AsyncValue<List<Expense>>>((ref) {
  final tab = ref.watch(reportsExportTabIndexProvider);
  switch (tab) {
    case 0:
      return ref.watch(expensesForSelectedReportYearProvider);
    case 1:
      return ref.watch(expensesForReportDetailMonthProvider);
    case 2:
      return ref.watch(expensesForReportCategoryScopeProvider);
    default:
      return const AsyncValue.data(<Expense>[]);
  }
});

/// Updates report year and resets detail month when the year no longer matches “today”.
void bumpReportYear(WidgetRef ref, int delta) {
  final y = ref.read(selectedReportYearProvider) + delta;
  ref.read(selectedReportYearProvider.notifier).state = y;
  final now = DateTime.now();
  ref.read(selectedReportDetailMonthProvider.notifier).state = y == now.year
      ? now.month
      : 1;
}
