import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:expense_app/application/cloud_backend_env.dart';

class DevBackendApiClient {
  DevBackendApiClient({http.Client? httpClient})
      : _client = httpClient ?? http.Client();

  final http.Client _client;

  static const _basePath = '/api/dev/books';

  Future<void> resetBook({required String userId}) =>
      _post('/reset', userId);

  Future<void> seedTaxonomy({required String userId}) =>
      _post('/seed-taxonomy', userId);

  Future<void> seedDemo({required String userId}) =>
      _post('/seed-demo', userId);

  Future<void> _post(String path, String userId) async {
    if (!CloudBackendEnv.isRemoteApiConfigured) {
      throw StateError(
        'Remote API base URL is not configured (set AZURE_API_BASE_URL or use debug default).',
      );
    }
    final uri = Uri.parse('${CloudBackendEnv.apiBaseUrl}$_basePath$path');
    final headers = <String, String>{
      'Content-Type': 'application/json',
      if (CloudBackendEnv.devDataSecret.isNotEmpty)
        'X-Dev-Data-Secret': CloudBackendEnv.devDataSecret,
    };
    final response = await _client.post(
      uri,
      headers: headers,
      body: jsonEncode({'userId': userId}),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw DevBackendApiException(response.statusCode, response.body);
    }
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
