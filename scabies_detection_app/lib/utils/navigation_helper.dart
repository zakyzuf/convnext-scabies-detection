import 'package:flutter/material.dart';
import 'package:scabies_detection_app/auth/view/profile_page.dart';
import 'package:scabies_detection_app/home/view/home_page.dart';

void navigatedWithOutTransition(BuildContext context, String routeName) {
  Navigator.of(context).pushReplacement(
    PageRouteBuilder(
      pageBuilder: (_, __, ___) =>  _getRouteFromName(context, routeName) ?? const HomePage(),
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      transitionsBuilder: (_, __, ___, child) => child,
    ),
  );
}

Widget? _getRouteFromName(BuildContext context, String name) {
  final Map<String, WidgetBuilder> routes = {
    '/home': (context) => const HomePage(),
    '/profile': (context) => const ProfilPage(),
  };

  final builder = routes[name];
  return builder != null ? builder(context) : null;
}
