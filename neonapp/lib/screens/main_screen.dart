import 'package:flutter/material.dart';
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adapty Main Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to Adapty Premium!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            Image.asset('assets/images/logo.jpeg', width: 200),
            const SizedBox(height: 40),
            const Text('Stone Age Productivity Enhanced',
                style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}