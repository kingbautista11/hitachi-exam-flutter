import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

/// API failure carrying a user-safe message. Raw server/network errors are
/// never propagated to the UI to avoid leaking internals.
class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}

class ApiService {
  static const _headers = {'CLIENT_ID': AppConfig.clientId};

  // Resolves a path against the configured base URL and rejects non-TLS hosts.
  static Uri _endpoint(String path) {
    final uri = Uri.parse('${AppConfig.apiBaseUrl}$path');
    if (uri.scheme != 'https') {
      throw ApiException('Insecure connection blocked.');
    }
    return uri;
  }

  static Future<Map<String, dynamic>> login(String userName, String otp) async {
    try {
      final response = await http
          .post(
            _endpoint('/login'),
            headers: {..._headers, 'Content-Type': 'application/json'},
            body: jsonEncode({'userName': userName, 'otp': otp}),
          )
          .timeout(AppConfig.apiTimeout);
      return jsonDecode(response.body) as Map<String, dynamic>;
    } on ApiException {
      rethrow;
    } catch (_) {
      throw ApiException('Unable to reach the server. Please try again.');
    }
  }

  static Future<List<dynamic>> getSocials() async {
    try {
      final response = await http
          .get(_endpoint('/socials'), headers: _headers)
          .timeout(AppConfig.apiTimeout);
      return jsonDecode(response.body) as List<dynamic>;
    } on ApiException {
      rethrow;
    } catch (_) {
      throw ApiException('Unable to load data. Please try again.');
    }
  }
}
