import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_api.dart';
import 'api_config.dart';

class GroupApi {
  static final String _baseUrl =
      '${ApiConfig.normalize(ApiConfig.baseUrl)}/grupos';

  static const _storage = FlutterSecureStorage(
    webOptions: WebOptions(dbName: 'SplitEasySecure'),
  );

  static Future<bool> createGroup(Map<String, dynamic> groupData) async {
    try {
      String? token = await _storage.read(key: 'jwt_token');
      if (token == null || token.isEmpty) {
        token = AuthApi.token;
      }

      print("==================================================");
      print("=== INTENTO DE LEER TOKEN EN CREAR GRUPO ===");
      print("Token recuperado para enviar: $token");
      print("==================================================");

      if (token == null || token.isEmpty) {
        throw Exception('No se encontró un token de autenticación válido.');
      }

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(groupData),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        final errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['message'] ?? 'Error al crear el grupo');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchUsers() async {
    try {
      String? token = await _storage.read(key: 'jwt_token');
      if (token == null || token.isEmpty) token = AuthApi.token;

      final uri = Uri.parse(ApiConfig.normalize(ApiConfig.baseUrl) + '/users');

      // First try with Authorization header if we have a token
      if (token != null && token.isNotEmpty) {
        final response = await http.get(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body);
          return data.cast<Map<String, dynamic>>();
        }
        // If auth failed or other error, fall through to try without auth for diagnosis
        print('fetchUsers: first request failed (status ${response.statusCode}), trying without Authorization for diagnosis');
      }

      // Fallback: try without Authorization (diagnostic only)
      final responseNoAuth = await http.get(uri, headers: {'Content-Type': 'application/json'});
      if (responseNoAuth.statusCode == 200) {
        final List<dynamic> data = jsonDecode(responseNoAuth.body);
        print('fetchUsers: succeeded without Authorization (diagnostic)');
        return data.cast<Map<String, dynamic>>();
      }

      throw Exception('Error al obtener usuarios (status ${responseNoAuth.statusCode})');
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchGroups() async {
    try {
      String? token = await _storage.read(key: 'jwt_token');
      if (token == null || token.isEmpty) token = AuthApi.token;

      final uri = Uri.parse(_baseUrl);

      if (token != null && token.isNotEmpty) {
        final response = await http.get(uri, headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body);
          return data.cast<Map<String, dynamic>>();
        }
        print('fetchGroups: first request failed (status ${response.statusCode})');
      }

      // fallback without auth for diagnosis
      final responseNoAuth = await http.get(uri, headers: {'Content-Type': 'application/json'});
      if (responseNoAuth.statusCode == 200) {
        final List<dynamic> data = jsonDecode(responseNoAuth.body);
        return data.cast<Map<String, dynamic>>();
      }

      throw Exception('Error al obtener grupos');
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<Map<String, dynamic>> fetchGroup(String id) async {
    try {
      String? token = await _storage.read(key: 'jwt_token');
      if (token == null || token.isEmpty) token = AuthApi.token;

      final uri = Uri.parse('$_baseUrl/$id');

      if (token != null && token.isNotEmpty) {
        final response = await http.get(uri, headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = jsonDecode(response.body);
          return data;
        }
        print('fetchGroup: first request failed (status ${response.statusCode})');
      }

      final responseNoAuth = await http.get(uri, headers: {'Content-Type': 'application/json'});
      if (responseNoAuth.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(responseNoAuth.body);
        return data;
      }

      throw Exception('Error al obtener grupo');
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<bool> createExpense({
    required String grupoId,
    required double monto,
    required String descripcion,
    required String categoria,
  }) async {
    try {
      String? token = await _storage.read(key: 'jwt_token');
      if (token == null || token.isEmpty) {
        token = AuthApi.token;
      }

      print("==================================================");
      print("=== INTENTO DE LEER TOKEN EN CREAR GASTO ===");
      print("Token recuperado para enviar gasto: $token");
      print("==================================================");

      if (token == null || token.isEmpty) {
        throw Exception('No se encontró un token de autenticación válido.');
      }

      final Map<String, dynamic> expenseData = {
        "monto": monto,
        "descripcion": descripcion,
        "categoria": categoria,
        "grupoId": grupoId,
      };

      final response = await http.post(
        Uri.parse('$_baseUrl/gasto'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(expenseData),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        final errorResponse = jsonDecode(response.body);
        throw Exception(
          errorResponse['message'] ?? 'Error al registrar el gasto',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión al guardar gasto: $e');
    }
  }
}
