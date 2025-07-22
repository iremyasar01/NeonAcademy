import 'package:flutter/material.dart';
class AttractionCard extends StatelessWidget {
  final Color color;

  const AttractionCard({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.landscape, size: 40),
          SizedBox(height: 8),
          Text(
            'Attraction',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('Must-see spot', style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}