import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:expense_app/data/local/app_user_settings_storage.dart';
import 'package:expense_app/data/local/default_fx_rates_loader.dart';

/// Injected from [main] after [SharedPreferences.getInstance].
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw StateError('Override sharedPreferencesProvider in main() or tests.');
});

/// Persisted locale (language code) and default currency for new expenses.
final class AppUserSettings {
  const AppUserSettings({
    required this.localeLanguageCode,
    required this.defaultCurrencyCode,
  });

  /// `null` → device locale; otherwise fixed app language (e.g. `en`).
  final String? localeLanguageCode;

  /// `null` → use catalog JSON default; otherwise ISO 4217 code (uppercase).
  final String? defaultCurrencyCode;
}

/// Resolves which currency code to preselect on **new** expense forms.
String effectiveDefaultCurrencyForForm(
  String? storedPreference,
  DefaultFxCatalog catalog,
) {
  if (storedPreference != null && storedPreference.isNotEmpty) {
    final o = catalog.optionForCode(storedPreference);
    if (o != null) {
      return o.code.toUpperCase();
    }
  }
  return catalog.defaultCurrencyCode.toUpperCase();
}

final class AppUserSettingsNotifier extends StateNotifier<AppUserSettings> {
  AppUserSettingsNotifier(this._prefs) : super(_read(_prefs));

  final SharedPreferences _prefs;

  static AppUserSettings _read(SharedPreferences prefs) {
    final rawLang = AppUserSettingsStorage.readLocaleLanguageCode(prefs);
    return AppUserSettings(
      localeLanguageCode: rawLang == 'en' ? 'en' : null,
      defaultCurrencyCode: AppUserSettingsStorage.readDefaultCurrencyCode(prefs),
    );
  }

  Future<void> setLocaleLanguageCode(String? languageCode) async {
    await AppUserSettingsStorage.writeLocaleLanguageCode(_prefs, languageCode);
    state = _read(_prefs);
  }

  Future<void> setDefaultCurrencyCode(String? code) async {
    await AppUserSettingsStorage.writeDefaultCurrencyCode(_prefs, code);
    state = _read(_prefs);
  }
}

final appUserSettingsProvider =
    StateNotifierProvider<AppUserSettingsNotifier, AppUserSettings>((ref) {
      return AppUserSettingsNotifier(ref.watch(sharedPreferencesProvider));
    });
