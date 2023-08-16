import 'package:beerstation/screens/homepage.dart';
//import 'package:beerstation/users/auth/register_screen.dart';
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
      routes: {
        "login": (context) => LoginScreen(),
        "homepage": (context) => HomePageScreen(),
      },
      title: 'BeerStation',
      theme: ThemeData(
        colorSchemeSeed: Color.fromARGB(255, 253, 108, 64),
        useMaterial3: true,
      ),
      home: LoginScreen(),
    );
  }
}
