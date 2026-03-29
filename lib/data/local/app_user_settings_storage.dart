import 'package:shared_preferences/shared_preferences.dart';

/// Keys for app-wide UI preferences stored with [SharedPreferences].
///
/// Book data stays in Drift; these values are device-local and easy to reset
/// without touching expenses or categories.
final class AppUserSettingsStorage {
  AppUserSettingsStorage._();

  static const localeLanguageCodeKey = 'user_locale_language_code';
  static const defaultCurrencyCodeKey = 'user_default_currency_code';
  static const lastPaymentInstrumentIdKey = 'user_last_payment_instrument_id';

  /// `null` or empty stored value means follow the device locale (with app fallback).
  static String? readLocaleLanguageCode(SharedPreferences prefs) {
    final v = prefs.getString(localeLanguageCodeKey);
    if (v == null || v.trim().isEmpty) {
      return null;
    }
    return v.trim().toLowerCase();
  }

  static Future<void> writeLocaleLanguageCode(
    SharedPreferences prefs,
    String? languageCode,
  ) async {
    if (languageCode == null || languageCode.trim().isEmpty) {
      await prefs.remove(localeLanguageCodeKey);
    } else {
      await prefs.setString(localeLanguageCodeKey, languageCode.trim().toLowerCase());
    }
  }

  /// `null` or empty means use the default currency from `default_fx_rates.json`.
  static String? readDefaultCurrencyCode(SharedPreferences prefs) {
    final v = prefs.getString(defaultCurrencyCodeKey);
    if (v == null || v.trim().isEmpty) {
      return null;
    }
    return v.trim().toUpperCase();
  }

  static Future<void> writeDefaultCurrencyCode(
    SharedPreferences prefs,
    String? code,
  ) async {
    if (code == null || code.trim().isEmpty) {
      await prefs.remove(defaultCurrencyCodeKey);
    } else {
      await prefs.setString(defaultCurrencyCodeKey, code.trim().toUpperCase());
    }
  }

  static String? readLastPaymentInstrumentId(SharedPreferences prefs) {
    return prefs.getString(lastPaymentInstrumentIdKey);
  }

  static Future<void> writeLastPaymentInstrumentId(
    SharedPreferences prefs,
    String? id,
  ) async {
    if (id == null || id.trim().isEmpty) {
      await prefs.remove(lastPaymentInstrumentIdKey);
    } else {
      await prefs.setString(lastPaymentInstrumentIdKey, id.trim());
    }
  }
}
