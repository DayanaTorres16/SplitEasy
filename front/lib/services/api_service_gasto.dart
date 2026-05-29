import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/gasto.dart';

class ApiService {
  final String baseUrl = "http://10.0.2.2:3000"; 

  Future<List<Gasto>> getGastos() async {
    final response = await http.get(Uri.parse('$baseUrl/gastos'));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Gasto.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar gastos');
    }
  }
}