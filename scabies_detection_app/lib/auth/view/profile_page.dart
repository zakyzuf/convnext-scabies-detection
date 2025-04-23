import 'package:flutter/material.dart';
import 'package:scabies_detection_app/auth/provider/auth_service.dart';
import 'package:scabies_detection_app/utils/navigation_helper.dart';
import 'package:scabies_detection_app/widget/bottom_navbar.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final authService = AuthService();
  int _selectedIndex = 2;

  void logout() async {
    await authService.signOut();
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    // Navigasi ke halaman lain
    if (index == 0) {
      navigatedWithOutTransition(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentEmail = authService.getCurrentUserEmail();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              logout();
            },
          ),
        ],
        backgroundColor: Color.fromARGB(255, 55, 58, 255), // warna latar belakang
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the Profile Page!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Text(
              'Current User Email: $currentEmail',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavbar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
