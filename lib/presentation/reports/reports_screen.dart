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
import 'package:expense_app/presentation/home/recurring_expense_menu_handler.dart';
import 'package:expense_app/presentation/incomes/income_summary_list_tile.dart';
import 'package:expense_app/presentation/incomes/recurring_income_menu_handler.dart';
import 'package:expense_app/presentation/providers/providers.dart';
import 'package:expense_app/presentation/reports/report_csv_download.dart';
import 'package:expense_app/presentation/widgets/month_cashflow_summary_card.dart';
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

Widget _reportsUsdPrefixedLine({
  required String prefix,
  required double amountUsd,
  required String localeName,
  required TextStyle? style,
}) {
  final base = style ?? const TextStyle();
  return Text.rich(
    TextSpan(
      style: base,
      children: [
        TextSpan(text: prefix),
        ...usdAmountOnlyInlineSpans(amountUsd, localeName, style: base),
      ],
    ),
  );
}

String _reportIncomeTotalsTitle(
  AppLocalizations l10n,
  ReportCategoryPeriodScope scope,
  int year,
) {
  if (scope == ReportCategoryPeriodScope.singleMonth) {
    return l10n.incomeThisMonthHeading;
  }
  return '${l10n.reportsByMonthIncomeHeading} — ${l10n.reportsChartPeriodWholeYearLabel(year.toString())}';
}

String _reportExpenseTotalsTitle(
  AppLocalizations l10n,
  ReportCategoryPeriodScope scope,
  int year,
) {
  if (scope == ReportCategoryPeriodScope.singleMonth) {
    return l10n.expensesThisMonthHeading;
  }
  return '${l10n.expensesThisMonthHeading} — ${l10n.reportsChartPeriodWholeYearLabel(year.toString())}';
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
                final todayAnnual = calendarTodayLocal();
                final monthlyIncomeSettled = List<double>.filled(12, 0);
                final monthlyIncomePending = List<double>.filled(12, 0);
                final monthlyExpenseSettled = List<double>.filled(12, 0);
                final monthlyExpensePending = List<double>.filled(12, 0);
                monthlyIncomeSettledPendingForYear(
                  incomes,
                  year,
                  todayAnnual,
                  monthlyIncomeSettled,
                  monthlyIncomePending,
                );
                monthlyExpenseSettledPendingForYear(
                  expenses,
                  year,
                  todayAnnual,
                  monthlyExpenseSettled,
                  monthlyExpensePending,
                );
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
                        monthlyIncomeSettledUsd: monthlyIncomeSettled,
                        monthlyIncomePendingUsd: monthlyIncomePending,
                        monthlyExpenseSettledUsd: monthlyExpenseSettled,
                        monthlyExpensePendingUsd: monthlyExpensePending,
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
            _reportsUsdPrefixedLine(
              prefix: l10n.reportsYearIncomeUsdPrefix,
              amountUsd: incomeUsd,
              localeName: localeName,
              style: theme.textTheme.bodyLarge,
            ),
            _reportsUsdPrefixedLine(
              prefix: l10n.reportsYearExpenseUsdPrefix,
              amountUsd: expenseUsd,
              localeName: localeName,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 6),
            Builder(
              builder: (context) {
                final netStyle = theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: netUsd >= 0
                      ? scheme.primary
                      : scheme.error,
                );
                if (netStyle == null) {
                  return const SizedBox.shrink();
                }
                final fracStyle = amountFractionTextStyle(netStyle).copyWith(
                  color: netStyle.color,
                );
                return Text.rich(
                  TextSpan(
                    style: netStyle,
                    children: [
                      TextSpan(text: l10n.reportsYearNetUsdPrefix),
                      ...usdAmountOnlyInlineSpans(
                        netUsd,
                        localeName,
                        style: netStyle,
                        fractionStyle: fracStyle,
                      ),
                    ],
                  ),
                );
              },
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
              final incomeUsd = totalIncomeUsd(incomeList);
              final expenseUsd = totalUsd(expenses);
              final incSp = splitIncomeUsdSettledPending(incomeList, today);
              final expSp = splitExpenseUsdSettledPending(expenses, today);
              final loc = Localizations.localeOf(context);
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
                      incomeSettledUsd: incSp.settled,
                      incomePendingUsd: incSp.pending,
                      expenseSettledUsd: expSp.settled,
                      expensePendingUsd: expSp.pending,
                      localeName: localeName,
                      l10n: l10n,
                    ),
                    const SizedBox(height: 20),
                  ],
                  if (incomeUsd > 0) ...[
                    MonthCashflowSummaryCard(
                      title: l10n.incomeThisMonthHeading,
                      locale: loc,
                      l10n: l10n,
                      split: monthCashflowOriginalUsdSplitForIncome(
                        incomeList,
                        today,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...incomeList.map(
                      (e) => IncomeSummaryListTile(
                        entry: e,
                        categoryId: e.incomeCategoryId,
                        categoryName: incomeCategoryName[e.incomeCategoryId] ??
                            l10n.taxonomyUnknownLabel,
                        subcategoryName:
                            incomeSubcategoryName[e.incomeSubcategoryId] ??
                                l10n.taxonomyUnknownLabel,
                        emphasizeAsScheduled:
                            !isEconomicallySettledIncome(e, today),
                        onMenuAction: (action) {
                          handleIncomeSummaryTileMenuAction(
                            context,
                            ref,
                            e,
                            action,
                          );
                        },
                        onSettlementToggle: (settled) async {
                          try {
                            await ref.read(incomeRepositoryProvider).update(
                                  withIncomeSettlementChoice(
                                    e,
                                    settled,
                                    calendarTodayLocal(),
                                  ),
                                );
                          } on Object catch (err) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('$err')),
                              );
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (expenses.isNotEmpty) ...[
                    MonthCashflowSummaryCard(
                      title: l10n.expensesThisMonthHeading,
                      locale: loc,
                      l10n: l10n,
                      split: monthCashflowOriginalUsdSplitForExpenses(
                        expenses,
                        today,
                      ),
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
                        emphasizeAsScheduled:
                            !isEconomicallySettledExpense(e, today),
                        showRecurringOverflowMenu:
                            e.recurringSeriesId != null &&
                                e.recurringSeriesId!.isNotEmpty,
                        onRecurringMenuAction: (action) {
                          handleRecurringExpenseTileAction(
                            context,
                            ref,
                            e,
                            action,
                          );
                        },
                        onSettlementToggle: (settled) async {
                          try {
                            await ref.read(expenseRepositoryProvider).update(
                                  withExpenseSettlementChoice(
                                    e,
                                    settled,
                                    calendarTodayLocal(),
                                  ),
                                );
                          } on Object catch (err) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('$err')),
                              );
                            }
                          }
                        },
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
                    Builder(
                      builder: (ctx) {
                        final net = incomeUsd - expenseUsd;
                        final baseStyle =
                            Theme.of(ctx).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                );
                        if (baseStyle == null) {
                          return const SizedBox.shrink();
                        }
                        return Text.rich(
                          TextSpan(
                            style: baseStyle,
                            children: [
                              TextSpan(text: l10n.reportsByMonthNetUsdPrefix),
                              ...usdAmountOnlyInlineSpans(
                                net,
                                localeName,
                                style: baseStyle,
                              ),
                            ],
                          ),
                        );
                      },
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
                final todayScope = calendarTodayLocal();
                final incScopeSplit =
                    splitIncomeUsdSettledPending(incomes, todayScope);
                final expScopeSplit =
                    splitExpenseUsdSettledPending(expenses, todayScope);
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
                    if (incomeTotal > 0) ...[
                      MonthCashflowSummaryCard(
                        title: _reportIncomeTotalsTitle(l10n, scope, year),
                        locale: Localizations.localeOf(context),
                        l10n: l10n,
                        split: monthCashflowOriginalUsdSplitForIncome(
                          incomes,
                          todayScope,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (expenseTotal > 0) ...[
                      MonthCashflowSummaryCard(
                        title: _reportExpenseTotalsTitle(l10n, scope, year),
                        locale: Localizations.localeOf(context),
                        l10n: l10n,
                        split: monthCashflowOriginalUsdSplitForExpenses(
                          expenses,
                          todayScope,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
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
                        incomeSettledUsd: incScopeSplit.settled,
                        incomePendingUsd: incScopeSplit.pending,
                        expenseSettledUsd: expScopeSplit.settled,
                        expensePendingUsd: expScopeSplit.pending,
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
              subtitle: Text.rich(
                TextSpan(
                  style: theme.textTheme.bodySmall,
                  children: [
                    ...displayCurrencyInlineSpans(
                      'USD',
                      row.totalUsd,
                      localeName,
                      style: theme.textTheme.bodySmall,
                    ),
                    TextSpan(text: ' · ${_pct(share)}'),
                  ],
                ),
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
                          final subAmtStyle =
                              theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          );
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
                                Text.rich(
                                  TextSpan(
                                    style: subAmtStyle,
                                    children: displayCurrencyInlineSpans(
                                      'USD',
                                      s.totalUsd,
                                      localeName,
                                      style: subAmtStyle,
                                    ),
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
              subtitle: Text.rich(
                TextSpan(
                  style: theme.textTheme.bodySmall,
                  children: [
                    ...displayCurrencyInlineSpans(
                      'USD',
                      row.totalUsd,
                      localeName,
                      style: theme.textTheme.bodySmall,
                    ),
                    TextSpan(text: ' · ${_pct(share)}'),
                  ],
                ),
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
                          final subAmtStyle =
                              theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          );
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
                                Text.rich(
                                  TextSpan(
                                    style: subAmtStyle,
                                    children: displayCurrencyInlineSpans(
                                      'USD',
                                      s.totalUsd,
                                      localeName,
                                      style: subAmtStyle,
                                    ),
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

  @override
  Widget build(BuildContext context) {
    final split = monthCashflowOriginalUsdSplitForExpenses(
      expenses,
      calendarTodayLocal(),
    );

    return MonthCashflowSummaryCard(
      title: l10n.reportsYearSummaryTitle,
      locale: locale,
      l10n: l10n,
      split: split,
      emptyStateMessage:
          expenses.isEmpty ? l10n.reportsYearNoExpenses : null,
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

    Widget cellValue(double v) {
      final st = theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w500,
      );
      return Padding(
        padding: const EdgeInsets.fromLTRB(6, 10, 6, 10),
        child: Text.rich(
          TextSpan(
            style: st,
            children: displayCurrencyInlineSpans(
              'USD',
              v,
              localeName,
              style: st,
            ),
          ),
          textAlign: TextAlign.end,
        ),
      );
    }

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
                      child: Builder(
                        builder: (ctx) {
                          final netStyle =
                              theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: net >= 0
                                ? scheme.primary
                                : scheme.error,
                          );
                          if (netStyle == null) {
                            return const SizedBox.shrink();
                          }
                          final fracStyle = amountFractionTextStyle(netStyle)
                              .copyWith(color: netStyle.color);
                          return Text.rich(
                            TextSpan(
                              style: netStyle,
                              children: displayCurrencyInlineSpans(
                                'USD',
                                net,
                                localeName,
                                style: netStyle,
                                fractionStyle: fracStyle,
                              ),
                            ),
                            textAlign: TextAlign.end,
                          );
                        },
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
