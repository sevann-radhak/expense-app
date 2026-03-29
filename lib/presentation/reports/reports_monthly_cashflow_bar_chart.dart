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

  static const double _chartHeight = 240;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final textTheme = theme.textTheme;
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
    final maxY = maxVal <= 0 ? 1.0 : maxVal * 1.18;

    return Semantics(
      label: l10n.reportsChartCashflowSemanticLabel,
      container: true,
      child: Card(
        key: const ValueKey<String>('reports-monthly-cashflow-bar-chart'),
        elevation: 0,
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  l10n.reportsChartMonthlyCashflowTitle,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _LegendChip(
                      color: incomeColor,
                      label: l10n.reportsChartLegendIncome,
                    ),
                    _LegendChip(
                      color: expenseColor,
                      label: l10n.reportsChartLegendExpenses,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: _chartHeight,
                child: BarChart(
                  BarChartData(
                    minY: 0,
                    maxY: maxY,
                    alignment: BarChartAlignment.spaceAround,
                    groupsSpace: 6,
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
                      horizontalInterval:
                          maxY <= 0 ? 1 : (maxY / 4).clamp(0.5, double.infinity),
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: scheme.outlineVariant.withValues(alpha: 0.35),
                        strokeWidth: 1,
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: List.generate(12, (i) {
                      return BarChartGroupData(
                        x: i,
                        barsSpace: 2,
                        barRods: [
                          BarChartRodData(
                            toY: monthlyIncomeUsd[i],
                            color: incomeColor,
                            width: 7,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(3),
                            ),
                          ),
                          BarChartRodData(
                            toY: monthlyExpenseUsd[i],
                            color: expenseColor,
                            width: 7,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(3),
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

class _LegendChip extends StatelessWidget {
  const _LegendChip({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: theme.textTheme.labelMedium),
      ],
    );
  }
}
