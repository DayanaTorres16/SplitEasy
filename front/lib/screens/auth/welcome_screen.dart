import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF13BE61),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icono-inicio.png',
              height: 100,
            ),
            const SizedBox(height: 20),

            const Text(
              "Bienvenidos a SplitEasy",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            const Text(
              "Divide gastos con amigos y familia\n de forma fácil y rápida",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 40),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF13BE61),
                minimumSize: const Size(200, 50),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text("Iniciar Sesión"),
            ),
            const SizedBox(height: 15),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF13BE61),
                minimumSize: const Size(200, 50),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text("Crear Cuenta"),
            ),
          ],
        ),
      ),
    );
  }
}
