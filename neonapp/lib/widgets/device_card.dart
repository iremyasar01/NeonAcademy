import 'package:flutter/material.dart';
import 'package:neonapp/models/device_model.dart';

class DeviceCard extends StatelessWidget {
  final Device device;
  final VoidCallback onToggle;

  const DeviceCard({
    super.key,
    required this.device,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1C2E),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: device.color.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: device.color.withOpacity(0.2),
                child: Text(device.icon, style: const TextStyle(fontSize: 20)),
              ),
              Switch(
                value: device.isActive,
                activeColor: device.color,
                onChanged: (_) => onToggle(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(device.name, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(device.room, style: Theme.of(context).textTheme.bodyLarge),
          const Spacer(),
          LinearProgressIndicator(
            value: device.usageLevel,
            backgroundColor: Colors.grey.shade800,
            color: device.color,
          ),
        ],
      ),
    );
  }
}
