import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

({String whole, String? fractionWithSep}) _splitFormattedAmount(
  NumberFormat format,
  String formatted,
) {
  final sep = format.symbols.DECIMAL_SEP;
  if (sep.isEmpty) {
    return (whole: formatted, fractionWithSep: null);
  }
  final i = formatted.lastIndexOf(sep);
  if (i < 0) {
    return (whole: formatted, fractionWithSep: null);
  }
  return (
    whole: formatted.substring(0, i),
    fractionWithSep: formatted.substring(i),
  );
}

NumberFormat _amountFormat(String localeName, int decimalDigits) {
  return NumberFormat.decimalPatternDigits(
    locale: localeName,
    decimalDigits: decimalDigits,
  );
}

/// Smaller style for fractional digits (separator + decimals) relative to [base].
TextStyle amountFractionTextStyle(TextStyle base, {double scale = 0.72}) {
  final fs = base.fontSize ?? 14.0;
  return base.copyWith(
    fontSize: fs * scale,
    height: 1.05,
  );
}

List<TextSpan> displayCurrencyInlineSpans(
  String currencyCode,
  double amount,
  String localeName, {
  int decimalDigits = 2,
  TextStyle? style,
  TextStyle? fractionStyle,
}) {
  final base = style ?? const TextStyle();
  final fracStyle = fractionStyle ?? amountFractionTextStyle(base);
  final code = currencyCode.toUpperCase();
  final symbol = resolveDisplayCurrencySymbol(code);
  final fmt = _amountFormat(localeName, decimalDigits);
  final numStr = fmt.format(amount);
  final parts = _splitFormattedAmount(fmt, numStr);
  final prefix = symbol.isEmpty ? '$code ' : '$code $symbol';
  return [
    TextSpan(text: prefix, style: base),
    TextSpan(text: parts.whole, style: base),
    if (parts.fractionWithSep != null)
      TextSpan(text: parts.fractionWithSep!, style: fracStyle),
  ];
}

TextSpan displayCurrencyLineTextSpan(
  String currencyCode,
  double amount,
  String localeName, {
  int decimalDigits = 2,
  TextStyle? style,
  TextStyle? fractionStyle,
}) {
  final base = style ?? const TextStyle();
  return TextSpan(
    style: base,
    children: displayCurrencyInlineSpans(
      currencyCode,
      amount,
      localeName,
      decimalDigits: decimalDigits,
      style: base,
      fractionStyle: fractionStyle,
    ),
  );
}

List<TextSpan> usdAmountOnlyInlineSpans(
  double amount,
  String localeName, {
  TextStyle? style,
  TextStyle? fractionStyle,
}) {
  final base = style ?? const TextStyle();
  final sym = resolveDisplayCurrencySymbol('USD');
  final fmt = _amountFormat(localeName, 2);
  final numStr = fmt.format(amount);
  final parts = _splitFormattedAmount(fmt, numStr);
  final fracStyle = fractionStyle ?? amountFractionTextStyle(base);
  return [
    TextSpan(text: sym, style: base),
    TextSpan(text: parts.whole, style: base),
    if (parts.fractionWithSep != null)
      TextSpan(text: parts.fractionWithSep!, style: fracStyle),
  ];
}

TextSpan usdAmountOnlyTextSpan(
  double amount,
  String localeName, {
  TextStyle? style,
  TextStyle? fractionStyle,
}) {
  final base = style ?? const TextStyle();
  return TextSpan(
    style: base,
    children: usdAmountOnlyInlineSpans(
      amount,
      localeName,
      style: base,
      fractionStyle: fractionStyle,
    ),
  );
}

List<TextSpan> groupedAmountInlineSpans(
  double value,
  String localeName, {
  TextStyle? style,
  TextStyle? fractionStyle,
}) {
  final base = style ?? const TextStyle();
  final fmt = _amountFormat(localeName, 2);
  final numStr = fmt.format(value);
  final parts = _splitFormattedAmount(fmt, numStr);
  final fracStyle = fractionStyle ?? amountFractionTextStyle(base);
  return [
    TextSpan(text: parts.whole, style: base),
    if (parts.fractionWithSep != null)
      TextSpan(text: parts.fractionWithSep!, style: fracStyle),
  ];
}

TextSpan groupedAmountTextSpan(
  double value,
  String localeName, {
  TextStyle? style,
  TextStyle? fractionStyle,
}) {
  final base = style ?? const TextStyle();
  return TextSpan(
    style: base,
    children: groupedAmountInlineSpans(
      value,
      localeName,
      style: base,
      fractionStyle: fractionStyle,
    ),
  );
}

String formatDisplayCurrencyLine(
  String currencyCode,
  double amount,
  String localeName, {
  int decimalDigits = 2,
}) {
  final code = currencyCode.toUpperCase();
  final symbol = resolveDisplayCurrencySymbol(code);
  final number = _amountFormat(localeName, decimalDigits).format(amount);
  if (symbol.isEmpty) {
    return '$code $number';
  }
  return '$code $symbol$number';
}

String formatAmountGrouped(double value, String localeName) {
  return _amountFormat(localeName, 2).format(value);
}

String formatAmountPlainForEdit(double value) {
  if (value == value.roundToDouble()) {
    return value.toInt().toString();
  }
  return value.toString();
}

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

String formatUsdAmountOnly(double amount, String localeName) {
  final sym = resolveDisplayCurrencySymbol('USD');
  final number = _amountFormat(localeName, 2).format(amount);
  return '$sym$number';
}
