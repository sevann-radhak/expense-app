// Compile-time backend base URL for sync/API calls (`--dart-define`).
// The API lives in the separate **expense-app-backend** repo (clone next to this app).
// Empty = Flutter app is local-first only (Drift); no remote HTTP in Phase 5 wiring yet.
//
// Example (default local port from launchSettings — confirm after `dotnet run`):
// flutter run -d chrome --dart-define=AZURE_API_BASE_URL=http://localhost:5057
const String _kApiBaseUrl = String.fromEnvironment(
  'AZURE_API_BASE_URL',
  defaultValue: '',
);

abstract final class CloudBackendEnv {
  static bool get isRemoteApiConfigured => _kApiBaseUrl.trim().isNotEmpty;

  static String get apiBaseUrl {
    assert(
      isRemoteApiConfigured,
      'CloudBackendEnv.apiBaseUrl read when AZURE_API_BASE_URL is not set',
    );
    return _kApiBaseUrl.trim().replaceAll(RegExp(r'/+$'), '');
  }
}
