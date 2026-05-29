import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/group_model.dart'; 
import 'package:flutter/foundation.dart';

class GroupService {
  final String baseUrl = "http://localhost:3000"; 

  Future<List<GrupoModel>> obtenerMisGrupos(String token) async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/grupos'),
        headers: {'Authorization': 'Bearer $token'},
      );

      debugPrint("--- RESPUESTA DEL SERVIDOR ---");
      debugPrint("Status: ${response.statusCode}");
      debugPrint("Cuerpo: ${response.body}");
      debugPrint("------------------------------");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((g) => GrupoModel.fromJson(g)).toList();
      } else {
        return []; 
      }
    } catch (e) {
      debugPrint("Error de conexión real: $e");
      return [];
    }
  }

  Future<void> registrarGasto(String token, Map<String, dynamic> gastoData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/grupos/gasto'), 
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(gastoData),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al registrar gasto: ${response.body}');
    }
  }
}