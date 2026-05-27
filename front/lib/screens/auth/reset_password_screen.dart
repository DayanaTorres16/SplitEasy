import 'package:flutter/material.dart';
import '../../services/auth_api.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF13BE61)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Volver",
          style: TextStyle(color: Color(0xFF13BE61)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            Image.asset(
              'assets/logo-resetpassword.png',
              height: 80,
            ),
            const SizedBox(height: 20),

            const Text(
              "¿Olvidaste tu contraseña?",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF13BE61),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "No te preocupes, te enviaremos instrucciones\npara restablecerla",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),

            _EmailForm(),
            const SizedBox(height: 20),

            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text(
                "Volver al inicio de sesión",
                style: TextStyle(color: Color(0xFF13BE61)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmailForm extends StatefulWidget {
  @override
  State<_EmailForm> createState() => _EmailFormState();
}

class _EmailFormState extends State<_EmailForm> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ingresa tu correo')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      await AuthApi.forgotPassword(email: email);
      if (!mounted) return;
      Navigator.pushNamed(context, '/reset-password-success');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: "Correo electrónico",
            hintText: "tu@email.com",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            prefixIcon: const Icon(Icons.email),
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF13BE61),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: _isLoading ? null : _submit,
          child: Text(_isLoading ? 'Enviando...' : 'Enviar instrucciones'),
        ),
      ],
    );
  }
}
