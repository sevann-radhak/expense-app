import 'package:flutter/material.dart';

/// Single-series monthly chart uses theme primary (not per-category).
Color reportChartMonthlyBarColor(ColorScheme scheme) => scheme.primary;

Color reportChartExpenseBarColor(ColorScheme scheme) => scheme.primary;

Color reportChartIncomeBarColor(ColorScheme scheme) => scheme.tertiary;

LinearGradient reportChartIncomeBarGradient(ColorScheme scheme) {
  final hi = scheme.tertiary;
  final lo = Color.alphaBlend(hi.withValues(alpha: 0.42), scheme.surface);
  return LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [lo, hi],
  );
}

LinearGradient reportChartExpenseBarGradient(ColorScheme scheme) {
  final hi = scheme.primary;
  final lo = Color.alphaBlend(hi.withValues(alpha: 0.38), scheme.surface);
  return LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [lo, hi],
  );
}
