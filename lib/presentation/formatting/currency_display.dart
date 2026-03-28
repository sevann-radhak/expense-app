import 'package:intl/intl.dart';

/// Symbols for common ISO 4217 codes. Prefer this over [NumberFormat.currencySymbol]
/// in `en` locale, which often repeats the code (e.g. "ARS" instead of "\$").
const Map<String, String> kDisplayCurrencySymbols = {
  'ARS': r'$',
  'USD': r'$',
  'EUR': '€',
  'GBP': '£',
  'BRL': r'R$',
  'COP': r'$',
  'CLP': r'$',
  'UYU': r'$',
  'PYG': '₲',
  'PEN': 'S/',
  'MXN': r'$',
  'BOB': 'Bs',
  'CHF': 'Fr. ',
  'JPY': '¥',
  'CAD': r'$',
  'AUD': r'$',
  'NZD': r'$',
  'CNY': '¥',
  'INR': '₹',
  'KRW': '₩',
  'RUB': '₽',
  'TRY': '₺',
  'ZAR': 'R',
  'SEK': 'kr',
  'NOK': 'kr',
  'DKK': 'kr',
};

/// CLDR-backed locales that usually yield a real symbol (not the ISO code).
String? _intlLocaleHintForCurrency(String code) {
  switch (code) {
    case 'ARS':
      return 'es_AR';
    case 'BRL':
      return 'pt_BR';
    case 'COP':
      return 'es_CO';
    case 'CLP':
      return 'es_CL';
    case 'MXN':
      return 'es_MX';
    case 'PEN':
      return 'es_PE';
    case 'UYU':
      return 'es_UY';
    case 'PYG':
      return 'es_PY';
    case 'EUR':
      return 'de_DE';
    case 'USD':
      return 'en_US';
    case 'GBP':
      return 'en_GB';
    default:
      return null;
  }
}

String _symbolFromIntl(String code, String intlLocale) {
  try {
    final f = NumberFormat.currency(
      locale: intlLocale,
      name: code,
      decimalDigits: 0,
    );
    return f.currencySymbol.trim();
  } catch (_) {
    return '';
  }
}

/// Resolved display symbol, never the raw ISO code when a better symbol exists.
String resolveDisplayCurrencySymbol(String currencyCode) {
  final code = currencyCode.toUpperCase();
  final mapped = kDisplayCurrencySymbols[code];
  if (mapped != null) {
    return mapped;
  }
  final hint = _intlLocaleHintForCurrency(code);
  if (hint != null) {
    final sym = _symbolFromIntl(code, hint);
    if (sym.isNotEmpty && sym.toUpperCase() != code) {
      return sym;
    }
  }
  final fallback = _symbolFromIntl(code, 'en_US');
  if (fallback.isNotEmpty && fallback.toUpperCase() != code) {
    return fallback;
  }
  return '';
}

/// Human line: `ARS $1,160,025.00`, `EUR €5.00`, `BRL R$123.45`, `PYG ₲…`.
///
/// [localeName] is an ICU locale string (e.g. from [Locale.toString]).
String formatDisplayCurrencyLine(
  String currencyCode,
  double amount,
  String localeName, {
  int decimalDigits = 2,
}) {
  final code = currencyCode.toUpperCase();
  final symbol = resolveDisplayCurrencySymbol(code);
  final number = NumberFormat.decimalPatternDigits(
    locale: localeName,
    decimalDigits: decimalDigits,
  ).format(amount);
  if (symbol.isEmpty) {
    return '$code $number';
  }
  return '$code $symbol$number';
}

/// Grouped number for display (e.g. `10,000.00` in `en_US`).
String formatAmountGrouped(double value, String localeName) {
  return NumberFormat.decimalPatternDigits(
    locale: localeName,
    decimalDigits: 2,
  ).format(value);
}

/// Plain amount while editing (no thousands), minimal decimals.
String formatAmountPlainForEdit(double value) {
  if (value == value.roundToDouble()) {
    return value.toInt().toString();
  }
  return value.toString();
}

/// Parses amount from field text (grouped or plain, locale-aware).
double? tryParseDecimalInput(String raw, String localeName) {
  final t = raw.trim();
  if (t.isEmpty) {
    return null;
  }
  try {
    return NumberFormat.decimalPattern(localeName).parse(t).toDouble();
  } catch (_) {
    final noSpaces = t.replaceAll(' ', '');
    final noCommasAsThousands = noSpaces.replaceAll(',', '');
    return double.tryParse(noCommasAsThousands);
  }
}

/// For labels like "Computed USD: $71.43" (symbol + number only).
String formatUsdAmountOnly(double amount, String localeName) {
  final sym = resolveDisplayCurrencySymbol('USD');
  final number = NumberFormat.decimalPatternDigits(
    locale: localeName,
    decimalDigits: 2,
  ).format(amount);
  return '$sym$number';
}
