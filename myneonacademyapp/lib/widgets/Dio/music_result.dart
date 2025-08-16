import 'package:flutter/material.dart';

class ResultsHeader extends StatelessWidget {
  final String searchTerm;
  final int trackCount;

  const ResultsHeader({
    super.key,
    required this.searchTerm,
    required this.trackCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Text(
            "Searching for '$searchTerm'...",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Spacer(),
          Text(
            'track $trackCount',
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}