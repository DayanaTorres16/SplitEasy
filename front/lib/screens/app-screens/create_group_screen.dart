import 'package:flutter/material.dart';
import '../../services/group_api.dart'; // Asegúrate de ajustar correctamente la ruta a tu archivo

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  // Controladores para capturar el texto ingresado
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _memberNameController = TextEditingController();
  final TextEditingController _memberEmailController = TextEditingController();

  int _selectedIconIndex = 0;
  bool _isLoading = false;

  // Lista local en memoria adaptada para permitir valores nulos en el email
  final List<Map<String, String?>> _addedMembers = [];

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
    _memberNameController.dispose();
    _memberEmailController.dispose();
    super.dispose();
  }

  // Agrega un amigo a la lista interna que se muestra en pantalla
  void _addMemberToList() {
    final name = _memberNameController.text.trim();
    final email = _memberEmailController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El nombre del miembro es obligatorio')),
      );
      return;
    }

    setState(() {
      _addedMembers.add({
        'nombre': name,
        // Si el email está vacío, guardamos null en vez de "" para no romper NestJS
        'email': email.isEmpty ? null : email,
      });
      // Limpia los campos individuales de registro para el siguiente amigo
      _memberNameController.clear();
      _memberEmailController.clear();
    });
  }

  // Dispara el guardado definitivo hacia la base de datos de NestJS
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
      // Estructuramos el payload exactamente igual al CreateGroupDto del backend
      final Map<String, dynamic> groupPayload = {
        'nombre': groupName,
        'descripcion': _descriptionController.text.trim(),
        'iconoIndex': _selectedIconIndex,
        'miembros': _addedMembers, 
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
        Navigator.pop(context); // Regresa al Home
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
            // Header superior de la pantalla
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
            // Contenedor principal del formulario
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
                      // Selector horizontal de Iconos
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
                      
                      // El Organizador (Tú) - Tarjeta estática superior
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

                      // Lista en tiempo real de los amigos registrados localmente
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _addedMembers.length,
                        itemBuilder: (context, index) {
                          final member = _addedMembers[index];
                          final hasEmail = member['email'] != null && member['email']!.isNotEmpty;
                          
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: Colors.grey.withOpacity(0.2)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                                    child: Center(
                                      child: Text(
                                        member['nombre']!.isNotEmpty ? member['nombre']!.substring(0, 1).toUpperCase() : '?',
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(member['nombre']!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black)),
                                        if (hasEmail)
                                          Text(member['email']!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent),
                                    onPressed: () {
                                      setState(() => _addedMembers.removeAt(index));
                                    },
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),

                      // Panel para ingresar el Nombre y Email del nuevo amigo
                      const Text(
                        "Añadir miembro",
                        style: TextStyle(fontSize: 14, color: Color(0xFF13BE61), fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFD5EAD9)),
                        ),
                        child: TextField(
                          controller: _memberNameController,
                          decoration: const InputDecoration(
                            hintText: "Nombre del amigo",
                            hintStyle: TextStyle(color: Color(0xFFB0BFB8), fontSize: 14),
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFD5EAD9)),
                        ),
                        child: TextField(
                          controller: _memberEmailController,
                          decoration: const InputDecoration(
                            hintText: "Email (opcional para invitar)",
                            hintStyle: TextStyle(color: Color(0xFFB0BFB8), fontSize: 14),
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _addMemberToList,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE8F8ED),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text(
                            "+ Registrar en la lista",
                            style: TextStyle(color: Color(0xFF13BE61), fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Botón maestro final de creación
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
