import 'package:flutter/foundation.dart';

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
const String _kDefaultDevTestUserId = 'dev-local-test-user';

abstract final class CloudBackendEnv {
  static String get _resolvedApiBaseRaw {
    final fromDefine = _kApiBaseUrlDefine.trim();
    if (fromDefine.isNotEmpty) return fromDefine;
    if (kDebugMode) return _kDebugDefaultApiBaseUrl;
    return '';
  }

  static bool get isRemoteApiConfigured => _resolvedApiBaseRaw.isNotEmpty;

  static String get apiBaseUrl {
    assert(
      isRemoteApiConfigured,
      'CloudBackendEnv.apiBaseUrl requires a configured base URL',
    );
    return _resolvedApiBaseRaw.replaceAll(RegExp(r'/+$'), '');
  }

  static String get devDataSecret => _kDevDataSecretDefine.trim();

  static String get devTestUserId {
    final t = _kDevTestUserIdDefine.trim();
    return t.isNotEmpty ? t : _kDefaultDevTestUserId;
  }
}
