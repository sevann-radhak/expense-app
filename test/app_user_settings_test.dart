import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:expense_app/data/local/app_user_settings_storage.dart';
import 'package:expense_app/data/local/default_fx_rates_loader.dart';
import 'package:expense_app/presentation/providers/app_user_settings_provider.dart';

void main() {
  test('effectiveDefaultCurrencyForForm uses catalog when preference invalid', () {
    final catalog = DefaultFxCatalog(
      schemaVersion: 1,
      asOf: '2026-01-01',
      note: 't',
      defaultCurrencyCode: 'ARS',
      currencies: const [
        CurrencyOption(
          code: 'USD',
          nameEn: 'US dollar',
          localUnitsPerUsd: 1,
        ),
      ],
    );
    expect(effectiveDefaultCurrencyForForm('USD', catalog), 'USD');
    expect(effectiveDefaultCurrencyForForm('XYZ', catalog), 'ARS');
    expect(effectiveDefaultCurrencyForForm(null, catalog), 'ARS');
  });

  test('AppUserSettingsStorage round-trips locale and currency', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await AppUserSettingsStorage.writeLocaleLanguageCode(prefs, 'en');
    expect(AppUserSettingsStorage.readLocaleLanguageCode(prefs), 'en');
    await AppUserSettingsStorage.writeLocaleLanguageCode(prefs, null);
    expect(AppUserSettingsStorage.readLocaleLanguageCode(prefs), isNull);

    await AppUserSettingsStorage.writeDefaultCurrencyCode(prefs, 'eur');
    expect(AppUserSettingsStorage.readDefaultCurrencyCode(prefs), 'EUR');
    await AppUserSettingsStorage.writeDefaultCurrencyCode(prefs, null);
    expect(AppUserSettingsStorage.readDefaultCurrencyCode(prefs), isNull);
  });

  test('last payment instrument id round-trip', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await AppUserSettingsStorage.writeLastPaymentInstrumentId(prefs, 'pi_1');
    expect(AppUserSettingsStorage.readLastPaymentInstrumentId(prefs), 'pi_1');
    await AppUserSettingsStorage.writeLastPaymentInstrumentId(prefs, null);
    expect(AppUserSettingsStorage.readLastPaymentInstrumentId(prefs), isNull);
  });
}
