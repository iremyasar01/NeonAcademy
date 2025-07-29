import 'package:flutter/material.dart';
class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: 
      const Text('Premium Screen'),
      backgroundColor: Colors.yellow[100],
      ),
      body: const Center(
        child: Text('Welcome to the Premium Features!'),
      ),
    );
  }
}
