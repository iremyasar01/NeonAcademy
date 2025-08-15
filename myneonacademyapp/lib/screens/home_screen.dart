import 'package:flutter/material.dart';
import 'package:myneonacademyapp/screens/cartoon_screen.dart';
import 'package:myneonacademyapp/screens/citizen_form_screen.dart';
import 'package:myneonacademyapp/screens/melody_maker_screen.dart';
import 'package:myneonacademyapp/screens/message_screen.dart';


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
              ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MessageScreen()),
                );
              },
              child: const Text('Http Request'),
            ),
            const SizedBox(height: 16),
              ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MelodyMakerScreen()),
                );
              },
              child: const Text('Dio'),
            ),
            const SizedBox(height: 16),
              ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CitizenFormScreen()),
                );
              },
              child: const Text('SQLite'),
            ),
            const SizedBox(height: 16),
            
          ],
        ),
      ),
    );
  }
}