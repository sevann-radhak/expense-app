import 'package:flutter/material.dart';

import 'package:expense_app/domain/category_palette.dart';

Color categoryAccentColor(String categoryId) =>
    Color(categoryFillArgb(categoryId));

/// Tonal steps from [parent] toward white by sibling index (not per-sub id rainbow).
Color subcategoryTonalColor(Color parent, int index, int siblingCount) {
  if (siblingCount <= 1) {
    return parent;
  }
  final t = 0.08 + (index / (siblingCount - 1)) * 0.22;
  return Color.lerp(parent, const Color(0xFFFFFFFF), t)!;
}
