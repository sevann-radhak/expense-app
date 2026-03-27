import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

/// One supported currency. [localUnitsPerUsd] means **1 USD = localUnitsPerUsd
/// units** of this currency (e.g. 1 USD = 1050 ARS).
class CurrencyOption {
  const CurrencyOption({
    required this.code,
    required this.nameEn,
    required this.localUnitsPerUsd,
  });

  final String code;
  final String nameEn;

  /// How many units of [code] equal **1 USD** (human-readable quote).
  final double localUnitsPerUsd;

  /// Stored in DB as [Expense.manualFxRateToUsd]: multiply amount by this for USD.
  double get usdMultiplier => 1.0 / localUnitsPerUsd;

  String get menuLabel => '$code — $nameEn';
}

/// Parsed content of [default_fx_rates.json].
class DefaultFxCatalog {
  const DefaultFxCatalog({
    required this.schemaVersion,
    required this.asOf,
    required this.note,
    required this.defaultCurrencyCode,
    required this.currencies,
  });

  final int schemaVersion;
  final String asOf;
  final String note;
  final String defaultCurrencyCode;
  final List<CurrencyOption> currencies;

  CurrencyOption? optionForCode(String code) {
    final u = code.toUpperCase();
    for (final c in currencies) {
      if (c.code == u) {
        return c;
      }
    }
    return null;
  }

  /// **1 USD =** this many units of [code] (default `1.0` if unknown).
  double localUnitsPerUsdFor(String code) {
    return optionForCode(code)?.localUnitsPerUsd ?? 1.0;
  }
}

const String kDefaultFxRatesAssetPath = 'assets/data/default_fx_rates.json';

/// Parses the JSON document (same shape as [kDefaultFxRatesAssetPath]).
DefaultFxCatalog parseDefaultFxCatalogFromJson(String raw) {
  final map = jsonDecode(raw) as Map<String, dynamic>;
  final list = map['currencies'] as List<dynamic>? ?? [];
  final currencies = list.map((e) {
    final m = e as Map<String, dynamic>;
    return CurrencyOption(
      code: (m['code'] as String).toUpperCase(),
      nameEn: m['nameEn'] as String,
      localUnitsPerUsd: (m['localUnitsPerUsd'] as num).toDouble(),
    );
  }).toList();
  return DefaultFxCatalog(
    schemaVersion: (map['schemaVersion'] as num?)?.toInt() ?? 1,
    asOf: map['asOf'] as String? ?? '',
    note: map['note'] as String? ?? '',
    defaultCurrencyCode:
        (map['defaultCurrencyCode'] as String? ?? 'ARS').toUpperCase(),
    currencies: currencies,
  );
}

Future<DefaultFxCatalog> loadDefaultFxCatalog() async {
  final raw = await rootBundle.loadString(kDefaultFxRatesAssetPath);
  return parseDefaultFxCatalogFromJson(raw);
}

/// Pretty string for the FX field (units of local currency per 1 USD).
String formatLocalUnitsPerUsdForField(double v) {
  if (v == 1.0) {
    return '1';
  }
  if (v == v.roundToDouble() && v.abs() < 1e15) {
    return v.toInt().toString();
  }
  final s = v.toStringAsFixed(8);
  var t = s.replaceFirst(RegExp(r'0+$'), '');
  t = t.replaceFirst(RegExp(r'\.$'), '');
  return t.isEmpty ? '0' : t;
}
