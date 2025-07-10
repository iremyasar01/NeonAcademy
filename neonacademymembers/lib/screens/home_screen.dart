import 'package:flutter/material.dart';
import 'package:neonacademymembers/screens/member_screen.dart';
import 'package:neonacademymembers/screens/task_two_screen.dart';

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
                  MaterialPageRoute(builder: (context) => const MemberScreen()),
                );
              },
              child: const Text('Neon Academy Members'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TaskTwoScreen()),
                );
              },
              child: const Text('Task Two Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
