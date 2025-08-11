import 'package:flutter/material.dart';
import 'package:neonfirebase/screens/crashlytics_screen.dart';
import 'package:neonfirebase/screens/firestore_screen.dart';
import 'package:neonfirebase/screens/remote_config_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Neon Firebase',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FirestoreScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(20),
                ),
                child: const Text('Firestore')),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RemoteConfigScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(20),
                ),
                child: const Text('Remote Config')),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CrashlyticsScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(20),
                ),
                child: const Text('Crashlytics')),
          ],
        ),
      )),
    );
  }
}
