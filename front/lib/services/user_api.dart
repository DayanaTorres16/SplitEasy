import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_api.dart'; 

class UserApi {
  
  static const String baseUrl = AuthApi.baseUrl;

  static Future<Map<String, dynamic>?> getProfile() async {
    final token = AuthApi.token; // Recupera el JWT de la sesión activa
    final url = Uri.parse('$baseUrl/users/profile');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', 
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Retorna {id, nombre, email...}
    } else {
      throw Exception('Error al obtener los datos del perfil');
    }
  }

  static Future<bool> updateProfile({required String nombre, required String email}) async {
    final token = AuthApi.token;
    final url = Uri.parse('$baseUrl/users/profile');

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'nombre': nombre,
        'email': email,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      final errorBody = jsonDecode(response.body);
      throw Exception(errorBody['message'] ?? 'Error al actualizar el perfil');
    }
  }

  static Future<bool> changePassword({
    required String passwordActual,
    required String passwordNueva,
  }) async {
    final token = AuthApi.token;
    final url = Uri.parse('$baseUrl/users/change-password');

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'passwordActual': passwordActual,
        'passwordNueva': passwordNueva,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      final errorBody = jsonDecode(response.body);
      throw Exception(errorBody['message'] ?? 'Error al cambiar la contraseña');
    }
  }
}