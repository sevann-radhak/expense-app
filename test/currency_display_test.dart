import 'package:flutter_test/flutter_test.dart';

import 'package:expense_app/presentation/formatting/currency_display.dart';

void main() {
  test('resolveDisplayCurrencySymbol uses real glyphs, not ISO code', () {
    expect(resolveDisplayCurrencySymbol('ARS'), r'$');
    expect(resolveDisplayCurrencySymbol('USD'), r'$');
    expect(resolveDisplayCurrencySymbol('EUR'), '€');
    expect(resolveDisplayCurrencySymbol('BRL'), r'R$');
    expect(resolveDisplayCurrencySymbol('PYG'), '₲');
    expect(resolveDisplayCurrencySymbol('PEN'), 'S/');
  });

  test('formatDisplayCurrencyLine is CODE symbol amount', () {
    const loc = 'en_US';
    expect(
      formatDisplayCurrencyLine('ARS', 1160025, loc),
      r'ARS $1,160,025.00',
    );
    expect(
      formatDisplayCurrencyLine('EUR', 5, loc),
      'EUR €5.00',
    );
    expect(
      formatDisplayCurrencyLine('COP', 10000, loc),
      r'COP $10,000.00',
    );
    expect(
      formatDisplayCurrencyLine('USD', 837.51, loc),
      r'USD $837.51',
    );
  });

  test('formatAmountGrouped and tryParseDecimalInput round-trip en_US', () {
    const loc = 'en_US';
    expect(formatAmountGrouped(10000, loc), '10,000.00');
    expect(tryParseDecimalInput('10,000.00', loc), 10000.0);
    expect(tryParseDecimalInput('10000', loc), 10000.0);
    expect(formatUsdAmountOnly(71.43, loc), r'$71.43');
  });
}
