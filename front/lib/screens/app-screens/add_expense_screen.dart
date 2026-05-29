import 'package:flutter/material.dart';
import '../../services/group_service.dart';
import '../../services/group_api.dart';
import '../../models/group_model.dart';
import '../../auth_config.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _groupService = GroupService();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  GrupoModel? _selectedGroup;
  List<GrupoModel> _grupos = [];
  bool _cargando = true;

  String selectedCategory = "Comida";
  UsuarioMiembro? _paidBy;
  Map<int, bool> _splitWith = {};

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

Future<void> _cargarDatos() async {
    try {
      debugPrint("Intentando conectar con el servidor...");
      final grupos = await _groupService.obtenerMisGrupos(AuthConfig.token);
      
      if (mounted) {
        setState(() {
          if (grupos.isNotEmpty) {
            _grupos = grupos;
            _selectedGroup = grupos.first;
          } else {
            _grupos = []; 
          }
          _cargando = false;
        });
        if (grupos.isNotEmpty) await _inicializarMiembros();
      }
    } catch (e) {
      debugPrint("Error de conexión, cargando modo offline: $e");
      if (mounted) {
        setState(() {
          _grupos = []; 
          _cargando = false;
        });
      }
    }
  }

  Future<void> _inicializarMiembros() async {
    if (_selectedGroup == null) return;
    try {
      final data = await GroupApi.fetchGroup(_selectedGroup!.id);
      Map<String, dynamic> grupoJson;
      if (data.containsKey('grupo') && data['grupo'] is Map<String, dynamic>) {
        grupoJson = Map<String, dynamic>.from(data['grupo'] as Map);
      } else {
        grupoJson = Map<String, dynamic>.from(data);
      }

      final fetchedGroup = GrupoModel.fromJson(grupoJson);

      if (mounted) {
        final idx = _grupos.indexWhere((g) => g.id == fetchedGroup.id);
        if (idx != -1) {
          setState(() {
            _grupos[idx] = fetchedGroup;
            _selectedGroup = _grupos[idx];
            _splitWith = {};
            _paidBy = fetchedGroup.miembros.isNotEmpty ? fetchedGroup.miembros.first : null;
            for (var m in fetchedGroup.miembros) {
              _splitWith[m.id] = true;
            }
          });
        } else {
          setState(() {
            _grupos.add(fetchedGroup);
            _selectedGroup = fetchedGroup;
            _splitWith = {};
            _paidBy = fetchedGroup.miembros.isNotEmpty ? fetchedGroup.miembros.first : null;
            for (var m in fetchedGroup.miembros) {
              _splitWith[m.id] = true;
            }
          });
        }
      }
    } catch (e) {
      debugPrint("No se pudo cargar miembros del grupo: $e");
      // fallback: ensure map initialized from whatever we already have
      if (mounted && _selectedGroup != null) {
        setState(() {
          _splitWith = {};
          _paidBy = _selectedGroup!.miembros.isNotEmpty ? _selectedGroup!.miembros.first : null;
          for (var m in _selectedGroup!.miembros) {
            _splitWith[m.id] = true;
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _getCurrentGroupName() => _selectedGroup?.nombre ?? "Selecciona un grupo";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F5),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Seleccionar Grupo *"),
                        _buildGroupDropdown(),
                        const SizedBox(height: 20),
                        _buildLabel("Monto *"),
                        _buildTextField(hintText: "\$ 0.00", isNumber: true, controller: _amountController),
                        const SizedBox(height: 20),
                        _buildLabel("Descripción *"),
                        _buildTextField(hintText: "Ej: Cena", controller: _descriptionController),
                        const SizedBox(height: 25),
                        _buildLabel("Pagado por"),
                        _buildPaidByRow(),
                        const SizedBox(height: 25),
                        _buildLabel("Dividir entre"),
                        _buildSplitList(),
                        const SizedBox(height: 30),
                        _buildSaveButton(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
      decoration: const BoxDecoration(
          color: Color(0xFF13BE61),
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28))),
      child: Row(
        children: [
          GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const CircleAvatar(backgroundColor: Colors.white24, child: Icon(Icons.arrow_back, color: Colors.white))),
          const SizedBox(width: 15),
          Expanded(child: Text("Añadir gasto\n${_getCurrentGroupName()}", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildGroupDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<GrupoModel>(
          value: _selectedGroup,
          isExpanded: true,
          items: _grupos.map((g) => DropdownMenuItem(value: g, child: Text(g.nombre))).toList(),
          onChanged: (val) {
            setState(() => _selectedGroup = val);
            _inicializarMiembros();
          },
        ),
      ),
    );
  }

  Widget _buildPaidByRow() {
    if (_selectedGroup == null) return const Text("Cargando grupo...");

    final miembros = _selectedGroup!.miembros;

    if (miembros.isEmpty) return const Text("El grupo no tiene miembros");

    return Row(
      children: miembros.map((m) {
        if (m.id == 0 || m.nombre.isEmpty) {
          debugPrint("¡ALERTA! Miembro con datos nulos detectado: $m");
        }
        return _userSelectableCard(m);
      }).toList(),
    );
  }

  Widget _userSelectableCard(UsuarioMiembro miembro) {
    bool isSelected = _paidBy?.id == miembro.id;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _paidBy = miembro),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isSelected ? const Color(0xFF13BE61) : Colors.black12)),
          child: Text(miembro.nombre, textAlign: TextAlign.center),
        ),
      ),
    );
  }

  Widget _buildSplitList() {
    if (_selectedGroup == null) return Container();
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
      child: Column(
        children: _selectedGroup!.miembros
            .map((m) => CheckboxListTile(
                  title: Text(m.nombre),
                  value: _splitWith[m.id] ?? false,
                  onChanged: (val) => setState(() => _splitWith[m.id] = val ?? false),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(text, style: const TextStyle(fontWeight: FontWeight.bold));

  Widget _buildTextField({required String hintText, bool isNumber = false, required TextEditingController controller}) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
      child: TextField(controller: controller, keyboardType: isNumber ? TextInputType.number : TextInputType.text, decoration: const InputDecoration(border: InputBorder.none)),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: () {},
      child: const Text("Guardar"),
    );
  }
}