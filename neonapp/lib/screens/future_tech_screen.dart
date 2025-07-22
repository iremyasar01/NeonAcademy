import 'package:flutter/material.dart';
import 'package:neonapp/screens/home_control_screen.dart';
class FutureTechScreen extends StatelessWidget {
  const FutureTechScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    
      debugShowCheckedModeBanner: false,
      title: 'FutureTech',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0E21),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFF00D1FF),
          primary: const Color(0xFF00D1FF),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 32, 
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
          titleLarge: TextStyle(
            fontSize: 24, 
            fontWeight: FontWeight.w600,
            color: Colors.white
          ),
          bodyLarge: TextStyle(
            fontSize: 18, 
            color: Color(0xFF8D8E98)
          ),
        ),
      ),
      home: const HomeControlScreen(),
    );
  }
}
