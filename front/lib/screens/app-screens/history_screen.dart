import 'package:flutter/material.dart';
import '../../widgets/bottomNavBar.dart';
import 'add_expense_screen.dart'; 

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: CircleAvatar(
                            backgroundColor: Colors.white.withOpacity(0.2),
                            child: const Icon(Icons.arrow_back, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 15),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Historial", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                            Text("5 gastos", style: TextStyle(color: Colors.white70, fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
                        );
                      },
                      icon: const Icon(Icons.add_circle, color: Colors.white, size: 32),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Buscar gastos...",
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _FilterChip(label: "Todos", isSelected: true),
                  _FilterChip(label: "✈️ Viaje a Madrid"),
                  _FilterChip(label: "🏠 Departamento"),
                ],
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: const [
                _SectionHeader(title: "Domingo, 10 De Mayo"),
                _ExpenseCard(
                  title: "Entradas museo",
                  group: "Viaje a Madrid",
                  paidBy: "Carlos López",
                  amount: "60.00",
                  category: "Entretenimiento",
                  icon: Icons.flight_takeoff,
                ),
                
                _SectionHeader(title: "Sábado, 9 De Mayo"),
                _ExpenseCard(
                  title: "Cena en restaurante",
                  group: "Viaje a Madrid",
                  paidBy: "Tú",
                  amount: "120.00",
                  category: "Comida",
                  icon: Icons.restaurant,
                ),
                _ExpenseCard(
                  title: "Uber al hotel",
                  group: "Viaje a Madrid",
                  paidBy: "María García",
                  amount: "45.00",
                  category: "Transporte",
                  icon: Icons.local_taxi,
                ),

                _SectionHeader(title: "Lunes, 4 De Mayo"),
                _ExpenseCard(
                  title: "Servicios (luz, agua, internet)",
                  group: "Departamento",
                  paidBy: "Ana Martínez",
                  amount: "150.00",
                  category: "Servicios",
                  icon: Icons.home,
                ),

                _SectionHeader(title: "Jueves, 30 De Abril"),
                _ExpenseCard(
                  title: "Alquiler mensual",
                  group: "Departamento",
                  paidBy: "Tú",
                  amount: "900.00",
                  category: "Hogar",
                  icon: Icons.house,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(
        currentIndex: 1,
      ),
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
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF13BE61) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black12),
      ),
      child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.w500)),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
        ],
      ),
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
            decoration: BoxDecoration(color: const Color(0xFFE8F8ED), 
            borderRadius: BorderRadius.circular(12)),
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