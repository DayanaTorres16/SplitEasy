import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_api.dart'; // Importamos AuthApi para usar el respaldo en memoria

class GroupApi {
  // Configurado para apuntar a NestJS local desde un entorno Web
  static const String _baseUrl = 'http://localhost:3000/grupos'; 

  static const _storage = FlutterSecureStorage(
    webOptions: WebOptions(
      dbName: 'SplitEasySecure',
    ),
  );

  static Future<bool> createGroup(Map<String, dynamic> groupData) async {
    try {
      // 1. Intentamos leer del almacenamiento seguro de la Web
      String? token = await _storage.read(key: 'jwt_token');
      
      // 2. Si el navegador lo devolvió nulo, usamos el token guardado en memoria como salvavidas
      if (token == null || token.isEmpty) {
        token = AuthApi.token;
      }
      
      // 👁️ CHISMOSO 4: Ver el estado del token justo antes de enviar la petición
      print("==================================================");
      print("=== INTENTO DE LEER TOKEN EN CREAR GRUPO ===");
      print("Token recuperado para enviar: $token");
      print("==================================================");

      if (token == null || token.isEmpty) {
        throw Exception('No se encontró un token de autenticación válido.');
      }

      // Hacer la petición HTTP POST hacia NestJS
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Inyección del token Bearer
        },
        body: jsonEncode(groupData),
      );

      // Evaluar la respuesta del servidor (201 Created)
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
}