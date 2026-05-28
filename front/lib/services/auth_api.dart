import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthApi {
  // Variable global en memoria para respaldar el token si la persistencia web falla
  static String? token;

  static const _storage = FlutterSecureStorage(
    webOptions: WebOptions(
      dbName: 'SplitEasySecure',
    ),
  );

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  static Uri _uri(String path) => Uri.parse('$baseUrl/auth$path');

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _post('/login', {
      'email': email,
      'password': password,
    });

    // 👁️ CHISMOSO 1: Ver qué nos está respondiendo NestJS exactamente
    print("==================================================");
    print("=== RESPUESTA COMPLETA DEL BACKEND EN LOGIN ===");
    print(response);
    print("==================================================");

    // Buscamos 'access_token' o 'token' por si cambió el formato en el Backend
    final jwt = response['access_token'] ?? response['token'];

    if (jwt != null) {
      token = jwt; // Guardado en memoria volátil
      await _storage.write(key: 'jwt_token', value: jwt); // Guardado en navegador
      
      // 👁️ CHISMOSO 2: Confirmar que la app procesó el guardado
      print("¡Token detectado y guardado con éxito! -> $jwt");
    } else {
      // 👁️ CHISMOSO 3: Advertencia por si las llaves no coinciden
      print("⚠️ ALERTA: No se encontró 'access_token' ni 'token' en la respuesta.");
    }

    return response;
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