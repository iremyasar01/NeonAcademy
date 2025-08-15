import 'package:flutter/material.dart';

class CrashDialog extends StatelessWidget {
  final String title;
  final String message;
  final Color titleColor;

  const CrashDialog({
    super.key,
    required this.title,
    required this.message,
    this.titleColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: TextStyle(color: titleColor, fontSize: 18)),
      content: Text(message),
      backgroundColor: const Color(0xFF2D1B1B),
      contentTextStyle: const TextStyle(color: Colors.white),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('TAMAM', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}