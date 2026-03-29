import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:expense_app/l10n/app_localizations.dart';
import 'package:expense_app/presentation/formatting/currency_display.dart';
import 'package:expense_app/presentation/reports/report_chart_colors.dart';

/// Bar chart: 12 months of USD totals for [year]. Table remains the source of truth; this supplements visually.
class ReportsMonthlyBarChart extends StatelessWidget {
  const ReportsMonthlyBarChart({
    super.key,
    required this.year,
    required this.monthlyUsd,
    required this.localeName,
    required this.l10n,
  });

  final int year;
  final List<double> monthlyUsd;
  final String localeName;
  final AppLocalizations l10n;

  static const double _chartHeight = 220;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final maxVal = monthlyUsd.fold<double>(0, (a, b) => a > b ? a : b);
    final maxY = maxVal <= 0 ? 1.0 : maxVal * 1.15;
    final barColor = reportChartMonthlyBarColor(scheme);

    return Semantics(
      label: l10n.reportsChartMonthlySemanticLabel,
      container: true,
      child: Card(
        key: const ValueKey<String>('reports-monthly-bar-chart'),
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
                  l10n.reportsChartMonthlyTitle,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
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
                    groupsSpace: 4,
                    barTouchData: BarTouchData(
                      handleBuiltInTouches: true,
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (_) => scheme.inverseSurface,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final i = group.x;
                          if (i < 0 || i > 11) {
                            return null;
                          }
                          final v = monthlyUsd[i];
                          final m = DateFormat.MMM(
                            localeName,
                          ).format(DateTime(year, i + 1));
                          final tipStyle =
                              (textTheme.bodySmall ?? const TextStyle()).copyWith(
                            color: scheme.onInverseSurface,
                            fontSize: 12,
                          );
                          return BarTooltipItem(
                            '$m\n',
                            tipStyle,
                            children: displayCurrencyInlineSpans(
                              'USD',
                              v,
                              localeName,
                              style: tipStyle,
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
                        barRods: [
                          BarChartRodData(
                            toY: monthlyUsd[i],
                            color: barColor,
                            width: 10,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
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
