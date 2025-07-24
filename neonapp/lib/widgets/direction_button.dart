import 'package:flutter/material.dart';

class DirectionButton extends StatelessWidget {
  final String direction;
  final VoidCallback onPressed;
  final IconData icon;

  const DirectionButton({
    super.key,
    required this.direction,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        icon: Icon(icon, size: 50),
        color: Colors.white,
        onPressed: onPressed,
      ),
    );
  }
}
