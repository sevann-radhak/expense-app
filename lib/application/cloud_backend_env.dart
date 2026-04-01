import 'package:flutter/foundation.dart';

// Compile-time backend base URL (`--dart-define` or `--dart-define-from-file`).
// The API lives in **expense-app-backend** (clone next to this app).
//
// Local workflow: copy `dart_defines/local.example.json` → `dart_defines/local.json` and run
// `flutter run -d chrome --dart-define-from-file=dart_defines/local.json`
// (VS Code: launch config "expense-app (web, local API)").
//
// In **debug** builds, if `AZURE_API_BASE_URL` is empty, defaults to http://localhost:5057.
const String _kApiBaseUrlDefine = String.fromEnvironment(
  'AZURE_API_BASE_URL',
  defaultValue: '',
);

const String _kDevDataSecretDefine = String.fromEnvironment(
  'DEV_DATA_SECRET',
  defaultValue: '',
);

const String _kDevTestUserIdDefine = String.fromEnvironment(
  'DEV_TEST_USER_ID',
  defaultValue: '',
);

const String _kDebugDefaultApiBaseUrl = 'http://localhost:5057';

abstract final class CloudBackendEnv {
  static String get _resolvedApiBaseRaw {
    final fromDefine = _kApiBaseUrlDefine.trim();
    if (fromDefine.isNotEmpty) {
      return fromDefine;
    }
    if (kDebugMode) {
      return _kDebugDefaultApiBaseUrl;
    }
    return '';
  }

  static bool get isRemoteApiConfigured => _resolvedApiBaseRaw.isNotEmpty;

  static String get apiBaseUrl {
    assert(
      isRemoteApiConfigured,
      'CloudBackendEnv.apiBaseUrl read when no API base URL is configured',
    );
    return _resolvedApiBaseRaw.replaceAll(RegExp(r'/+$'), '');
  }

  /// Optional `X-Dev-Data-Secret` when the API has `DevData:RequireSharedSecret` enabled.
  static String get devDataSecret => _kDevDataSecretDefine.trim();

  /// User id sent to `/api/dev/books/*` from the Settings debug section.
  static String get devTestUserId {
    final t = _kDevTestUserIdDefine.trim();
    if (t.isNotEmpty) {
      return t;
    }
    return 'dev-local-test-user';
  }
}
