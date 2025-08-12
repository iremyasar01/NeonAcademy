import 'package:flutter/material.dart';
import 'package:myneonacademyapp/screens/cartoon_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Neon Academy Home'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartoonScreen()),
                );
              },
              child: const Text('API’s'),
            ),
            const SizedBox(height: 16),
            
            
          ],
        ),
      ),
    );
  }
}