import 'package:flutter/material.dart';
import 'history_screen.dart'; 
import '../../services/group_api.dart';
import '../../models/group_model.dart';

class GroupDetailsScreen extends StatefulWidget {
  final String? groupId;

  const GroupDetailsScreen({super.key, this.groupId});

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  GrupoModel? _grupo;
  List<dynamic> _gastos = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _loadGroup();
  }

  Future<void> _loadGroup() async {
    if (widget.groupId == null) return setState(() => _cargando = false);
    setState(() => _cargando = true);
    try {
      final data = await GroupApi.fetchGroup(widget.groupId!);
      final grupoData = data['grupo'] ?? data; // support different shapes
      final gastosData = data['gastos'] ?? [];

      setState(() {
        _grupo = GrupoModel.fromJson(grupoData as Map<String, dynamic>);
        _gastos = gastosData as List<dynamic>;
        _cargando = false;
      });
    } catch (e) {
      if (mounted) setState(() => _cargando = false);
    }
  }

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
                Navigator.pop(context); 
                Navigator.pop(context); 
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
                            children: [
                              const Icon(Icons.flight_takeoff, color: Colors.white, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                _grupo?.nombre ?? 'Grupo',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Text(_grupo?.descripcion ?? '', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                        ],
                      ),
                    ),
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
                    _buildSummaryCard(_grupo?.miembros.length.toString() ?? '-', 'Miembros'),
                    _buildSummaryCard(_gastos.length.toString(), 'Gastos'),
                    _buildSummaryCard('-', 'Total'),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Row(
                  children: [
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
                const Text('Miembros', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _grupo?.miembros.map((m) => _buildMemberChip(
                          (m.nombre.isNotEmpty ? m.nombre[0] : '?').toUpperCase(),
                          Colors.teal,
                          m.nombre,
                        )).toList() ?? [const Text('Cargando...')],
                  ),
                ),

                const SizedBox(height: 25),

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
                            MaterialPageRoute(
                                builder: (context) => const HistoryScreen()),
                          );
                        },
                        child: const Text("Ver todos",
                            style: TextStyle(color: Color(0xFF13BE61)))),
                  ],
                ),
                if (_cargando)
                  const Center(child: CircularProgressIndicator())
                else if (_gastos.isEmpty)
                  const Text('No hay gastos registrados')
                else ..._gastos.map((g) {
                  final title = g['descripcion'] ?? 'Gasto';
                  final payer = (g['pagadoPor'] != null) ? (g['pagadoPor']['nombre'] ?? g['pagadoPor']['email'] ?? 'Usuario') : 'Usuario';
                  final date = g['fechaGasto'] ?? g['createdAt'] ?? '';
                  final amount = (g['monto'] != null) ? g['monto'].toString() : '';
                  final cat = g['categoria'] ?? '';
                  return _buildExpenseItem(title, payer, date.toString(), amount.toString(), cat);
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

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