import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_api.dart'; 

class GroupApi {
  static const String _baseUrl = 'http://localhost:3000/grupos'; 

  static const _storage = FlutterSecureStorage(
    webOptions: WebOptions(
      dbName: 'SplitEasySecure',
    ),
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
        throw Exception(errorResponse['message'] ?? 'Error al registrar el gasto');
      }
    } catch (e) {
      throw Exception('Error de conexión al guardar gasto: $e');
    }
  }
}