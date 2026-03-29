import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:expense_app/application/application.dart';
import 'package:expense_app/data/local/book_backup_export.dart';
import 'package:expense_app/domain/domain.dart';
import 'package:expense_app/l10n/app_localizations.dart';
import 'package:expense_app/presentation/expenses/expense_summary_list_tile.dart';
import 'package:expense_app/presentation/formatting/currency_display.dart';
import 'package:expense_app/presentation/home/expense_form_dialog.dart';
import 'package:expense_app/presentation/income/income_form_dialog.dart';
import 'package:expense_app/presentation/incomes/income_summary_list_tile.dart';
import 'package:expense_app/presentation/incomes/recurring_income_menu_handler.dart';
import 'package:expense_app/presentation/providers/providers.dart';
import 'package:expense_app/presentation/reports/report_csv_download.dart';
import 'package:expense_app/presentation/reports/report_file_download.dart';
import 'package:expense_app/presentation/reports/reports_category_pie_chart.dart';
import 'package:expense_app/presentation/reports/reports_monthly_cashflow_bar_chart.dart';

String _reportCsvFilename({
  required int tabIndex,
  required int year,
  required int month,
  required ReportCategoryPeriodScope categoryScope,
}) {
  final mm = month.toString().padLeft(2, '0');
  switch (tabIndex) {
    case 0:
      return 'report_annual_$year.csv';
    case 1:
      return 'report_month_${year}_$mm.csv';
    case 2:
      if (categoryScope == ReportCategoryPeriodScope.fullYear) {
        return 'report_by_category_year_$year.csv';
      }
      return 'report_by_category_${year}_$mm.csv';
    default:
      return 'report_export.csv';
  }
}

enum _ReportsExportFormat { csv, json }

Future<void> _handleReportsJsonExport(
  BuildContext context,
  WidgetRef ref,
  AppLocalizations l10n,
) async {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (!kIsWeb) {
    messenger?.showSnackBar(
      SnackBar(content: Text(l10n.reportsExportJsonWebOnly)),
    );
    return;
  }
  try {
    final db = ref.read(appDatabaseProvider);
    final snap = await exportFullBookSnapshot(db);
    final json = encodeBookBackupPretty(snap);
    final ymd = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final filename = 'expense_book_backup_$ymd.json';
    triggerReportFileDownload(
      filename,
      json,
      'application/json;charset=utf-8',
    );
    messenger?.showSnackBar(
      SnackBar(content: Text(l10n.reportsExportJsonSuccess)),
    );
  } on Object catch (e) {
    messenger?.showSnackBar(
      SnackBar(content: Text('${l10n.reportsExportJsonFailed}: $e')),
    );
  }
}

void _handleReportsCsvExport(
  BuildContext context,
  WidgetRef ref,
  AppLocalizations l10n,
) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  final async = ref.read(reportExportExpensesProvider);
  async.when(
    data: (expenses) {
      final categories = ref.read(categoriesStreamProvider).valueOrNull ?? [];
      final allSubs =
          ref.read(allSubcategoriesStreamProvider).valueOrNull ?? [];
      final categoryNames = {for (final c in categories) c.id: c.name};
      final subcategoryNames = {for (final s in allSubs) s.id: s.name};
      final year = ref.read(selectedReportYearProvider);
      final month = ref.read(selectedReportDetailMonthProvider);
      final scope = ref.read(reportCategoryPeriodScopeProvider);
      final tab = ref.read(reportsExportTabIndexProvider);
      final filename = _reportCsvFilename(
        tabIndex: tab,
        year: year,
        month: month,
        categoryScope: scope,
      );
      final csv = buildReportExpensesCsv(
        expenses: expenses,
        categoryNames: categoryNames,
        subcategoryNames: subcategoryNames,
        unknownCategoryLabel: l10n.taxonomyUnknownLabel,
        unknownSubcategoryLabel: l10n.taxonomyUnknownLabel,
      );
      if (!kIsWeb) {
        messenger?.showSnackBar(
          SnackBar(content: Text(l10n.reportsExportCsvUnavailable)),
        );
        return;
      }
      try {
        triggerReportCsvDownload(filename, csv);
        messenger?.showSnackBar(
          SnackBar(content: Text(l10n.reportsExportCsvSuccess)),
        );
      } catch (e) {
        messenger?.showSnackBar(
          SnackBar(
            content: Text('${l10n.reportsExportCsvFailed}: $e'),
          ),
        );
      }
    },
    loading: () {
      messenger?.showSnackBar(
        SnackBar(content: Text(l10n.reportsExportCsvLoading)),
      );
    },
    error: (e, _) {
      messenger?.showSnackBar(
        SnackBar(content: Text('${l10n.reportsExportCsvFailed}: $e')),
      );
    },
  );
}

class _ReportsExportMenuButton extends ConsumerWidget {
  const _ReportsExportMenuButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return PopupMenuButton<_ReportsExportFormat>(
      icon: const Icon(Icons.download_outlined),
      tooltip: l10n.reportsExportMenuTooltip,
      onSelected: (format) async {
        if (format == _ReportsExportFormat.csv) {
          _handleReportsCsvExport(context, ref, l10n);
        } else {
          await _handleReportsJsonExport(context, ref, l10n);
        }
      },
      itemBuilder: (ctx) => [
        PopupMenuItem(
          value: _ReportsExportFormat.csv,
          child: Text(l10n.reportsExportFormatCsv),
        ),
        PopupMenuItem(
          value: _ReportsExportFormat.json,
          child: Text(l10n.reportsExportFormatJson),
        ),
      ],
    );
  }
}

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_syncExportTabIndex);
  }

  void _syncExportTabIndex() {
    if (_tabController.indexIsChanging) {
      return;
    }
    ref.read(reportsExportTabIndexProvider.notifier).state =
        _tabController.index;
  }

  @override
  void dispose() {
    _tabController.removeListener(_syncExportTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.reportsTitle),
        actions: const [
          _ReportsExportMenuButton(),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: [
            Tab(text: l10n.reportsTabAnnual),
            Tab(text: l10n.reportsTabByMonth),
            Tab(text: l10n.reportsTabByCategory),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: _ReportYearStrip(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: _ReportExpenseInclusionStrip(),
          ),
          const Divider(height: 1),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                _ReportsAnnualTabBody(),
                _ReportsByMonthTabBody(),
                _ReportsByCategoryTabBody(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportExpenseInclusionStrip extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selected = ref.watch(reportExpenseInclusionProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SegmentedButton<ExpenseInclusion>(
          segments: [
            ButtonSegment<ExpenseInclusion>(
              value: ExpenseInclusion.all,
              label: Text(l10n.reportsExpenseInclusionAll),
            ),
            ButtonSegment<ExpenseInclusion>(
              value: ExpenseInclusion.realizedOnly,
              label: Text(l10n.reportsExpenseInclusionRealized),
            ),
            ButtonSegment<ExpenseInclusion>(
              value: ExpenseInclusion.scheduledOnly,
              label: Text(l10n.reportsExpenseInclusionScheduled),
            ),
          ],
          selected: {selected},
          onSelectionChanged: (next) {
            ref.read(reportExpenseInclusionProvider.notifier).state = next.single;
          },
        ),
        const SizedBox(height: 6),
        Text(
          l10n.reportsExpenseInclusionFootnote,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}

class _ReportYearStrip extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final year = ref.watch(selectedReportYearProvider);

    return Row(
      children: [
        IconButton(
          tooltip: l10n.reportsYearPickerPrevious,
          onPressed: () => bumpReportYear(ref, -1),
          icon: const Icon(Icons.chevron_left),
        ),
        Expanded(
          child: Text(
            year.toString(),
            key: const ValueKey<String>('selected-report-year-label'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        IconButton(
          tooltip: l10n.reportsYearPickerNext,
          onPressed: () => bumpReportYear(ref, 1),
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}

class _ReportsAnnualTabBody extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final year = ref.watch(selectedReportYearProvider);
    final expensesAsync = ref.watch(expensesForSelectedReportYearProvider);
    final incomeAsync = ref.watch(incomeForSelectedReportYearProvider);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        expensesAsync.when(
          data: (expenses) {
            return incomeAsync.when(
              data: (incomes) {
                final loc = Localizations.localeOf(context);
                final monthlyExpenseUsd =
                    monthlyUsdTotalsByCalendarMonth(expenses);
                final monthlyIncomeUsd =
                    monthlyUsdTotalsByCalendarMonthForIncome(incomes);
                final incomeTotal = totalIncomeUsd(incomes);
                final expenseTotal = totalUsd(expenses);
                final net = incomeTotal - expenseTotal;
                final hasSpendOrIncome =
                    expenses.isNotEmpty || incomeTotal > 0;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _YearSpendSummary(expenses: expenses, locale: loc, l10n: l10n),
                    if (incomeTotal > 0 || expenseTotal > 0) ...[
                      const SizedBox(height: 16),
                      _YearCashflowSummaryCard(
                        l10n: l10n,
                        localeName: locale,
                        incomeUsd: incomeTotal,
                        expenseUsd: expenseTotal,
                        netUsd: net,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.reportsCashflowFootnote,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                    if (hasSpendOrIncome) ...[
                      const SizedBox(height: 8),
                      Text(
                        l10n.reportsFxFootnote,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                    if (hasSpendOrIncome) ...[
                      const SizedBox(height: 20),
                      Text(
                        l10n.reportsYearMonthlyCashflowHeading,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      _MonthlyUsdTable(
                        year: year,
                        monthlyExpenseUsd: monthlyExpenseUsd,
                        monthlyIncomeUsd: monthlyIncomeUsd,
                        localeName: locale,
                        l10n: l10n,
                      ),
                      const SizedBox(height: 16),
                      ReportsMonthlyCashflowBarChart(
                        year: year,
                        monthlyIncomeUsd: monthlyIncomeUsd,
                        monthlyExpenseUsd: monthlyExpenseUsd,
                        localeName: locale,
                        l10n: l10n,
                      ),
                    ],
                  ],
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Text('$e'),
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Text('$e'),
        ),
      ],
    );
  }
}

class _YearCashflowSummaryCard extends StatelessWidget {
  const _YearCashflowSummaryCard({
    required this.l10n,
    required this.localeName,
    required this.incomeUsd,
    required this.expenseUsd,
    required this.netUsd,
  });

  final AppLocalizations l10n;
  final String localeName;
  final double incomeUsd;
  final double expenseUsd;
  final double netUsd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Card(
      elevation: 0,
      color: scheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.reportsYearCashflowTitle,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.reportsYearIncomeUsdLine(
                formatUsdAmountOnly(incomeUsd, localeName),
              ),
              style: theme.textTheme.bodyLarge,
            ),
            Text(
              l10n.reportsYearExpenseUsdLine(
                formatUsdAmountOnly(expenseUsd, localeName),
              ),
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 6),
            Text(
              l10n.reportsYearNetUsdLine(
                formatUsdAmountOnly(netUsd, localeName),
              ),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: netUsd >= 0
                    ? scheme.primary
                    : scheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportsByMonthTabBody extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final localeName = Localizations.localeOf(context).toString();
    final year = ref.watch(selectedReportYearProvider);
    final month = ref.watch(selectedReportDetailMonthProvider);
    final monthLabel = DateFormat.yMMMM(
      localeName,
    ).format(DateTime(year, month));
    final expensesAsync = ref.watch(expensesForReportDetailMonthProvider);
    final incomeAsync = ref.watch(incomeForReportDetailMonthProvider);
    final categories = ref.watch(categoriesStreamProvider).valueOrNull ?? [];
    final allSubs = ref.watch(allSubcategoriesStreamProvider).valueOrNull ?? [];
    final categoryName = {for (final c in categories) c.id: c.name};
    final subcategoryName = {for (final s in allSubs) s.id: s.name};
    final instruments =
        ref.watch(paymentInstrumentsStreamProvider).valueOrNull ?? [];
    final instrumentLabel = {for (final p in instruments) p.id: p.label};
    final incomeCats =
        ref.watch(incomeCategoriesStreamProvider).valueOrNull ?? [];
    final allIncomeSubs =
        ref.watch(allIncomeSubcategoriesStreamProvider).valueOrNull ?? [];
    final incomeCategoryName = {for (final c in incomeCats) c.id: c.name};
    final incomeSubcategoryName = {
      for (final s in allIncomeSubs) s.id: s.name,
    };
    final today = calendarTodayLocal();

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Row(
          children: [
            IconButton(
              tooltip: l10n.monthPickerPrevious,
              onPressed: () {
                final m = ref.read(selectedReportDetailMonthProvider);
                ref.read(selectedReportDetailMonthProvider.notifier).state =
                    m > 1 ? m - 1 : 12;
              },
              icon: const Icon(Icons.chevron_left),
            ),
            Expanded(
              child: Text(
                monthLabel,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            IconButton(
              tooltip: l10n.monthPickerNext,
              onPressed: () {
                final m = ref.read(selectedReportDetailMonthProvider);
                ref.read(selectedReportDetailMonthProvider.notifier).state =
                    m < 12 ? m + 1 : 1;
              },
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
        const SizedBox(height: 16),
        expensesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('$e'),
          data: (expenses) => incomeAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('$e'),
            data: (incomeList) {
              final incomeUsd =
                  incomeList.fold<double>(0, (sum, e) => sum + e.amountUsd);
              final expenseUsd =
                  expenses.fold<double>(0, (sum, e) => sum + e.amountUsd);
              if (expenses.isEmpty && incomeUsd <= 0) {
                return Text(
                  l10n.reportsByMonthEmpty,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (incomeUsd > 0 || expenseUsd > 0) ...[
                    ReportsPeriodCashflowBarChart(
                      periodLabel: monthLabel,
                      incomeUsd: incomeUsd,
                      expenseUsd: expenseUsd,
                      localeName: localeName,
                      l10n: l10n,
                    ),
                    const SizedBox(height: 20),
                  ],
                  if (incomeUsd > 0) ...[
                    Text(
                      l10n.reportsIncomeThisMonthLine(
                        formatUsdAmountOnly(incomeUsd, localeName),
                      ),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.reportsByMonthIncomeHeading,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    ...incomeList.map(
                      (e) => IncomeSummaryListTile(
                        entry: e,
                        categoryId: e.incomeCategoryId,
                        categoryName: incomeCategoryName[e.incomeCategoryId] ??
                            l10n.taxonomyUnknownLabel,
                        subcategoryName:
                            incomeSubcategoryName[e.incomeSubcategoryId] ??
                                l10n.taxonomyUnknownLabel,
                        emphasizeAsScheduled: !isRealizedOnLocalCalendar(
                          e.receivedOn,
                          today,
                        ),
                        showRecurringOverflowMenu:
                            e.recurringSeriesId != null &&
                                e.recurringSeriesId!.isNotEmpty &&
                                !isRealizedOnLocalCalendar(
                                  e.receivedOn,
                                  today,
                                ) &&
                                e.effectiveExpectationStatus ==
                                    PaymentExpectationStatus.expected,
                        onRecurringMenuAction: (action) {
                          handleRecurringIncomeTileAction(
                            context,
                            ref,
                            e,
                            action,
                          );
                        },
                        onTap: () {
                          showDialog<void>(
                            context: context,
                            builder: (ctx) => IncomeFormDialog(initial: e),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (expenses.isNotEmpty) ...[
                    Text(
                      l10n.expensesThisMonthHeading,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    ...expenses.map(
                      (e) => ExpenseSummaryListTile(
                        expense: e,
                        categoryId: e.categoryId,
                        categoryName: categoryName[e.categoryId] ??
                            l10n.taxonomyUnknownLabel,
                        subcategoryName: subcategoryName[e.subcategoryId] ??
                            l10n.taxonomyUnknownLabel,
                        paymentInstrumentLabel: e.paymentInstrumentId != null
                            ? instrumentLabel[e.paymentInstrumentId!]
                            : null,
                        emphasizeAsScheduled: !isRealizedOnLocalCalendar(
                          e.occurredOn,
                          today,
                        ),
                        onTap: () {
                          showDialog<void>(
                            context: context,
                            builder: (ctx) => ExpenseFormDialog(initial: e),
                          );
                        },
                      ),
                    ),
                  ] else if (incomeUsd <= 0) ...[
                    Text(
                      l10n.reportsByMonthEmpty,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                    ),
                  ],
                  if (incomeUsd > 0 || expenseUsd > 0) ...[
                    const SizedBox(height: 16),
                    Text(
                      l10n.reportsByMonthNetLine(
                        formatUsdAmountOnly(
                          incomeUsd - expenseUsd,
                          localeName,
                        ),
                      ),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
              ],
            );
            },
          ),
        ),
      ],
    );
  }
}

class _ReportsByCategoryTabBody extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final localeName = Localizations.localeOf(context).toString();
    final year = ref.watch(selectedReportYearProvider);
    final month = ref.watch(selectedReportDetailMonthProvider);
    final scope = ref.watch(reportCategoryPeriodScopeProvider);
    final expensesAsync = ref.watch(expensesForReportCategoryScopeProvider);
    final incomeAsync = ref.watch(incomeForReportCategoryScopeProvider);
    final categories = ref.watch(categoriesStreamProvider).valueOrNull ?? [];
    final allSubs = ref.watch(allSubcategoriesStreamProvider).valueOrNull ?? [];
    final incomeCats =
        ref.watch(incomeCategoriesStreamProvider).valueOrNull ?? [];
    final allIncomeSubs =
        ref.watch(allIncomeSubcategoriesStreamProvider).valueOrNull ?? [];
    final categoryName = {for (final c in categories) c.id: c.name};
    final subcategoryName = {for (final s in allSubs) s.id: s.name};
    final incomeCategoryName = {for (final c in incomeCats) c.id: c.name};
    final incomeSubcategoryName = {
      for (final s in allIncomeSubs) s.id: s.name,
    };

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        SegmentedButton<ReportCategoryPeriodScope>(
          segments: [
            ButtonSegment<ReportCategoryPeriodScope>(
              value: ReportCategoryPeriodScope.fullYear,
              label: Text(l10n.reportsByCategoryScopeYear),
            ),
            ButtonSegment<ReportCategoryPeriodScope>(
              value: ReportCategoryPeriodScope.singleMonth,
              label: Text(l10n.reportsByCategoryScopeMonth),
            ),
          ],
          selected: {scope},
          onSelectionChanged: (next) {
            ref.read(reportCategoryPeriodScopeProvider.notifier).state =
                next.first;
          },
        ),
        if (scope == ReportCategoryPeriodScope.singleMonth) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              IconButton(
                tooltip: l10n.monthPickerPrevious,
                onPressed: () {
                  final m = ref.read(selectedReportDetailMonthProvider);
                  ref.read(selectedReportDetailMonthProvider.notifier).state =
                      m > 1 ? m - 1 : 12;
                },
                icon: const Icon(Icons.chevron_left),
              ),
              Expanded(
                child: Text(
                  DateFormat.yMMMM(localeName).format(DateTime(year, month)),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              IconButton(
                tooltip: l10n.monthPickerNext,
                onPressed: () {
                  final m = ref.read(selectedReportDetailMonthProvider);
                  ref.read(selectedReportDetailMonthProvider.notifier).state =
                      m < 12 ? m + 1 : 1;
                },
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ],
        const SizedBox(height: 16),
        expensesAsync.when(
          data: (expenses) {
            return incomeAsync.when(
              data: (incomes) {
                final expenseTotal = totalUsd(expenses);
                final incomeTotal = totalIncomeUsd(incomes);
                if (expenseTotal <= 0 && incomeTotal <= 0) {
                  return Text(
                    l10n.reportsByCategoryNoExpensesOrIncome,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant,
                        ),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.reportsPercentFootnote,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 12),
                    if (incomeTotal > 0 || expenseTotal > 0) ...[
                      ReportsPeriodCashflowBarChart(
                        periodLabel: scope ==
                                ReportCategoryPeriodScope.fullYear
                            ? l10n.reportsChartPeriodWholeYearLabel(
                                year.toString(),
                              )
                            : DateFormat.yMMMM(
                                localeName,
                              ).format(DateTime(year, month)),
                        incomeUsd: incomeTotal,
                        expenseUsd: expenseTotal,
                        localeName: localeName,
                        l10n: l10n,
                      ),
                      const SizedBox(height: 20),
                    ],
                    if (incomeTotal > 0) ...[
                      ReportsCategoryPieChart(
                        cardKey: const ValueKey<String>(
                          'reports-income-category-pie-chart',
                        ),
                        aggregates: aggregateUsdByIncomeCategory(incomes),
                        periodTotalUsd: incomeTotal,
                        categoryName: incomeCategoryName,
                        localeName: localeName,
                        l10n: l10n,
                        chartTitle: l10n.reportsChartIncomeCategoryTitle,
                        semanticLabel:
                            l10n.reportsChartIncomeCategorySemanticLabel,
                      ),
                      const SizedBox(height: 16),
                      _IncomeCategoryBreakdownTable(
                        incomes: incomes,
                        aggregates: aggregateUsdByIncomeCategory(incomes),
                        periodTotalUsd: incomeTotal,
                        categoryName: incomeCategoryName,
                        subcategoryName: incomeSubcategoryName,
                        localeName: localeName,
                        l10n: l10n,
                      ),
                    ],
                    if (incomeTotal > 0 && expenseTotal > 0) ...[
                      const SizedBox(height: 28),
                      Divider(
                        height: 1,
                        color: Theme.of(context)
                            .colorScheme
                            .outlineVariant
                            .withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 20),
                    ],
                    if (expenseTotal > 0) ...[
                      ReportsCategoryPieChart(
                        cardKey: const ValueKey<String>(
                          'reports-expense-category-pie-chart',
                        ),
                        aggregates: aggregateUsdByCategory(expenses),
                        periodTotalUsd: expenseTotal,
                        categoryName: categoryName,
                        localeName: localeName,
                        l10n: l10n,
                      ),
                      const SizedBox(height: 16),
                      _CategoryBreakdownTable(
                        expenses: expenses,
                        aggregates: aggregateUsdByCategory(expenses),
                        periodTotalUsd: expenseTotal,
                        categoryName: categoryName,
                        subcategoryName: subcategoryName,
                        localeName: localeName,
                        l10n: l10n,
                      ),
                    ],
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('$e'),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('$e'),
        ),
      ],
    );
  }
}

class _CategoryBreakdownTable extends StatelessWidget {
  const _CategoryBreakdownTable({
    required this.expenses,
    required this.aggregates,
    required this.periodTotalUsd,
    required this.categoryName,
    required this.subcategoryName,
    required this.localeName,
    required this.l10n,
  });

  final List<Expense> expenses;
  final List<CategoryUsdAggregate> aggregates;
  final double periodTotalUsd;
  final Map<String, String> categoryName;
  final Map<String, String> subcategoryName;
  final String localeName;
  final AppLocalizations l10n;

  static String _pct(double value) => '${value.toStringAsFixed(1)}%';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: scheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    l10n.reportsCategoryColumnCategory,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    l10n.reportsCategoryColumnUsd,
                    textAlign: TextAlign.end,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
                SizedBox(
                  width: 88,
                  child: Text(
                    l10n.reportsCategoryColumnShare,
                    textAlign: TextAlign.end,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...aggregates.map((row) {
            final name =
                categoryName[row.categoryId] ?? l10n.taxonomyUnknownLabel;
            final share = percentOfTotal(row.totalUsd, periodTotalUsd);
            final subRows = aggregateUsdBySubcategoryForCategory(
              expenses,
              row.categoryId,
            );
            return ExpansionTile(
              key: PageStorageKey<String>('cat-${row.categoryId}'),
              title: Text(name),
              subtitle: Text(
                '${formatDisplayCurrencyLine('USD', row.totalUsd, localeName)} · ${_pct(share)}',
                style: theme.textTheme.bodySmall,
              ),
              children: [
                if (subRows.isEmpty)
                  const SizedBox.shrink()
                else
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          l10n.reportsSubcategoryColumnShare,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 6),
                        ...subRows.map((s) {
                          final subShare = percentOfTotal(
                            s.totalUsd,
                            row.totalUsd,
                          );
                          final subLabel = subcategoryName[s.subcategoryId] ??
                              l10n.taxonomyUnknownLabel;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    subLabel,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ),
                                Text(
                                  formatDisplayCurrencyLine(
                                    'USD',
                                    s.totalUsd,
                                    localeName,
                                  ),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  width: 72,
                                  child: Text(
                                    _pct(subShare),
                                    textAlign: TextAlign.end,
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _IncomeCategoryBreakdownTable extends StatelessWidget {
  const _IncomeCategoryBreakdownTable({
    required this.incomes,
    required this.aggregates,
    required this.periodTotalUsd,
    required this.categoryName,
    required this.subcategoryName,
    required this.localeName,
    required this.l10n,
  });

  final List<IncomeEntry> incomes;
  final List<CategoryUsdAggregate> aggregates;
  final double periodTotalUsd;
  final Map<String, String> categoryName;
  final Map<String, String> subcategoryName;
  final String localeName;
  final AppLocalizations l10n;

  static String _pct(double value) => '${value.toStringAsFixed(1)}%';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: scheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    l10n.reportsCategoryColumnCategory,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    l10n.reportsCategoryColumnUsd,
                    textAlign: TextAlign.end,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
                SizedBox(
                  width: 88,
                  child: Text(
                    l10n.reportsCategoryColumnShare,
                    textAlign: TextAlign.end,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...aggregates.map((row) {
            final name =
                categoryName[row.categoryId] ?? l10n.taxonomyUnknownLabel;
            final share = percentOfTotal(row.totalUsd, periodTotalUsd);
            final subRows = aggregateUsdByIncomeSubcategoryForCategory(
              incomes,
              row.categoryId,
            );
            return ExpansionTile(
              key: PageStorageKey<String>('inc-cat-${row.categoryId}'),
              title: Text(name),
              subtitle: Text(
                '${formatDisplayCurrencyLine('USD', row.totalUsd, localeName)} · ${_pct(share)}',
                style: theme.textTheme.bodySmall,
              ),
              children: [
                if (subRows.isEmpty)
                  const SizedBox.shrink()
                else
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          l10n.reportsSubcategoryColumnShare,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 6),
                        ...subRows.map((s) {
                          final subShare = percentOfTotal(
                            s.totalUsd,
                            row.totalUsd,
                          );
                          final subLabel = subcategoryName[s.subcategoryId] ??
                              l10n.taxonomyUnknownLabel;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    subLabel,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ),
                                Text(
                                  formatDisplayCurrencyLine(
                                    'USD',
                                    s.totalUsd,
                                    localeName,
                                  ),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  width: 72,
                                  child: Text(
                                    _pct(subShare),
                                    textAlign: TextAlign.end,
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _YearSpendSummary extends StatelessWidget {
  const _YearSpendSummary({
    required this.expenses,
    required this.locale,
    required this.l10n,
  });

  final List<Expense> expenses;
  final Locale locale;
  final AppLocalizations l10n;

  static double _chipStripHeight(BuildContext context) {
    const base = kMinInteractiveDimension + 8;
    return MediaQuery.textScalerOf(context).scale(base).clamp(48.0, 80.0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final byCurrency = <String, double>{};
    for (final e in expenses) {
      final c = e.currencyCode.toUpperCase();
      byCurrency[c] = (byCurrency[c] ?? 0) + e.amountOriginal;
    }
    final leftCodes = byCurrency.keys.where((c) => c != 'USD').toList()..sort();

    final usdTotal = expenses.fold<double>(0, (s, e) => s + e.amountUsd);
    final usdLine = formatDisplayCurrencyLine(
      'USD',
      usdTotal,
      locale.toString(),
    );
    final usdAccessibilityAmount = NumberFormat.decimalPatternDigits(
      locale: locale.toString(),
      decimalDigits: 2,
    ).format(usdTotal);

    return Card(
      elevation: 0,
      clipBehavior: Clip.none,
      color: scheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.reportsYearSummaryTitle,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 10),
            if (expenses.isEmpty)
              Text(
                l10n.reportsYearNoExpenses,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: leftCodes.isEmpty
                        ? const SizedBox(height: 40)
                        : SizedBox(
                            height:
                                _chipStripHeight(context) + (kIsWeb ? 10 : 0),
                            child: _YearTotalsCurrencyStrip(
                              currencyCodes: leftCodes,
                              amountByCurrency: byCurrency,
                              localeName: locale.toString(),
                            ),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Semantics(
                    label: l10n.monthSummaryUsdTotal(usdAccessibilityAmount),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            scheme.primaryContainer,
                            Color.alphaBlend(
                              scheme.primary.withValues(alpha: 0.12),
                              scheme.primaryContainer,
                            ),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: scheme.primary.withValues(alpha: 0.18),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        child: Text(
                          usdLine,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: scheme.onPrimaryContainer,
                            letterSpacing: 0.15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _YearTotalsCurrencyStrip extends StatefulWidget {
  const _YearTotalsCurrencyStrip({
    required this.currencyCodes,
    required this.amountByCurrency,
    required this.localeName,
  });

  final List<String> currencyCodes;
  final Map<String, double> amountByCurrency;
  final String localeName;

  @override
  State<_YearTotalsCurrencyStrip> createState() =>
      _YearTotalsCurrencyStripState();
}

class _YearTotalsCurrencyStripState extends State<_YearTotalsCurrencyStrip> {
  late final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final codes = widget.currencyCodes;
    return Scrollbar(
      controller: _controller,
      thumbVisibility: kIsWeb,
      thickness: kIsWeb ? 5 : null,
      radius: const Radius.circular(4),
      child: ListView.separated(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        primary: false,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: EdgeInsets.only(right: 8, bottom: kIsWeb ? 6 : 0),
        itemCount: codes.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          return Align(
            alignment: Alignment.centerLeft,
            child: _YearSummaryCurrencyChip(
              label: formatDisplayCurrencyLine(
                codes[i],
                widget.amountByCurrency[codes[i]]!,
                widget.localeName,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _YearSummaryCurrencyChip extends StatelessWidget {
  const _YearSummaryCurrencyChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Material(
      color: scheme.surface,
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
        side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.9)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
            color: scheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _MonthlyUsdTable extends StatelessWidget {
  const _MonthlyUsdTable({
    required this.year,
    required this.monthlyExpenseUsd,
    required this.monthlyIncomeUsd,
    required this.localeName,
    required this.l10n,
  });

  final int year;
  final List<double> monthlyExpenseUsd;
  final List<double> monthlyIncomeUsd;
  final String localeName;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    Widget cellHeader(String t) => Padding(
          padding: const EdgeInsets.fromLTRB(6, 8, 6, 8),
          child: Text(
            t,
            style: theme.textTheme.labelSmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.end,
            maxLines: 2,
          ),
        );

    Widget cellValue(double v) => Padding(
          padding: const EdgeInsets.fromLTRB(6, 10, 6, 10),
          child: Text(
            formatDisplayCurrencyLine('USD', v, localeName),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.end,
          ),
        );

    return Card(
      elevation: 0,
      color: scheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Table(
            columnWidths: const {
              0: FixedColumnWidth(56),
              1: FixedColumnWidth(92),
              2: FixedColumnWidth(92),
              3: FixedColumnWidth(88),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 6, 8),
                    child: Text(
                      l10n.reportsMonthColumnMonth,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  cellHeader(l10n.reportsMonthColumnIncomeUsd),
                  cellHeader(l10n.reportsMonthColumnExpenseUsd),
                  cellHeader(l10n.reportsMonthColumnNetUsd),
                ],
              ),
              ...List.generate(12, (i) {
                final month = i + 1;
                final inc = monthlyIncomeUsd[i];
                final exp = monthlyExpenseUsd[i];
                final net = inc - exp;
                final monthLabel = DateFormat.MMM(
                  localeName,
                ).format(DateTime(year, month));
                return TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
                      child: Text(monthLabel, style: theme.textTheme.bodyLarge),
                    ),
                    cellValue(inc),
                    cellValue(exp),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(6, 10, 12, 10),
                      child: Text(
                        formatDisplayCurrencyLine('USD', net, localeName),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: net >= 0
                              ? scheme.primary
                              : scheme.error,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
