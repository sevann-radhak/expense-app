import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:expense_app/l10n/app_localizations.dart';
import 'package:expense_app/presentation/formatting/currency_display.dart';
import 'package:expense_app/presentation/reports/report_chart_colors.dart';

BarChartRodData _cashflowStackedRod({
  required double settled,
  required double pending,
  required double maxYTrack,
  required double width,
  required double topRadius,
  required Color settledColor,
  required Color pendingColor,
  required Color trackColor,
}) {
  final back = BackgroundBarChartRodData(
    show: true,
    toY: maxYTrack,
    color: trackColor,
  );
  final total = settled + pending;
  if (total <= 0) {
    return BarChartRodData(
      toY: 0,
      width: width,
      color: Colors.transparent,
      borderSide: BorderSide.none,
      backDrawRodData: back,
    );
  }
  final items = <BarChartRodStackItem>[];
  if (settled > 0) {
    items.add(BarChartRodStackItem(0, settled, settledColor));
  }
  if (pending > 0) {
    items.add(BarChartRodStackItem(settled, total, pendingColor));
  }
  return BarChartRodData(
    toY: total,
    width: width,
    color: Colors.transparent,
    borderRadius: BorderRadius.vertical(top: Radius.circular(topRadius)),
    borderSide: BorderSide.none,
    rodStackItems: items,
    backDrawRodData: back,
  );
}

/// Grouped stacked bars per month: income vs expenses (USD), settled vs still scheduled.
class ReportsMonthlyCashflowBarChart extends StatelessWidget {
  const ReportsMonthlyCashflowBarChart({
    super.key,
    required this.year,
    required this.monthlyIncomeSettledUsd,
    required this.monthlyIncomePendingUsd,
    required this.monthlyExpenseSettledUsd,
    required this.monthlyExpensePendingUsd,
    required this.localeName,
    required this.l10n,
  });

  final int year;
  final List<double> monthlyIncomeSettledUsd;
  final List<double> monthlyIncomePendingUsd;
  final List<double> monthlyExpenseSettledUsd;
  final List<double> monthlyExpensePendingUsd;
  final String localeName;
  final AppLocalizations l10n;

  static const double _chartHeight = 268;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final incomeSettled = reportChartIncomeBarColor(scheme);
    final incomePending = incomeSettled.withValues(alpha: 0.38);
    final expenseSettled = reportChartExpenseBarColor(scheme);
    final expensePending = expenseSettled.withValues(alpha: 0.38);

    var maxVal = 0.0;
    for (var i = 0; i < 12; i++) {
      final inc = monthlyIncomeSettledUsd[i] + monthlyIncomePendingUsd[i];
      final exp = monthlyExpenseSettledUsd[i] + monthlyExpensePendingUsd[i];
      if (inc > maxVal) {
        maxVal = inc;
      }
      if (exp > maxVal) {
        maxVal = exp;
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
                        color: incomeSettled,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      label: l10n.reportsChartLegendIncomeSettled,
                    ),
                    _LegendChip(
                      indicator: BoxDecoration(
                        color: incomePending,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      label: l10n.reportsChartLegendIncomePending,
                    ),
                    _LegendChip(
                      indicator: BoxDecoration(
                        color: expenseSettled,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      label: l10n.reportsChartLegendExpenseSettled,
                    ),
                    _LegendChip(
                      indicator: BoxDecoration(
                        color: expensePending,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      label: l10n.reportsChartLegendExpensePending,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  l10n.reportsChartCashflowStackFootnote,
                  style: textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.35,
                  ),
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
                          final m = DateFormat.MMM(
                            localeName,
                          ).format(DateTime(year, i + 1));
                          final tipStyle =
                              (textTheme.bodySmall ?? const TextStyle()).copyWith(
                            color: scheme.onInverseSurface,
                            fontSize: 11,
                            height: 1.25,
                          );
                          if (rodIndex == 0) {
                            final s = monthlyIncomeSettledUsd[i];
                            final p = monthlyIncomePendingUsd[i];
                            return BarTooltipItem(
                              '$m\n${l10n.reportsChartLegendIncome}\n'
                              '${l10n.reportsChartTooltipPaidReceived}: ',
                              tipStyle,
                              children: [
                                ...displayCurrencyInlineSpans(
                                  'USD',
                                  s,
                                  localeName,
                                  style: tipStyle,
                                ),
                                TextSpan(
                                  text:
                                      '\n${l10n.reportsChartTooltipStillScheduled}: ',
                                  style: tipStyle,
                                ),
                                ...displayCurrencyInlineSpans(
                                  'USD',
                                  p,
                                  localeName,
                                  style: tipStyle,
                                ),
                              ],
                            );
                          }
                          final s = monthlyExpenseSettledUsd[i];
                          final p = monthlyExpensePendingUsd[i];
                          return BarTooltipItem(
                            '$m\n${l10n.reportsChartLegendExpenses}\n'
                            '${l10n.reportsChartTooltipPaidReceived}: ',
                            tipStyle,
                            children: [
                              ...displayCurrencyInlineSpans(
                                'USD',
                                s,
                                localeName,
                                style: tipStyle,
                              ),
                              TextSpan(
                                text:
                                    '\n${l10n.reportsChartTooltipStillScheduled}: ',
                                style: tipStyle,
                              ),
                              ...displayCurrencyInlineSpans(
                                'USD',
                                p,
                                localeName,
                                style: tipStyle,
                              ),
                            ],
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
                          _cashflowStackedRod(
                            settled: monthlyIncomeSettledUsd[i],
                            pending: monthlyIncomePendingUsd[i],
                            maxYTrack: maxY,
                            width: 11,
                            topRadius: 8,
                            settledColor: incomeSettled,
                            pendingColor: incomePending,
                            trackColor: trackColor,
                          ),
                          _cashflowStackedRod(
                            settled: monthlyExpenseSettledUsd[i],
                            pending: monthlyExpensePendingUsd[i],
                            maxYTrack: maxY,
                            width: 11,
                            topRadius: 8,
                            settledColor: expenseSettled,
                            pendingColor: expensePending,
                            trackColor: trackColor,
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

/// Two stacked tall bars: income vs expenses for one period.
class ReportsPeriodCashflowBarChart extends StatelessWidget {
  const ReportsPeriodCashflowBarChart({
    super.key,
    required this.periodLabel,
    required this.incomeSettledUsd,
    required this.incomePendingUsd,
    required this.expenseSettledUsd,
    required this.expensePendingUsd,
    required this.localeName,
    required this.l10n,
  });

  final String periodLabel;
  final double incomeSettledUsd;
  final double incomePendingUsd;
  final double expenseSettledUsd;
  final double expensePendingUsd;
  final String localeName;
  final AppLocalizations l10n;

  static const double _chartHeight = 232;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final incomeSettled = reportChartIncomeBarColor(scheme);
    final incomePending = incomeSettled.withValues(alpha: 0.38);
    final expenseSettled = reportChartExpenseBarColor(scheme);
    final expensePending = expenseSettled.withValues(alpha: 0.38);

    final incomeTotal = incomeSettledUsd + incomePendingUsd;
    final expenseTotal = expenseSettledUsd + expensePendingUsd;
    final maxVal = incomeTotal > expenseTotal ? incomeTotal : expenseTotal;
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
                        color: incomeSettled,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      label: l10n.reportsChartLegendIncomeSettled,
                    ),
                    _LegendChip(
                      indicator: BoxDecoration(
                        color: incomePending,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      label: l10n.reportsChartLegendIncomePending,
                    ),
                    _LegendChip(
                      indicator: BoxDecoration(
                        color: expenseSettled,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      label: l10n.reportsChartLegendExpenseSettled,
                    ),
                    _LegendChip(
                      indicator: BoxDecoration(
                        color: expensePending,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      label: l10n.reportsChartLegendExpensePending,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  l10n.reportsChartCashflowStackFootnote,
                  style: textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.35,
                  ),
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
                          final s = isIncome ? incomeSettledUsd : expenseSettledUsd;
                          final p = isIncome ? incomePendingUsd : expensePendingUsd;
                          final title = isIncome
                              ? l10n.reportsChartLegendIncome
                              : l10n.reportsChartLegendExpenses;
                          final tipStyle =
                              (textTheme.bodySmall ?? const TextStyle()).copyWith(
                            color: scheme.onInverseSurface,
                            fontSize: 12,
                            height: 1.25,
                          );
                          return BarTooltipItem(
                            '$title\n'
                            '${l10n.reportsChartTooltipPaidReceived}: ',
                            tipStyle,
                            children: [
                              ...displayCurrencyInlineSpans(
                                'USD',
                                s,
                                localeName,
                                style: tipStyle,
                              ),
                              TextSpan(
                                text:
                                    '\n${l10n.reportsChartTooltipStillScheduled}: ',
                                style: tipStyle,
                              ),
                              ...displayCurrencyInlineSpans(
                                'USD',
                                p,
                                localeName,
                                style: tipStyle,
                              ),
                            ],
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
                          _cashflowStackedRod(
                            settled: incomeSettledUsd,
                            pending: incomePendingUsd,
                            maxYTrack: maxY,
                            width: 36,
                            topRadius: 12,
                            settledColor: incomeSettled,
                            pendingColor: incomePending,
                            trackColor: trackColor,
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          _cashflowStackedRod(
                            settled: expenseSettledUsd,
                            pending: expensePendingUsd,
                            maxYTrack: maxY,
                            width: 36,
                            topRadius: 12,
                            settledColor: expenseSettled,
                            pendingColor: expensePending,
                            trackColor: trackColor,
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
