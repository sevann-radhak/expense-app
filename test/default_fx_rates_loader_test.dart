import 'package:flutter_test/flutter_test.dart';

import 'package:expense_app/data/local/default_fx_rates_loader.dart';

void main() {
  test('parseDefaultFxCatalogFromJson reads localUnitsPerUsd and multiplier', () {
    const raw = '''
{
  "schemaVersion": 1,
  "asOf": "2026-03-27",
  "note": "test",
  "defaultCurrencyCode": "ARS",
  "currencies": [
    { "code": "ARS", "nameEn": "Argentine peso", "localUnitsPerUsd": 1000 },
    { "code": "USD", "nameEn": "US dollar", "localUnitsPerUsd": 1 }
  ]
}
''';
    final c = parseDefaultFxCatalogFromJson(raw);
    expect(c.defaultCurrencyCode, 'ARS');
    expect(c.localUnitsPerUsdFor('ARS'), 1000);
    expect(c.optionForCode('ARS')!.usdMultiplier, 0.001);
    expect(c.localUnitsPerUsdFor('USD'), 1);
    expect(c.optionForCode('USD')!.usdMultiplier, 1.0);
    expect(formatLocalUnitsPerUsdForField(1.0), '1');
    expect(formatLocalUnitsPerUsdForField(1050), '1050');
  });
}
