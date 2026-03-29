import 'package:flutter/material.dart';

/// Single-series monthly chart uses theme primary (not per-category).
Color reportChartMonthlyBarColor(ColorScheme scheme) => scheme.primary;

Color reportChartExpenseBarColor(ColorScheme scheme) => scheme.primary;

Color reportChartIncomeBarColor(ColorScheme scheme) => scheme.tertiary;
