import 'package:flutter/material.dart';

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({super.key});
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.indigo[800],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.amber.shade600, width: 2),
      ),
      title: const Text(
        'Registration Successful!',
        style: TextStyle(color: Colors.amber),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: Colors.green[300], size: 60),
          const SizedBox(height: 20),
          const Text(
            "Citizen information has been saved to the Archives",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
      actions: [
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Continue', style: TextStyle(color: Colors.black)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ],
    );
  }
}