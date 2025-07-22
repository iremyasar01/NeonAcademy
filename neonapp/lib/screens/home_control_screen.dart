import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neonapp/models/device_model.dart';
import 'package:neonapp/widgets/device_card.dart';
import 'package:neonapp/widgets/status_card.dart';

class HomeControlScreen extends StatefulWidget {
  const HomeControlScreen({super.key});

  @override
  State<HomeControlScreen> createState() => _HomeControlScreenState();
}

class _HomeControlScreenState extends State<HomeControlScreen> {
  final List<Device> devices = [
    Device(
        name: 'Smart Lighting',
        icon: '💡',
        room: 'Living Room',
        isActive: true,
        color: Colors.amber),
    Device(
        name: 'Climate Control',
        icon: '❄️',
        room: 'Whole House',
        isActive: true,
        color: Colors.blueAccent),
    Device(
        name: 'Security System',
        icon: '🔒',
        room: 'Perimeter',
        isActive: true,
        color: Colors.green),
    Device(
        name: 'Entertainment',
        icon: '📺',
        room: 'Media Room',
        isActive: false,
        color: Colors.redAccent),
  ];

  void toggleDevice(int index) {
    setState(() {
      devices[index].isActive = !devices[index].isActive;
    });
  }

  double get totalEnergy => devices.fold(0.0, (sum, d) => sum + d.energyUsage);

  @override
  Widget build(BuildContext context) {
    final currentDate = DateFormat('EEEE, MMM d').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Tech Home Control"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(currentDate, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 4),
            Text("Welcome home",
                style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: StatusCard(
                    title: "Active Devices",
                    value:
                        "${devices.where((d) => d.isActive).length}/${devices.length}",
                    icon: Icons.devices,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatusCard(
                    title: "Energy Usage",
                    value: "${totalEnergy.toStringAsFixed(2)} kW",
                    icon: Icons.bolt,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Devices", style: Theme.of(context).textTheme.titleLarge),
                IconButton(
                  icon: const Icon(Icons.tune),
                  onPressed: () {},
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: devices.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (context, index) {
                  return DeviceCard(
                    device: devices[index],
                    onToggle: () => toggleDevice(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
