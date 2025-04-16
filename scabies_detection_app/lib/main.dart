import 'package:flutter/material.dart';
import 'package:scabies_detection_app/auth/auth_gate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {

  await Supabase.initialize(
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndxdGxydXdjdWVka2F5amxxdmd3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ3NzQ2MDAsImV4cCI6MjA2MDM1MDYwMH0.ytjqgFxgo4X0CdY7xHmssR65zawtngXhGEMGJKm6Mao",
    url: "https://wqtlruwcuedkayjlqvgw.supabase.co",
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AuthGate(),
    );
  }
}
