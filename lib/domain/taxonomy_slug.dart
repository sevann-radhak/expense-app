import 'package:expense_app/domain/category.dart';

/// Produces a URL-safe slug from a user label; avoids colliding with [kOtherSubcategorySlug].
String slugifyTaxonomyName(String raw) {
  final lower = raw.trim().toLowerCase();
  if (lower.isEmpty) {
    return 'custom';
  }
  final buf = StringBuffer();
  var pendingUnderscore = false;
  for (final rune in lower.runes) {
    final c = String.fromCharCode(rune);
    if (RegExp('[a-z0-9]').hasMatch(c)) {
      if (pendingUnderscore && buf.isNotEmpty) {
        buf.write('_');
        pendingUnderscore = false;
      }
      buf.write(c);
    } else if (c == ' ' || c == '-' || c == '_') {
      pendingUnderscore = buf.isNotEmpty;
    }
  }
  var out = buf.toString();
  while (out.contains('__')) {
    out = out.replaceAll('__', '_');
  }
  out = out.replaceAll(RegExp(r'^_|_$'), '');
  if (out.isEmpty) {
    return 'custom';
  }
  if (out == kOtherSubcategorySlug) {
    return 'custom_label';
  }
  return out;
}
