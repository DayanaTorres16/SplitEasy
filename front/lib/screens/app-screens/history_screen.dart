import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../widgets/bottomNavBar.dart';
import 'add_expense_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Gasto {
  final int id;
  final double monto;
  final String categoria;
  final DateTime fechaGasto;
  final String descripcion;

  Gasto({
    required this.id, 
    required this.monto, 
    required this.categoria, 
    required this.fechaGasto, 
    required this.descripcion
  });

  factory Gasto.fromJson(Map<String, dynamic> json) {
    return Gasto(
      id: json['id'] ?? 0,
      monto: double.tryParse(json['monto']?.toString() ?? '0') ?? 0.0,
      categoria: json['categoria'] ?? 'Sin categoría',
      descripcion: json['descripcion'] ?? 'Sin descripción',
      fechaGasto: json['fecha_gasto'] != null 
          ? DateTime.parse(json['fecha_gasto']) 
          : DateTime.now(),
    );
  }
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<String> grupos = ["Todos"];
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchGrupos();
  }

  Future<void> fetchGrupos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token'); 

      final response = await http.get(
        Uri.parse('http://localhost:3000/grupos'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        setState(() {
          grupos = ["Todos", ...jsonResponse.map((g) => g['nombre'].toString())];
        });
      } else {
        debugPrint("Error ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error de red: $e");
    }
  }

  Future<List<Gasto>> fetchGastos() async {
    final response = await http.get(Uri.parse('http://localhost:3000/gastos'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Gasto.fromJson(data)).toList();
    } else {
      throw Exception('Error al cargar datos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F5),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            decoration: const BoxDecoration(
              color: Color(0xFF13BE61),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Historial", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    Text("Gastos registrados", style: TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddExpenseScreen())),
                  icon: const Icon(Icons.add_circle, color: Colors.white, size: 32),
                ),
              ],
            ),
          ),
          
          // Filtros Dinámicos
          SizedBox(
            height: 60,
            child: grupos == null 
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: grupos.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => setState(() => selectedIndex = index),
                      child: _FilterChip(
                        label: grupos[index], 
                        isSelected: selectedIndex == index
                      ),
                    );
                  },
                ),
          ),

          // Lista dinámica
          Expanded(
            child: FutureBuilder<List<Gasto>>(
              future: fetchGastos(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No hay gastos registrados"));
                }

                final gastos = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: gastos.length,
                  itemBuilder: (context, index) {
                    final g = gastos[index];
                    return _ExpenseCard(
                      title: g.descripcion,
                      group: "General",
                      paidBy: "Usuario",
                      amount: g.monto.toStringAsFixed(2),
                      category: g.categoria,
                      icon: Icons.attach_money,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}


class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  const _FilterChip({required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF13BE61) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? const Color(0xFF13BE61) : Colors.black12),
      ),
      child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.w500)),
    );
  }
}

class _ExpenseCard extends StatelessWidget {
  final String title, group, paidBy, amount, category;
  final IconData icon; 
  const _ExpenseCard({required this.title, required this.group, required this.paidBy, required this.amount, required this.category, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFFE8F8ED), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: const Color(0xFF13BE61)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text("$group • Pagado por $paidBy", style: const TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: const Color(0xFFDFF4E5), borderRadius: BorderRadius.circular(8)),
                  child: Text(category, style: const TextStyle(color: Color(0xFF13BE61), fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Text("\$$amount", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
    );
  }
}