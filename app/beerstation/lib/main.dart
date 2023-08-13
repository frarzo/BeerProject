import 'package:flutter/material.dart';
import 'package:beerstation/users/auth/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BeerStation',
      theme: ThemeData(
        colorSchemeSeed: const Color.fromARGB(255, 255, 168, 0),
        useMaterial3: true,
      ),
      home: LoginScreen(),
    );
  }
}
