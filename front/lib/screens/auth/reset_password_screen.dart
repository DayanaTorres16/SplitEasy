import 'package:flutter/material.dart';

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

            TextField(
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
              onPressed: () {
                Navigator.pushNamed(context, '/reset-password-success');
              },
              child: const Text("Enviar instrucciones"),
            ),
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
