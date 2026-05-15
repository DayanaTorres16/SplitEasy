import 'package:flutter/material.dart';
import 'create_group_screen.dart';
import 'group_details_screen.dart';

class AllGroupsScreen extends StatelessWidget {
  const AllGroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF13BE61),
      body: SafeArea(
        child: Column(
          children: [
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
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Todos los grupos',
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
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                            hintText: 'Buscar grupos...',
                            hintStyle: TextStyle(
                              color: Color(0xFF8F9A93),
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '3 grupos',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF46524B),
                            ),
                          ),
                          SizedBox(
                            height: 34,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CreateGroupScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF13BE61),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(11),
                                ),
                              ),
                              icon: const Icon(Icons.add, size: 16),
                              label: const Text(
                                'Nuevo',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const _GroupTile(
                        icon: Icons.flight_takeoff_rounded,
                        iconBackground: Color(0xFFEAF6E9),
                        title: 'Viaje a Madrid',
                        members: '3 miembros',
                        totals: 'Total: \$225.00 • 3 gastos',
                        debtLabel: 'Te deben',
                        amount: '\$45.00',
                        amountColor: Color(0xFF13BE61),
                      ),
                      const _GroupTile(
                        icon: Icons.home_rounded,
                        iconBackground: Color(0xFFEAF6E9),
                        title: 'Departamento',
                        members: '2 miembros',
                        totals: 'Total: \$1050.00 • 2 gastos',
                        debtLabel: 'Te deben',
                        amount: '\$375.00',
                        amountColor: Color(0xFF13BE61),
                      ),
                      const _GroupTile(
                        icon: Icons.cake_rounded,
                        iconBackground: Color(0xFFEAF6E9),
                        title: 'Cena cumpleaños',
                        members: '4 miembros',
                        totals: 'Total: \$0.00 • 0 gastos',
                        debtLabel: 'En paz',
                        amount: '',
                        amountColor: Color(0xFF13BE61),
                        showAmount: false,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupTile extends StatelessWidget {
  final IconData icon;
  final Color iconBackground;
  final String title;
  final String members;
  final String totals;
  final String debtLabel;
  final String amount;
  final Color amountColor;
  final bool showAmount;

  const _GroupTile({
    required this.icon,
    required this.iconBackground,
    required this.title,
    required this.members,
    required this.totals,
    required this.debtLabel,
    required this.amount,
    required this.amountColor,
    this.showAmount = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GroupDetailsScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE1E7E2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF13BE61), size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    members,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF62706A),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    totals,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF7F8A84),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  debtLabel,
                  style: TextStyle(
                    fontSize: 13,
                    color: showAmount ? amountColor : const Color(0xFF69756F),
                  ),
                ),
                const SizedBox(height: 2),
                if (showAmount)
                  Text(
                    '\$$amount',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: amountColor,
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Color(0xFF7D8681)),
          ],
        ),
      ),
    );
  }
}