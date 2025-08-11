import 'package:flutter/material.dart';

class CrashlyticsWarning extends StatelessWidget {
  const CrashlyticsWarning({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: const Text(
        '⚠️ UYARI: Ölümcül çökme butonları uygulamayı anında kapatır!\n'
        'Sonuçları görmek için Firebase Crashlytics panosunu kontrol edin.',
        style: TextStyle(
          color: Colors.red, 
          fontSize: 12, 
          fontWeight: FontWeight.w500
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}