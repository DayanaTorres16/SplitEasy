import 'package:flutter/material.dart';
import '../../widgets/bottomNavBar.dart';
import 'create_group_screen.dart';
import 'all_groups_screen.dart';
import 'group_details_screen.dart';
// Se eliminó el import de history_screen porque la navegación es global ahora

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // El índice fijo para esta pantalla es 0
  final int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF13BE61),
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER: SALUDO Y LOGO ---
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
              child: Row(
                children: [
                  Image.asset(
                    'assets/logo-inicio.png',
                    height: 42,
                    errorBuilder: (context, error, stackTrace) => 
                        const Icon(Icons.account_balance_wallet, color: Colors.white, size: 42),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "¡Hola!",
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 16, 
                            fontWeight: FontWeight.w500
                          ),
                        ),
                        Text(
                          "Usuario Demo",
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 26, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person_outline, color: Colors.white),
                  ),
                ],
              ),
            ),
            
            // --- CUERPO BLANCO REDONDEADO ---
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TARJETA DE BALANCE
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Balance total", style: TextStyle(fontSize: 15, color: Colors.black54)),
                            const SizedBox(height: 12),
                            const Text(
                              "+\$420.00",
                              style: TextStyle(
                                fontSize: 34, 
                                fontWeight: FontWeight.bold, 
                                color: Color(0xFF13BE61)
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                _SummaryChip(
                                  backgroundColor: const Color(0xFFE8F8ED),
                                  icon: Icons.trending_up,
                                  iconColor: const Color(0xFF13BE61),
                                  title: "Te deben",
                                  amount: "+\$420.00",
                                  amountColor: const Color(0xFF13BE61),
                                ),
                                const SizedBox(width: 14),
                                _SummaryChip(
                                  backgroundColor: const Color(0xFFF8EAEA),
                                  icon: Icons.trending_down,
                                  iconColor: const Color(0xFFE15B5B),
                                  title: "Debes",
                                  amount: "\$0.00",
                                  amountColor: const Color(0xFFE15B5B),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 18),
                      
                      // BOTONES DE ACCIÓN (Crear y Ver Grupos)
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 54,
                              child: ElevatedButton.icon(
                                onPressed: () => Navigator.push(
                                  context, 
                                  MaterialPageRoute(builder: (context) => const CreateGroupScreen())
                                ),
                                icon: const Icon(Icons.add, size: 18),
                                label: const Text("Crear grupo"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF13BE61),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  elevation: 0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 54,
                              child: OutlinedButton.icon(
                                onPressed: () => Navigator.push(
                                  context, 
                                  MaterialPageRoute(builder: (context) => const AllGroupsScreen())
                                ),
                                icon: const Icon(Icons.groups_outlined, size: 18),
                                label: const Text("Ver grupos"),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF13BE61),
                                  backgroundColor: const Color(0xFFDFF4E5),
                                  side: const BorderSide(color: Color(0xFFD5EAD9)),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 22),
                      
                      // LISTA DE GRUPOS RECIENTES
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Grupos recientes",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () => Navigator.push(
                              context, 
                              MaterialPageRoute(builder: (context) => const AllGroupsScreen())
                            ),
                            child: const Text("Ver todos", style: TextStyle(color: Color(0xFF13BE61))),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 6),
                      
                      // CARDS DE GRUPOS
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => const GroupDetailsScreen())
                        ),
                        child: const _GroupCard(
                          icon: Icons.flight_takeoff_rounded,
                          iconBackground: Color(0xFFEAF6E9),
                          title: "Viaje a Madrid",
                          subtitle: "3 miembros • 3 gastos",
                          amount: "+\$45.00",
                        ),
                      ),
                      const _GroupCard(
                        icon: Icons.home_rounded,
                        iconBackground: Color(0xFFEAF6E9),
                        title: "Departamento",
                        subtitle: "2 miembros • 2 gastos",
                        amount: "+\$375.00",
                      ),
                      const _GroupCard(
                        icon: Icons.cake_rounded,
                        iconBackground: Color(0xFFEAF6E9),
                        title: "Cena cumpleaños",
                        subtitle: "4 miembros • 0 gastos",
                        amount: null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // --- NAVEGACIÓN GLOBAL ---
      // Solo pasamos el índice. La lógica de clic vive dentro del widget.
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
      ),
    );
  }
}

// --- WIDGETS AUXILIARES ---

class _SummaryChip extends StatelessWidget {
  final Color backgroundColor;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String amount;
  final Color amountColor;

  const _SummaryChip({
    required this.backgroundColor,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.amount,
    required this.amountColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Container(
              width: 34, height: 34,
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                  Text(amount, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: amountColor)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  final IconData icon;
  final Color iconBackground;
  final String title;
  final String subtitle;
  final String? amount;

  const _GroupCard({
    required this.icon,
    required this.iconBackground,
    required this.title,
    required this.subtitle,
    this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E9E3)),
      ),
      child: Row(
        children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(color: iconBackground, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: const Color(0xFF13BE61), size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.black54)),
              ],
            ),
          ),
          if (amount != null)
            Text(amount!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF13BE61))),
          const Icon(Icons.chevron_right, color: Colors.black38),
        ],
      ),
    );
  }
}