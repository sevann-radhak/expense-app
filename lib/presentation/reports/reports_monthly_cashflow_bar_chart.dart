import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:expense_app/l10n/app_localizations.dart';
import 'package:expense_app/presentation/formatting/currency_display.dart';
import 'package:expense_app/presentation/reports/report_chart_colors.dart';

/// Grouped bars per month: income vs expenses (USD), same inclusion filter as the table.
class ReportsMonthlyCashflowBarChart extends StatelessWidget {
  const ReportsMonthlyCashflowBarChart({
    super.key,
    required this.year,
    required this.monthlyIncomeUsd,
    required this.monthlyExpenseUsd,
    required this.localeName,
    required this.l10n,
  });

  final int year;
  final List<double> monthlyIncomeUsd;
  final List<double> monthlyExpenseUsd;
  final String localeName;
  final AppLocalizations l10n;

  static const double _chartHeight = 268;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final incomeGradient = reportChartIncomeBarGradient(scheme);
    final expenseGradient = reportChartExpenseBarGradient(scheme);
    final incomeColor = reportChartIncomeBarColor(scheme);
    final expenseColor = reportChartExpenseBarColor(scheme);

    var maxVal = 0.0;
    for (var i = 0; i < 12; i++) {
      final a = monthlyIncomeUsd[i];
      final b = monthlyExpenseUsd[i];
      if (a > maxVal) {
        maxVal = a;
      }
      if (b > maxVal) {
        maxVal = b;
      }
    }
    final maxY = maxVal <= 0 ? 1.0 : maxVal * 1.2;
    final trackColor = scheme.surfaceContainerHighest.withValues(alpha: 0.55);

    return Semantics(
      label: l10n.reportsChartCashflowSemanticLabel,
      container: true,
      child: Card(
        key: const ValueKey<String>('reports-monthly-cashflow-bar-chart'),
        elevation: 0,
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: scheme.outlineVariant.withValues(alpha: 0.45),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 14, 12, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  l10n.reportsChartMonthlyCashflowTitle,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _LegendChip(
                      indicator: BoxDecoration(
                        gradient: incomeGradient,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: incomeColor.withValues(alpha: 0.22),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      label: l10n.reportsChartLegendIncome,
                    ),
                    _LegendChip(
                      indicator: BoxDecoration(
                        gradient: expenseGradient,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: expenseColor.withValues(alpha: 0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      label: l10n.reportsChartLegendExpenses,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: _chartHeight,
                child: BarChart(
                  BarChartData(
                    minY: 0,
                    maxY: maxY,
                    alignment: BarChartAlignment.spaceAround,
                    groupsSpace: 10,
                    barTouchData: BarTouchData(
                      handleBuiltInTouches: true,
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (_) => scheme.inverseSurface,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final i = group.x;
                          if (i < 0 || i > 11) {
                            return null;
                          }
                          final inc = monthlyIncomeUsd[i];
                          final exp = monthlyExpenseUsd[i];
                          final m = DateFormat.MMM(
                            localeName,
                          ).format(DateTime(year, i + 1));
                          final incLine = formatDisplayCurrencyLine(
                            'USD',
                            inc,
                            localeName,
                          );
                          final expLine = formatDisplayCurrencyLine(
                            'USD',
                            exp,
                            localeName,
                          );
                          final body =
                              '$m\n${l10n.reportsChartLegendIncome}: $incLine\n'
                              '${l10n.reportsChartLegendExpenses}: $expLine';
                          return BarTooltipItem(
                            body,
                            (textTheme.bodySmall ?? const TextStyle()).copyWith(
                              color: scheme.onInverseSurface,
                              fontSize: 11,
                              height: 1.25,
                            ),
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      topTitles: const AxisTitles(),
                      rightTitles: const AxisTitles(),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 44,
                          getTitlesWidget: (value, meta) {
                            if (value < 0 || value > maxY * 1.001) {
                              return const SizedBox.shrink();
                            }
                            return Text(
                              NumberFormat.compact(locale: localeName)
                                  .format(value),
                              style: textTheme.labelSmall?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTitlesWidget: (value, meta) {
                            final i = value.toInt();
                            if (i < 0 || i > 11) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                DateFormat.MMM(
                                  localeName,
                                ).format(DateTime(year, i + 1)),
                                style: textTheme.labelSmall?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: maxY <= 0
                          ? 1
                          : (maxY / 4).clamp(0.5, double.infinity),
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: scheme.outlineVariant.withValues(alpha: 0.28),
                        strokeWidth: 1,
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: List.generate(12, (i) {
                      return BarChartGroupData(
                        x: i,
                        barsSpace: 5,
                        barRods: [
                          BarChartRodData(
                            toY: monthlyIncomeUsd[i],
                            gradient: incomeGradient,
                            width: 11,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8),
                            ),
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: maxY,
                              color: trackColor,
                            ),
                          ),
                          BarChartRodData(
                            toY: monthlyExpenseUsd[i],
                            gradient: expenseGradient,
                            width: 11,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8),
                            ),
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: maxY,
                              color: trackColor,
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Two tall bars: total income vs total expenses for one period (e.g. a month or full year).
class ReportsPeriodCashflowBarChart extends StatelessWidget {
  const ReportsPeriodCashflowBarChart({
    super.key,
    required this.periodLabel,
    required this.incomeUsd,
    required this.expenseUsd,
    required this.localeName,
    required this.l10n,
  });

  final String periodLabel;
  final double incomeUsd;
  final double expenseUsd;
  final String localeName;
  final AppLocalizations l10n;

  static const double _chartHeight = 232;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final incomeGradient = reportChartIncomeBarGradient(scheme);
    final expenseGradient = reportChartExpenseBarGradient(scheme);
    final incomeColor = reportChartIncomeBarColor(scheme);
    final expenseColor = reportChartExpenseBarColor(scheme);

    final maxVal = incomeUsd > expenseUsd ? incomeUsd : expenseUsd;
    final maxY = maxVal <= 0 ? 1.0 : maxVal * 1.15;
    final trackColor = scheme.surfaceContainerHighest.withValues(alpha: 0.55);

    return Semantics(
      label: l10n.reportsChartPeriodCashflowSemanticLabel(periodLabel),
      container: true,
      child: Card(
        key: const ValueKey<String>('reports-period-cashflow-bar-chart'),
        elevation: 0,
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: scheme.outlineVariant.withValues(alpha: 0.45),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 14, 12, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  l10n.reportsChartMonthlyCashflowTitle,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  periodLabel,
                  style: textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _LegendChip(
                      indicator: BoxDecoration(
                        gradient: incomeGradient,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: incomeColor.withValues(alpha: 0.22),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      label: l10n.reportsChartLegendIncome,
                    ),
                    _LegendChip(
                      indicator: BoxDecoration(
                        gradient: expenseGradient,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: expenseColor.withValues(alpha: 0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      label: l10n.reportsChartLegendExpenses,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: _chartHeight,
                child: BarChart(
                  BarChartData(
                    minY: 0,
                    maxY: maxY,
                    alignment: BarChartAlignment.spaceAround,
                    groupsSpace: 56,
                    barTouchData: BarTouchData(
                      handleBuiltInTouches: true,
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (_) => scheme.inverseSurface,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final isIncome = group.x == 0;
                          final v = isIncome ? incomeUsd : expenseUsd;
                          final title = isIncome
                              ? l10n.reportsChartLegendIncome
                              : l10n.reportsChartLegendExpenses;
                          final line = formatDisplayCurrencyLine(
                            'USD',
                            v,
                            localeName,
                          );
                          return BarTooltipItem(
                            '$title\n$line',
                            (textTheme.bodySmall ?? const TextStyle()).copyWith(
                              color: scheme.onInverseSurface,
                              fontSize: 12,
                              height: 1.25,
                            ),
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      topTitles: const AxisTitles(),
                      rightTitles: const AxisTitles(),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 44,
                          getTitlesWidget: (value, meta) {
                            if (value < 0 || value > maxY * 1.001) {
                              return const SizedBox.shrink();
                            }
                            return Text(
                              NumberFormat.compact(locale: localeName)
                                  .format(value),
                              style: textTheme.labelSmall?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 32,
                          getTitlesWidget: (value, meta) {
                            final i = value.toInt();
                            if (i == 0) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  l10n.reportsChartLegendIncome,
                                  textAlign: TextAlign.center,
                                  style: textTheme.labelSmall?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            }
                            if (i == 1) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  l10n.reportsChartLegendExpenses,
                                  textAlign: TextAlign.center,
                                  style: textTheme.labelSmall?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: maxY <= 0
                          ? 1
                          : (maxY / 4).clamp(0.5, double.infinity),
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: scheme.outlineVariant.withValues(alpha: 0.28),
                        strokeWidth: 1,
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            toY: incomeUsd,
                            gradient: incomeGradient,
                            width: 36,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: maxY,
                              color: trackColor,
                            ),
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            toY: expenseUsd,
                            gradient: expenseGradient,
                            width: 36,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: maxY,
                              color: trackColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({required this.indicator, required this.label});

  final Decoration indicator;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: indicator,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
