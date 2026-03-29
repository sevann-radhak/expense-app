import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:expense_app/domain/domain.dart';
import 'package:expense_app/l10n/app_localizations.dart';
import 'package:expense_app/presentation/formatting/currency_display.dart';

/// Doughnut + text legend (names, USD, %) — color is not the only cue.
class ReportsCategoryPieChart extends StatelessWidget {
  const ReportsCategoryPieChart({
    super.key,
    required this.aggregates,
    required this.periodTotalUsd,
    required this.categoryName,
    required this.localeName,
    required this.l10n,
    this.chartTitle,
    this.semanticLabel,
    this.cardKey,
  });

  /// Distinguishes multiple pies on one screen (e.g. expenses vs income).
  final Key? cardKey;

  final List<CategoryUsdAggregate> aggregates;
  final double periodTotalUsd;
  final Map<String, String> categoryName;
  final String localeName;
  final AppLocalizations l10n;

  /// When null, uses [AppLocalizations.reportsChartCategoryTitle].
  final String? chartTitle;

  /// When null, uses [AppLocalizations.reportsChartCategorySemanticLabel].
  final String? semanticLabel;

  static String _pct(double part, double whole) {
    if (whole <= 0) {
      return '0%';
    }
    return '${((part / whole) * 100).toStringAsFixed(1)}%';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final colors = aggregates
        .map((a) => Color(categoryFillArgb(a.categoryId)))
        .toList();
    const pieSize = 200.0;

    final sections = <PieChartSectionData>[];
    for (var i = 0; i < aggregates.length; i++) {
      final row = aggregates[i];
      sections.add(
        PieChartSectionData(
          value: row.totalUsd,
          color: colors[i],
          radius: 72,
          showTitle: false,
        ),
      );
    }

    final chart = SizedBox(
      width: pieSize,
      height: pieSize,
      child: PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 44,
          centerSpaceColor: scheme.surfaceContainerLow,
          sectionsSpace: 1,
        ),
      ),
    );

    final legend = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < aggregates.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.only(top: 4, right: 8),
                  decoration: BoxDecoration(
                    color: colors[i],
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(
                      color: scheme.outlineVariant.withValues(alpha: 0.6),
                    ),
                  ),
                ),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      style: textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text:
                              '${categoryName[aggregates[i].categoryId] ?? l10n.taxonomyUnknownLabel}: ',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        TextSpan(
                          text:
                              '${formatDisplayCurrencyLine('USD', aggregates[i].totalUsd, localeName)} (${_pct(aggregates[i].totalUsd, periodTotalUsd)})',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );

    final title = chartTitle ?? l10n.reportsChartCategoryTitle;
    final a11y = semanticLabel ?? l10n.reportsChartCategorySemanticLabel;

    return Semantics(
      label: a11y,
      container: true,
      child: Card(
        key: cardKey ?? const ValueKey<String>('reports-category-pie-chart'),
        elevation: 0,
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth >= 520) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        chart,
                        const SizedBox(width: 16),
                        Expanded(child: legend),
                      ],
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      chart,
                      const SizedBox(height: 12),
                      legend,
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
