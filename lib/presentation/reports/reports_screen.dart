import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:expense_app/domain/domain.dart';
import 'package:expense_app/l10n/app_localizations.dart';
import 'package:expense_app/presentation/expenses/expense_summary_list_tile.dart';
import 'package:expense_app/presentation/formatting/currency_display.dart';
import 'package:expense_app/presentation/home/expense_form_dialog.dart';
import 'package:expense_app/presentation/providers/providers.dart';
import 'package:expense_app/presentation/reports/reports_category_pie_chart.dart';
import 'package:expense_app/presentation/reports/reports_monthly_bar_chart.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.reportsTitle),
          bottom: TabBar(
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
                children: [
                  _ReportsAnnualTabBody(),
                  _ReportsByMonthTabBody(),
                  _ReportsByCategoryTabBody(),
                ],
              ),
            ),
          ],
        ),
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

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        expensesAsync.when(
          data: (expenses) {
            final loc = Localizations.localeOf(context);
            final monthlyUsd = monthlyUsdTotalsByCalendarMonth(expenses);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                _YearSpendSummary(expenses: expenses, locale: loc, l10n: l10n),
                if (expenses.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    l10n.reportsFxFootnote,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.reportsByMonthHeading,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  _MonthlyUsdTable(
                    year: year,
                    monthlyUsd: monthlyUsd,
                    localeName: locale,
                    l10n: l10n,
                  ),
                  const SizedBox(height: 16),
                  ReportsMonthlyBarChart(
                    year: year,
                    monthlyUsd: monthlyUsd,
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
        ),
      ],
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
    final categories = ref.watch(categoriesStreamProvider).valueOrNull ?? [];
    final allSubs = ref.watch(allSubcategoriesStreamProvider).valueOrNull ?? [];
    final categoryName = {for (final c in categories) c.id: c.name};
    final subcategoryName = {for (final s in allSubs) s.id: s.name};

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
          data: (expenses) {
            if (expenses.isEmpty) {
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
                    onTap: () {
                      showDialog<void>(
                        context: context,
                        builder: (ctx) => ExpenseFormDialog(initial: e),
                      );
                    },
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('$e'),
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
    final categories = ref.watch(categoriesStreamProvider).valueOrNull ?? [];
    final allSubs = ref.watch(allSubcategoriesStreamProvider).valueOrNull ?? [];
    final categoryName = {for (final c in categories) c.id: c.name};
    final subcategoryName = {for (final s in allSubs) s.id: s.name};

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
            final periodTotal = totalUsd(expenses);
            if (expenses.isEmpty || periodTotal <= 0) {
              return Text(
                l10n.reportsByCategoryEmpty,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              );
            }
            final aggregates = aggregateUsdByCategory(expenses);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.reportsPercentFootnote,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 12),
                ReportsCategoryPieChart(
                  aggregates: aggregates,
                  periodTotalUsd: periodTotal,
                  categoryName: categoryName,
                  localeName: localeName,
                  l10n: l10n,
                ),
                const SizedBox(height: 16),
                _CategoryBreakdownTable(
                  expenses: expenses,
                  aggregates: aggregates,
                  periodTotalUsd: periodTotal,
                  categoryName: categoryName,
                  subcategoryName: subcategoryName,
                  localeName: localeName,
                  l10n: l10n,
                ),
              ],
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
    required this.monthlyUsd,
    required this.localeName,
    required this.l10n,
  });

  final int year;
  final List<double> monthlyUsd;
  final String localeName;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: scheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(1.1),
            1: FlexColumnWidth(1.4),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                  child: Text(
                    l10n.reportsMonthColumnMonth,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 12, 8),
                  child: Text(
                    l10n.reportsMonthColumnUsdTotal,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            ...List.generate(12, (i) {
              final month = i + 1;
              final total = monthlyUsd[i];
              final monthLabel = DateFormat.MMM(
                localeName,
              ).format(DateTime(year, month));
              return TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
                    child: Text(monthLabel, style: theme.textTheme.bodyLarge),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 10, 12, 10),
                    child: Text(
                      formatDisplayCurrencyLine('USD', total, localeName),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
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
    );
  }
}
