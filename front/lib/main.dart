import 'package:flutter/material.dart';
import 'screens/auth/welcome_screen.dart';
import 'screens/auth/login_screen.dart'; 
import 'screens/auth/register_screen.dart';
import 'screens/auth/reset_password_screen.dart';
import 'screens/auth/reset_password_success_screen.dart';
import 'screens/auth/new_password_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/reset-password': (context) => const ResetPasswordScreen(),
        '/reset-password-success': (context) => const ResetPasswordSuccessScreen(),
        '/new-password': (context) => const NewPasswordScreen(),
      },
    );
  }
}
