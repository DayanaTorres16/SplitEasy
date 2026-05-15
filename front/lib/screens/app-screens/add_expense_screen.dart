import 'package:flutter/material.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  // Estados para la selección
  String selectedCategory = "Comida";
  String paidBy = "Tú";
  Map<String, bool> splitWith = {
    "Tú": true,
    "Ana Martínez": true,
  };

  // Función para mostrar el diálogo de confirmación
  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Obliga a interactuar con el diálogo
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.help_outline, color: Color(0xFF13BE61)),
              SizedBox(width: 10),
              Text("¿Confirmar gasto?", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: const Text("¿Estás seguro de que deseas registrar este gasto en el grupo 'Departamento'?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el diálogo
                Navigator.pop(context); // Regresa al historial
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Gasto guardado con éxito"),
                    backgroundColor: Color(0xFF13BE61),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF13BE61),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Guardar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
          // --- HEADER VERDE ---
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
                    Text("Añadir gasto", 
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    Text("🏠 Departamento", 
                      style: TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ),
              ],
            ),
          ),

          // --- FORMULARIO ---
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Monto *"),
                  _buildTextField(hintText: "\$ 0.00", isNumber: true),

                  const SizedBox(height: 20),

                  _buildLabel("Descripción *"),
                  _buildTextField(hintText: "Ej: Cena en restaurante"),

                  const SizedBox(height: 25),

                  _buildLabel("Categoría"),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _categoryChip("Comida", Icons.restaurant, const Color(0xFFE8F8ED)),
                      _categoryChip("Transporte", Icons.directions_car, const Color(0xFFE3F2FD)),
                      _categoryChip("Entretenimiento", Icons.theater_comedy, const Color(0xFFF3E5F5)),
                      _categoryChip("Compras", Icons.shopping_bag, const Color(0xFFFFF3E0)),
                      _categoryChip("Hogar", Icons.home, const Color(0xFFEFEBE9)),
                      _categoryChip("Servicios", Icons.electrical_services, const Color(0xFFE0F2F1)),
                    ],
                  ),

                  const SizedBox(height: 25),

                  _buildLabel("Pagado por"),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _userSelectableCard("Tú", "T", const Color(0xFF13BE61)),
                      const SizedBox(width: 10),
                      _userSelectableCard("Ana Martínez", "A", Colors.grey),
                    ],
                  ),

                  const SizedBox(height: 25),

                  _buildLabel("Dividir entre"),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Column(
                      children: [
                        _splitCheckboxRow("Tú", "T", const Color(0xFF13BE61)),
                        const Divider(height: 20),
                        _splitCheckboxRow("Ana Martínez", "A", const Color(0xFF2196F3)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // BOTÓN GUARDAR
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () => _showConfirmationDialog(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF13BE61),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 0,
                      ),
                      child: const Text("Guardar gasto", 
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS INTERNOS ---

  Widget _buildLabel(String text) {
    return Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87));
  }

  Widget _buildTextField({required String hintText, bool isNumber = false}) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: TextField(
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black26),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        ),
      ),
    );
  }

  Widget _categoryChip(String label, IconData icon, Color color) {
    bool isSelected = selectedCategory == label;
    return GestureDetector(
      onTap: () => setState(() => selectedCategory = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF13BE61) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? Colors.transparent : Colors.black12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.white : Colors.black54),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _userSelectableCard(String name, String initial, Color color) {
    bool isSelected = paidBy == name;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => paidBy = name),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? const Color(0xFF13BE61) : Colors.black12, width: 2),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: isSelected ? const Color(0xFF13BE61) : Colors.grey.shade300,
                child: Text(initial, style: const TextStyle(color: Colors.white, fontSize: 12)),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _splitCheckboxRow(String name, String initial, Color avatarColor) {
    return Row(
      children: [
        Checkbox(
          value: splitWith[name],
          activeColor: const Color(0xFF13BE61),
          onChanged: (val) => setState(() => splitWith[name] = val!),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        CircleAvatar(
          radius: 14,
          backgroundColor: avatarColor.withOpacity(0.2),
          child: Text(initial, style: TextStyle(color: avatarColor, fontSize: 12, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 12),
        Text(name, style: const TextStyle(fontSize: 15)),
      ],
    );
  }
}