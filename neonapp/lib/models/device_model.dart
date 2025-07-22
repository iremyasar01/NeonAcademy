import 'package:flutter/material.dart';

class Device {
  final String name;
  final String icon;
  final String room;
  bool isActive;
  final Color color;

  Device({
    required this.name,
    required this.icon,
    required this.room,
    required this.isActive,
    required this.color,
  });

  double get energyUsage => isActive ? 0.2 + name.length * 0.03 : 0.0;

  double get usageLevel {
    final base = name.codeUnits.fold(0, (a, b) => a + b);
    return isActive ? (0.5 + (base % 5) * 0.1).clamp(0.0, 1.0) : 0.0;
  }
}