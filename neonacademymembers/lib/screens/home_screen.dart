import 'package:flutter/material.dart';
import 'package:neonacademymembers/screens/enum_switch_screen.dart';
import 'package:neonacademymembers/screens/extensions_screen.dart';
import 'package:neonacademymembers/screens/member_screen.dart';
import 'package:neonacademymembers/screens/notification_center_screen.dart';
import 'package:neonacademymembers/screens/task_two_screen.dart';
import 'package:neonacademymembers/screens/travel_screen.dart';
import 'package:neonacademymembers/screens/unwrapping_screen.dart';

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
              child: const Text('Task Arrays'),
            ),
               const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EnumSwitchScreen()),
                );
              },
              child: const Text('Task Enum and Switch'),
            ),
              const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UnwrappingScreen()),
                );
              },
              child: const Text('Task Unwrapping'),
            ),
               const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TravelScreen()),
                );
              },
              child: const Text('Task Shared Preferences'),
            ),
                 const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationCenterScreen()),
                );
              },
              child: const Text('Task Notification Center'),
            ),
                  const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ExtensionScreen()),
                );
              },
              child: const Text('Task Extensions'),
            ),
          ],
        ),
      ),
    );
  }
}
