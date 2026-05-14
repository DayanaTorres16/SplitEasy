import 'package:flutter/material.dart';

class ResetPasswordSuccessScreen extends StatelessWidget {
  const ResetPasswordSuccessScreen({super.key});

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
            Navigator.pushNamed(context, '/login');
          },
        ),
        title: const Text(
          "Volver al login",
          style: TextStyle(color: Color(0xFF13BE61)),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo-resetpassword.png',
                height: 80,
              ),
              const SizedBox(height: 20),

              const Text(
                "¡Correo enviado!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF13BE61),
                ),
              ),
              const SizedBox(height: 10),

              const Text(
                "Hemos enviado instrucciones para restablecer tu contraseña.\nRevisa tu correo electrónico.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
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
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text("Volver al login"),
              ),
              const SizedBox(height: 20),

              TextButton(
                onPressed: () {
                },
                child: const Text(
                  "¿No recibiste el correo? Reenviar",
                  style: TextStyle(color: Color(0xFF13BE61)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
