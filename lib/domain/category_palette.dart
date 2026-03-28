/// Muted pastel fills (ARGB) for stable category identity in charts and lists.
/// Pure Dart — use `Color(argb)` in Flutter presentation code.
const List<int> kCategoryPastelArgb = <int>[
  0xFFE8A0A8,
  0xFFF0C987,
  0xFFC8E6C9,
  0xFFBBDEFB,
  0xFFD1C4E9,
  0xFFFFF59D,
  0xFFB2DFDB,
  0xFFF8BBD0,
  0xFFFFCCBC,
  0xFFCFD8DC,
  0xFFB2EBF2,
  0xFFD7CCC8,
  0xFFC5E1A5,
  0xFFFFE082,
  0xFF9FA8DA,
  0xFFA5D6A7,
];

/// Deterministic index in `[0, modulo)` from [key] (e.g. category id).
int categoryPaletteIndex(String key, int modulo) {
  var h = 5381;
  for (final u in key.codeUnits) {
    h = ((h << 5) + h) + u;
  }
  final m = h.abs() % modulo;
  return m;
}

/// ARGB fill for a category; same id always maps to the same color.
int categoryFillArgb(String categoryId) {
  return kCategoryPastelArgb[
      categoryPaletteIndex(categoryId, kCategoryPastelArgb.length)];
}
