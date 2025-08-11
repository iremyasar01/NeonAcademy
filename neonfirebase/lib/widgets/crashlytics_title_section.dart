import 'package:flutter/material.dart';

class CrashlyticsTitleSection extends StatelessWidget {
  const CrashlyticsTitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text("Alex'in Görevi: Firebase Crashlytics Testi",
          style: TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.bold, 
            color: Colors.white
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 5),
        Text('Meydan okumayı tamamlamak için çökme yönteminizi seçin!',
          style: TextStyle(
            fontSize: 14, 
            color: Colors.orange
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}