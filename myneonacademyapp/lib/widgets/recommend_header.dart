import 'package:flutter/material.dart';

class RecommendedHeader extends StatelessWidget {
  final VoidCallback onRefresh;

  const RecommendedHeader({
    super.key,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Row(
        children: [
          const Text(
            'Recommended for you',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: onRefresh,
            tooltip: 'Refresh recommendations',
          ),
        ],
      ),
    );
  }
}