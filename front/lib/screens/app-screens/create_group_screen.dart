import 'package:flutter/material.dart';
import '../../services/group_api.dart'; 

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  int _selectedIconIndex = 0;
  bool _isLoading = false;
  List<Map<String, dynamic>> _registeredUsers = [];
  final Set<int> _selectedUserIds = {};

  final List<IconData> _groupIcons = [
    Icons.paragliding,
    Icons.home,
    Icons.restaurant,
    Icons.local_pizza,
    Icons.backpack,
    Icons.favorite,
    Icons.sports_soccer,
    Icons.flight,
  ];

  final List<Color> _iconBackgroundColors = [
    const Color(0xFF13BE61),
    const Color(0xFFFF6B6B),
    const Color(0xFFFFA500),
    const Color(0xFFFF9F4A),
    const Color(0xFF6C5CE7),
    const Color(0xFFFF6B9D),
    const Color(0xFF0984E3),
    const Color(0xFFD946EF),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadRegisteredUsers();
  }

  Future<void> _loadRegisteredUsers() async {
    try {
      final users = await GroupApi.fetchUsers();
      // debug log
      print('fetchUsers returned ${users.length} users');
      if (mounted) setState(() => _registeredUsers = users);
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se pudieron cargar usuarios registrados')));
    }
  }

  void _addMemberToList() {
    // external members removed: no-op
  }

  Future<void> _submitGroup() async {
    final groupName = _nameController.text.trim();
    if (groupName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa el nombre del grupo')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final Map<String, dynamic> groupPayload = {
        'nombre': groupName,
        'descripcion': _descriptionController.text.trim(),
        'iconoIndex': _selectedIconIndex,
        'miembrosIds': _selectedUserIds.toList(),
      };

      // Invocación al servicio HTTP
      final success = await GroupApi.createGroup(groupPayload);
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Grupo creado exitosamente en SplitEasy!'),
            backgroundColor: Color(0xFF13BE61),
          ),
        );
        Navigator.pop(context); 
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      "Crear grupo",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
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
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Icono del grupo",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
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
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: List.generate(
                            _groupIcons.length,
                            (index) => GestureDetector(
                              onTap: () {
                                setState(() => _selectedIconIndex = index);
                              },
                              child: Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: _selectedIconIndex == index
                                      ? _iconBackgroundColors[index]
                                      : _iconBackgroundColors[index].withOpacity(0.15),
                                  shape: BoxShape.circle,
                                  border: _selectedIconIndex == index
                                      ? Border.all(color: _iconBackgroundColors[index], width: 2)
                                      : null,
                                ),
                                child: Icon(
                                  _groupIcons[index],
                                  color: _selectedIconIndex == index ? Colors.white : _iconBackgroundColors[index],
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        "Nombre del grupo *",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            hintText: "Ej: Viaje a la playa",
                            hintStyle: TextStyle(color: Color(0xFFB0BFB8), fontSize: 14),
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        "Descripción (opcional)",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            hintText: "Ej: Gastos del viaje de verano",
                            hintStyle: TextStyle(color: Color(0xFFB0BFB8), fontSize: 14),
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(fontSize: 14, color: Colors.black),
                          minLines: 2,
                          maxLines: 3,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        "Miembros del grupo",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                      const SizedBox(height: 12),
                      
                      // Lista de usuarios registrados (seleccionables)
                      if (_registeredUsers.isNotEmpty) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F8ED),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            children: _registeredUsers.map((u) {
                              final id = u['id'] is int ? u['id'] as int : int.tryParse(u['id'].toString());
                              final nombre = u['nombre'] ?? '';
                              final email = u['email'] ?? '';
                              return CheckboxListTile(
                                value: id != null && _selectedUserIds.contains(id),
                                onChanged: (v) {
                                  if (id == null) return;
                                  setState(() {
                                    if (v == true) _selectedUserIds.add(id);
                                    else _selectedUserIds.remove(id);
                                  });
                                },
                                title: Text(nombre.toString()),
                                subtitle: email.toString().isNotEmpty ? Text(email.toString()) : null,
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],

                      // Siempre mostrar el organizador (tú)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F8ED),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(color: Color(0xFF13BE61), shape: BoxShape.circle),
                              child: const Center(
                                child: Text("T", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Tú", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black)),
                                  Text("Organizador", style: TextStyle(fontSize: 12, color: Color(0xFF13BE61))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      const SizedBox(height: 12),
                      const SizedBox(height: 32),
                      
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submitGroup,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF13BE61),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: _isLoading
                              ? const Center(child: CircularProgressIndicator(color: Colors.white))
                              : const Text(
                                  "Crear grupo",
                                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                        ),
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
