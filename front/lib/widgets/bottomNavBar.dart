import 'package:flutter/material.dart';
import '../screens/app-screens/main_screen.dart'; 
import '../screens/app-screens/history_screen.dart';
import '../screens/app-screens/profile_screen.dart'; 

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  void _navigateTo(BuildContext context, int index) {
    if (index == currentIndex) return; // No recargar si ya estamos ahí

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HistoryScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _navigateTo(context, index), // Aquí se maneja TODO
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'Historial'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ],
    );
  }
}
