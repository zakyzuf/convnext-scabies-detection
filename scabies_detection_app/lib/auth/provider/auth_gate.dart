import 'package:flutter/material.dart';
import 'package:scabies_detection_app/auth/view/login_page.dart';
// import 'package:scabies_detection_app/dashboard/view/dashboard_page.dart';
import 'package:scabies_detection_app/home/view/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          final session = snapshot.hasData ? snapshot.data!.session : null;

          if (session != null) {
            return const HomePage();
          } else {
            return const LoginPage();
          }
        });
  }
}
