import 'package:flutter/material.dart';

class AllExpensesScreen extends StatelessWidget {
  const AllExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF13BE61), // Mismo verde que Grupos
      body: SafeArea(
        child: Column(
          children: [
            // BARRA SUPERIOR
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Todos los gastos',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // CUERPO BLANCO
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF6F8F5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 25, 20, 24),
                  children: [
                    // BUSCADOR (Igual al de grupos)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 14,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.search, color: Color(0xFF66706A)),
                          hintText: 'Buscar gastos...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    
                    const Text(
                      "Historial de gastos",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 15),

                    // LISTA DE GASTOS (Reutilizando el diseño de la pantalla de detalles)
                    _buildExpenseItem("Entradas museo", "Carlos López", "2026-05-11", "60.00", "Entretenimiento"),
                    _buildExpenseItem("Uber al hotel", "María García", "2026-05-10", "45.00", "Transporte"),
                    _buildExpenseItem("Cena en restaurante", "Tú", "2026-05-10", "120.00", "Comida"),
                    // Puedes agregar más aquí para que se vea la lista larga
                    _buildExpenseItem("Café mañana", "Tú", "2026-05-09", "12.00", "Comida"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Mismo diseño de item que usamos en Detalles
  Widget _buildExpenseItem(String title, String payer, String date, String amount, String cat) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE1E7E2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text("Pagado por $payer • $date", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: const Color(0xFFE8F8ED), borderRadius: BorderRadius.circular(5)),
                  child: Text(cat, style: const TextStyle(color: Color(0xFF13BE61), fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Text("\$$amount", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black)),
        ],
      ),
    );
  }
}