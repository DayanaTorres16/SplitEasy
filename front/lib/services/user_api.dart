import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_api.dart'; // Importa tu archivo de autenticación para leer el token global

class UserApi {
  // Reutiliza la misma dirección IP/URL que configuraste en tu AuthApi
  static const String baseUrl = AuthApi.baseUrl;

  // GET /users/profile -> Trae los datos del usuario autenticado
  static Future<Map<String, dynamic>?> getProfile() async {
    final token = AuthApi.token; // Recupera el JWT de la sesión activa
    final url = Uri.parse('$baseUrl/users/profile');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Inyecta el token en la cabecera HTTP
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Retorna {id, nombre, email...}
    } else {
      throw Exception('Error al obtener los datos del perfil');
    }
  }

  // PATCH /users/profile -> Modifica el nombre y correo en la base de datos
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
      // Captura y propaga el mensaje de error que NestJS arroje (ej: "El correo ya está en uso")
      final errorBody = jsonDecode(response.body);
      throw Exception(errorBody['message'] ?? 'Error al actualizar el perfil');
    }
  }

  // PATCH /users/change-password -> Cambia la contraseña validando la anterior
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
      // Captura las validaciones de class-validator (ej: "La nueva contraseña debe tener al menos 6 caracteres")
      final errorBody = jsonDecode(response.body);
      throw Exception(errorBody['message'] ?? 'Error al cambiar la contraseña');
    }
  }
}