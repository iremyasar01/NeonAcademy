import 'package:flutter/material.dart';
import 'package:notification_center/notification_center.dart';
import 'package:neonacademymembers/screens/waiting_screen.dart';

class NotificationCenterScreen extends StatelessWidget {
  const NotificationCenterScreen({super.key});

  static const String correctCode = '3456';

  void _promptForCode(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Enter Decryption Code'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter code...'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final enteredCode = controller.text.trim();
              Navigator.pop(context); // dialogu kapat

              if (enteredCode == correctCode) {
                // Şifre doğruysa bekleme ekranına git
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const WaitingScreen(),
                  ),
                );

               
                Future.delayed(const Duration(seconds: 15), () {
                  NotificationCenter().notify(
                    'decryption_complete',
                    data: {
                      'message': '✅ The eagle flies at midnight.',
                    },
                  );
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("❌ Incorrect code!"),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🕵️ Secret Agency")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _promptForCode(context),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            textStyle: const TextStyle(fontSize: 24),
          ),
          child: const Text("🔓 Decrypt"),
        ),
      ),
    );
  }
}

