import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:notification_center/notification_center.dart';

class WaitingScreen extends StatefulWidget {
  const WaitingScreen({super.key});

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  String? decryptedMessage;
  Timer? disappearTimer;
  Timer? countdownTimer;

  int countdown = 15;
  String encryptedData = "";

  @override
  void initState() {
    super.initState();

    _startCountdown();

  
    NotificationCenter().subscribe('decryption_complete', (notification) {
      if (notification is Map<String, dynamic>) {
        final message = notification['message'];
        if (message != null) {
          setState(() {
            decryptedMessage = message;
          });

       
          disappearTimer = Timer(const Duration(seconds: 5), () {
            if (mounted) {
              setState(() {
                decryptedMessage = null;
              });
            }
          });
        }
      }
    });
  }

  void _startCountdown() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        countdown--;
        _generateEncryptedData(); 
      });

      if (countdown == 0) {
        timer.cancel();
      }
    });
  }

  void _generateEncryptedData() {
    final random = Random();
    encryptedData = List.generate(10, (_) => random.nextInt(90) + 10)
        .join(" ");
  }

  @override
  void dispose() {
    NotificationCenter().unsubscribe('decryption_complete');
    disappearTimer?.cancel();
    countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Decrypting...")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (decryptedMessage == null) ...[
                Text(
                  "⏳ $countdown seconds remaining",
                  style: style.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                Text(
                  "🔐 Encrypted message:",
                  style: style.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  encryptedData,
                  style: const TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 18,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                const Text("🕵️‍♂️ Waiting for decrypted message..."),
              ] else ...[
                Text(
                  decryptedMessage!,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}







