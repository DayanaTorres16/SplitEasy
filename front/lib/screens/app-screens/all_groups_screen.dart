import 'package:flutter/material.dart';
import 'create_group_screen.dart';
import 'group_details_screen.dart';
import '../../services/group_api.dart';
import '../../models/group_model.dart';

class AllGroupsScreen extends StatefulWidget {
  const AllGroupsScreen({super.key});

  @override
  State<AllGroupsScreen> createState() => _AllGroupsScreenState();
}

class _AllGroupsScreenState extends State<AllGroupsScreen> {
  List<GrupoModel> _grupos = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    setState(() => _cargando = true);
    try {
      final data = await GroupApi.fetchGroups();
      final grupos = data.map((g) => GrupoModel.fromJson(g)).toList();
      if (mounted) setState(() { _grupos = grupos; _cargando = false; });
    } catch (e) {
      if (mounted) setState(() { _grupos = []; _cargando = false; });
    }
  }

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
                          Text(
                            _cargando ? 'Cargando...' : '${_grupos.length} grupos',
                            style: const TextStyle(
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
                                ).then((_) => _loadGroups());
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

                      if (_cargando)
                        const Center(child: CircularProgressIndicator())
                      else if (_grupos.isEmpty)
                        const Text('No hay grupos')
                      else ..._grupos.map((g) {
                        return _GroupTile(
                          icon: Icons.group,
                          iconBackground: const Color(0xFFEAF6E9),
                          title: g.nombre,
                          members: '${g.miembros.length} miembros',
                          totals: '',
                          debtLabel: '—',
                          amount: '',
                          amountColor: const Color(0xFF13BE61),
                          groupId: g.id,
                        );
                      }).toList(),
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
  final String? groupId;

  const _GroupTile({
    required this.icon,
    required this.iconBackground,
    required this.title,
    required this.members,
    required this.totals,
    required this.debtLabel,
    required this.amount,
    required this.amountColor,
    this.groupId,
    this.showAmount = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GroupDetailsScreen(groupId: groupId)),
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