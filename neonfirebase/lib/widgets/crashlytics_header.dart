import 'package:flutter/material.dart';

class CrashlyticsHeader extends StatelessWidget {
  const CrashlyticsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: const Column(
        children: [
          Text('🏙️ Yeni Umut Şehri', 
            style: TextStyle(
              fontSize: 24, 
              fontWeight: FontWeight.bold, 
              color: Colors.white
            ),
          ),
          SizedBox(height: 8),
          Text('Mars Kolonisi 2300 - Alex\'in Meydan Okuması',
            style: TextStyle(
              fontSize: 16, 
              color: Colors.red, 
              fontStyle: FontStyle.italic
            ),
          ),
        ],
      ),
    );
  }
}