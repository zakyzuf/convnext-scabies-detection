import 'package:flutter/material.dart';
import 'package:scabies_detection_app/utils/navigation_helper.dart';
import 'package:scabies_detection_app/widget/bottom_navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    // Navigasi ke halaman lain
    if (index == 2) {
      navigatedWithOutTransition(context, '/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 55, 58, 255), // warna latar belakang
        foregroundColor: Colors.white,
        title: Text(
          'Home Page',
        ),
      ),
      body: Center(
        child: Text(
          'Welcome to the Home Page!',
          style: TextStyle(fontSize: 24),
        ),
      ),
      bottomNavigationBar: BottomNavbar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
