import 'package:flutter/material.dart';
import 'package:squat_assistance/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Squat Assistance App",
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.brown,
          primary: Colors.brown.shade400,
          secondary: Colors.brown.shade200,
          error: Colors.red.shade700,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
