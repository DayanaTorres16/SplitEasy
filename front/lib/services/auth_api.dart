import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthApi {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  static Uri _uri(String path) => Uri.parse('$baseUrl/auth$path');

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) {
    return _post('/login', {
      'email': email,
      'password': password,
    });
  }

  static Future<Map<String, dynamic>> register({
    required String name,
    required String lastName,
    required String email,
    required String password,
  }) {
    return _post('/register', {
      'name': name,
      'lastName': lastName,
      'email': email,
      'password': password,
    });
  }

  static Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) {
    return _post('/forgot-password', {
      'email': email,
    });
  }

  static Future<Map<String, dynamic>> resetPassword({
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) {
    return _post('/reset-password', {
      'token': token,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    });
  }

  static Future<Map<String, dynamic>> _post(
    String path,
    Map<String, String> body,
  ) async {
    final response = await http.post(
      _uri(path),
      headers: const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(body),
    );

    final decoded = response.body.isNotEmpty ? jsonDecode(response.body) : null;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return {'data': decoded};
    }

    throw Exception(_extractMessage(decoded) ?? 'Error al conectar con el servidor');
  }

  static String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final message = data['message'] ?? data['mensaje'];
      if (message is String) return message;
      if (message is List && message.isNotEmpty) {
        return message.first.toString();
      }
      if (message != null) return message.toString();
    }

    if (data is String && data.isNotEmpty) {
      return data;
    }

    return null;
  }
}