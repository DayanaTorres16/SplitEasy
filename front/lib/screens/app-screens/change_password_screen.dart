import 'package:flutter/material.dart';
import '../../services/user_api.dart'; // Asegúrate de ajustar correctamente esta ruta

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  // Estados para ocultar/mostrar texto
  bool _obscureActual = true;
  bool _obscureNueva = true;
  bool _obscureConfirmar = true;

  // Estado de carga para la petición HTTP
  bool _isLoading = false;

  // Controladores de texto para capturar los inputs
  final TextEditingController _actualController = TextEditingController();
  final TextEditingController _nuevaController = TextEditingController();
  final TextEditingController _confirmarController = TextEditingController();

  @override
  void dispose() {
    _actualController.dispose();
    _nuevaController.dispose();
    _confirmarController.dispose();
    super.dispose();
  }

  // Ejecuta la petición al backend si las validaciones del front pasan con éxito
  Future<void> _updatePasswordInBackend() async {
    final actual = _actualController.text;
    final nueva = _nuevaController.text;
    final confirmar = _confirmarController.text;

    // 1. Validaciones iniciales del Frontend
    if (actual.isEmpty || nueva.isEmpty || confirmar.isEmpty) {
      _showMessage("Por favor, llena todos los campos", isError: true);
      return;
    }

    if (nueva != confirmar) {
      _showMessage("La nueva contraseña y su confirmación no coinciden", isError: true);
      return;
    }

    if (nueva.length < 6) {
      _showMessage("La nueva contraseña debe tener al menos 6 caracteres", isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 2. Llamada al método que creamos en UserApi
      final success = await UserApi.changePassword(
        passwordActual: actual,
        passwordNueva: nueva,
      );

      if (success && mounted) {
        setState(() => _isLoading = false);
        
        // Muestra el snackbar de éxito y saca al usuario de esta pantalla regresando al perfil
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Contraseña actualizada correctamente"),
            backgroundColor: Color(0xFF13BE61),
          ),
        );
        Navigator.pop(context); // Sale de la pantalla de cambio de clave
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        // Muestra el error exacto controlado que venga de NestJS (ej: "Contraseña actual incorrecta")
        _showMessage(e.toString().replaceFirst('Exception: ', ''), isError: true);
      }
    }
  }

  void _showMessage(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.redAccent : const Color(0xFF13BE61),
      ),
    );
  }

  void _showConfirmDialog(BuildContext context) {
    // Si algún campo esencial está vacío, no abrimos el diálogo y validamos directo
    if (_actualController.text.isEmpty || _nuevaController.text.isEmpty || _confirmarController.text.isEmpty) {
      _updatePasswordInBackend();
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("¿Actualizar contraseña?", style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text("Tu sesión se mantendrá activa con la nueva clave."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el modal de confirmación
                _updatePasswordInBackend(); // Dispara la actualización real
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF13BE61),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Confirmar", style: TextStyle(color: Colors.white)),
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
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
            decoration: const BoxDecoration(
              color: Color(0xFF13BE61),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
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
                    Text("Cambiar contraseña", 
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    Text("Actualiza tu contraseña de acceso", 
                      style: TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPasswordField(
                    label: "Contraseña actual",
                    hint: "Ingresa tu contraseña actual",
                    controller: _actualController,
                    obscureText: _obscureActual,
                    onToggle: () => setState(() => _obscureActual = !_obscureActual),
                  ),
                  const SizedBox(height: 25),
                  _buildPasswordField(
                    label: "Nueva contraseña",
                    hint: "Ingresa tu nueva contraseña",
                    controller: _nuevaController,
                    obscureText: _obscureNueva,
                    onToggle: () => setState(() => _obscureNueva = !_obscureNueva),
                  ),
                  const SizedBox(height: 25),
                  _buildPasswordField(
                    label: "Confirmar nueva contraseña",
                    hint: "Repite tu nueva contraseña",
                    controller: _confirmarController,
                    obscureText: _obscureConfirmar,
                    onToggle: () => setState(() => _obscureConfirmar = !_obscureConfirmar),
                  ),
                  
                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () => _showConfirmDialog(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF13BE61), // Cambiado a verde activo para que resalte
                        disabledBackgroundColor: const Color(0xFF98E2B9), // El color pastel se queda si está cargando
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Text("Actualizar contraseña", 
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

  Widget _buildPasswordField({
    required String label, 
    required String hint, 
    required TextEditingController controller,
    required bool obscureText, 
    required VoidCallback onToggle
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.lock_outline, size: 18, color: Colors.black87),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black12),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.black26, fontSize: 14),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: Colors.grey,
                  size: 20,
                ),
                onPressed: onToggle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}