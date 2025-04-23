import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scabies_detection_app/auth/provider/auth_gate.dart';
import 'package:scabies_detection_app/auth/view/profile_page.dart';
import 'package:scabies_detection_app/history/provider/history_provider.dart';
import 'package:scabies_detection_app/home/view/home_page.dart';
import 'package:scabies_detection_app/scanning/provider/scanner_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {

  await Supabase.initialize(
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndxdGxydXdjdWVka2F5amxxdmd3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ3NzQ2MDAsImV4cCI6MjA2MDM1MDYwMH0.ytjqgFxgo4X0CdY7xHmssR65zawtngXhGEMGJKm6Mao",
    url: "https://wqtlruwcuedkayjlqvgw.supabase.co",
  );

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
        ChangeNotifierProvider(create: (_) => ScannerProvider()),
      ],
      child: const MainApp(),
    ),);
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255), // <-- ganti warna background global di sini
        primarySwatch: Colors.blue,
      ),
      home: const AuthGate(),
      routes: {
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilPage(),
      },
    );
  }
}

