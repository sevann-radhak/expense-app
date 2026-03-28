import 'package:flutter_test/flutter_test.dart';

import 'package:expense_app/domain/category_palette.dart';

void main() {
  test('categoryFillArgb is stable for the same id', () {
    expect(categoryFillArgb('cat_leisure'), categoryFillArgb('cat_leisure'));
  });

  test('categoryPaletteIndex stays within range', () {
    for (final id in ['a', 'cat_x', List.filled(30, 'x').join()]) {
      final i = categoryPaletteIndex(id, kCategoryPastelArgb.length);
      expect(i, greaterThanOrEqualTo(0));
      expect(i, lessThan(kCategoryPastelArgb.length));
    }
  });
}
