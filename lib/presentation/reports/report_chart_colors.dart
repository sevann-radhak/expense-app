import 'package:flutter/material.dart';

// TODO(phase-2.5): Replace with a shared CategoryColorResolver so category
// colors stay stable and match lists, Categories screen, and Home rows.

/// M3-harmonized fills for pie/doughnut segments until per-category identity lands.
List<Color> reportChartCategoryFills(ColorScheme scheme, int count) {
  final seeds = <Color>[
    scheme.primary,
    scheme.secondary,
    scheme.tertiary,
    scheme.primaryContainer,
    scheme.secondaryContainer,
    scheme.tertiaryContainer,
    Color.alphaBlend(scheme.primary.withValues(alpha: 0.6), scheme.surface),
    Color.alphaBlend(scheme.secondary.withValues(alpha: 0.55), scheme.surface),
    Color.alphaBlend(scheme.tertiary.withValues(alpha: 0.55), scheme.surface),
    scheme.primary.withValues(alpha: 0.75),
    scheme.secondary.withValues(alpha: 0.75),
    scheme.tertiary.withValues(alpha: 0.75),
  ];
  return List.generate(count, (i) => seeds[i % seeds.length]);
}

Color reportChartMonthlyBarColor(ColorScheme scheme) => scheme.primary;
