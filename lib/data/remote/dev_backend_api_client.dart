import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:expense_app/application/cloud_backend_env.dart';

/// Calls **development-only** book endpoints on `expense-app-backend` (Phase 5.b).
/// Requires `--dart-define=AZURE_API_BASE_URL=http://localhost:5057` (no trailing slash).
///
/// Optional shared secret: `CloudBackendEnv.devDataSecret` (`DEV_DATA_SECRET` in
/// `dart_defines/local.json` or `--dart-define`) when the API uses
/// `DevData:RequireSharedSecret` + `DevData:SharedSecret`.
class DevBackendApiClient {
  DevBackendApiClient({http.Client? httpClient})
      : _client = httpClient ?? http.Client();

  final http.Client _client;

  void _ensureConfigured() {
    if (!CloudBackendEnv.isRemoteApiConfigured) {
      throw StateError(
        'AZURE_API_BASE_URL is not set. Pass --dart-define=AZURE_API_BASE_URL=http://localhost:5057 '
        'to call dev backend endpoints.',
      );
    }
  }

  Uri _uri(String path) =>
      Uri.parse('${CloudBackendEnv.apiBaseUrl}/api/dev/books$path');

  Map<String, String> _headers() => {
        'Content-Type': 'application/json',
        if (CloudBackendEnv.devDataSecret.isNotEmpty)
          'X-Dev-Data-Secret': CloudBackendEnv.devDataSecret,
      };

  /// POST `/api/dev/books/reset` — removes all book rows for [userId].
  Future<void> resetBook({required String userId}) async {
    _ensureConfigured();
    final res = await _client.post(
      _uri('/reset'),
      headers: _headers(),
      body: jsonEncode({'userId': userId}),
    );
    _throwIfFailed(res);
  }

  /// POST `/api/dev/books/seed-taxonomy` — default expense + income taxonomy.
  Future<void> seedTaxonomy({required String userId}) async {
    _ensureConfigured();
    final res = await _client.post(
      _uri('/seed-taxonomy'),
      headers: _headers(),
      body: jsonEncode({'userId': userId}),
    );
    _throwIfFailed(res);
  }

  /// POST `/api/dev/books/seed-demo` — reset + taxonomy + sample rows.
  Future<void> seedDemo({required String userId}) async {
    _ensureConfigured();
    final res = await _client.post(
      _uri('/seed-demo'),
      headers: _headers(),
      body: jsonEncode({'userId': userId}),
    );
    _throwIfFailed(res);
  }

  void _throwIfFailed(http.Response res) {
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return;
    }
    throw DevBackendApiException(res.statusCode, res.body);
  }

  void close() => _client.close();
}

final class DevBackendApiException implements Exception {
  DevBackendApiException(this.statusCode, this.body);
  final int statusCode;
  final String body;

  @override
  String toString() => 'DevBackendApiException($statusCode): $body';
}
