import 'package:flutter/material.dart';
import 'all_expenses_screen.dart';

class GroupDetailsScreen extends StatelessWidget {
  const GroupDetailsScreen({super.key});

  // Función para confirmar la eliminación
  void _mostrarDialogoEliminar(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("¿Eliminar grupo?"),
          content: const Text(
              "Esta acción no se puede deshacer y se perderán todos los gastos registrados."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                // Lógica real de borrado aquí
                Navigator.pop(context); // Cierra el diálogo
                Navigator.pop(context); // Vuelve al Home
              },
              child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F5),
      body: Column(
        children: [
          // CABECERA VERDE
          Container(
            padding: const EdgeInsets.fromLTRB(10, 50, 20, 25),
            decoration: const BoxDecoration(
              color: Color(0xFF13BE61),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.flight_takeoff,
                                  color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text("Viaje a Madrid",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const Text("Gastos del viaje de fin de semana",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 13)),
                        ],
                      ),
                    ),
                    // AQUÍ ESTÁ EL MENÚ DE LOS TRES PUNTITOS REEMPLAZADO
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      onSelected: (value) {
                        if (value == 'eliminar') {
                          _mostrarDialogoEliminar(context);
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem<String>(
                          value: 'eliminar',
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline,
                                  color: Colors.red.shade400, size: 20),
                              const SizedBox(width: 10),
                              const Text("Eliminar grupo",
                                  style: TextStyle(color: Colors.redAccent)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSummaryCard("3", "Miembros"),
                    _buildSummaryCard("3", "Gastos"),
                    _buildSummaryCard("\$225", "Total"),
                  ],
                ),
              ],
            ),
          ),

          // CUERPO
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // SECCIÓN BALANCES
                Row(
                  children: const [
                    Icon(Icons.swap_horiz,
                        color: Color(0xFF13BE61), size: 20),
                    SizedBox(width: 8),
                    Text("Balances",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
                const SizedBox(height: 12),
                _buildBalanceCard(),

                const SizedBox(height: 25),
                const Text("Miembros",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildMemberChip("T", Colors.green, "Tú"),
                      _buildMemberChip("M", Colors.teal, "María García"),
                      _buildMemberChip("C", Colors.orange, "Carlos López"),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // GASTOS RECIENTES
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Gastos recientes",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                 TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AllExpensesScreen()),
                    );
                  }, 
                  child: const Text("Ver todos", style: TextStyle(color: Color(0xFF13BE61)))
                ),
                  ],
                ),
                _buildExpenseItem("Entradas museo", "Carlos López",
                    "2026-05-11", "60.00", "Entretenimiento"),
                _buildExpenseItem("Uber al hotel", "María García", "2026-05-10",
                    "45.00", "Transporte"),
                _buildExpenseItem("Cena en restaurante", "Tú", "2026-05-10",
                    "120.00", "Comida"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS DE APOYO ---

  Widget _buildSummaryCard(String value, String label) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          _balanceRow(
              "M", Colors.red.shade100, "María García", "debe a Tú", "\$30.00"),
          const Divider(height: 25),
          _balanceRow(
              "C", Colors.pink.shade100, "Carlos López", "debe a Tú", "\$15.00"),
        ],
      ),
    );
  }

  Widget _balanceRow(
      String initial, Color color, String name, String sub, String amount) {
    return Row(
      children: [
        CircleAvatar(
            backgroundColor: color,
            child: Text(initial,
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold))),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(sub,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
        Text(amount,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Widget _buildMemberChip(String initial, Color color, String name) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8F4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
              radius: 10,
              backgroundColor: color,
              child: Text(initial,
                  style: const TextStyle(color: Colors.white, fontSize: 10))),
          const SizedBox(width: 6),
          Text(name,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildExpenseItem(
      String title, String payer, String date, String amount, String cat) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                Text("Pagado por $payer • $date",
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                          color: const Color(0xFFE8F8ED),
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(cat,
                          style: const TextStyle(
                              color: Color(0xFF13BE61),
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                    const Text("• Dividido entre 3",
                        style: TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
          Text("\$$amount",
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        ],
      ),
    );
  }
}