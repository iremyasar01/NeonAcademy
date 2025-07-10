import 'package:flutter/material.dart';
import 'package:neonacademymembers/models/team_model.dart';
import '../data/members_data.dart';

class EnumSwitchScreen extends StatelessWidget {
  const EnumSwitchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Team Tasks')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            taskButton(context, 'Flutter Members', () => _showDialog(context, 'Flutter Development Team Members:',
              members
                  .where((m) => m.team == Team.flutterDevelopment)
                  .map((m) => m.fullName)
                  .toList())),

           taskButton(context, 'UI/UX Team Count', () {
              final Map<Team, int> teamCounts = {};
              for (var member in members) {
                teamCounts.update(member.team, (value) => value + 1, ifAbsent: () => 1);
              }
              final count = teamCounts[Team.uiuxDesign] ?? 0;
              _showDialog(context, 'UI/UX Design Team Count :', ['Total: $count']);
            }),

            taskButton(context, 'iOS Team Members', () => _showDialog(context, 'iOS Development Team Members:',
              members
                  .where((m) => m.team == Team.iosDevelopment)
                  .map((m) => m.fullName)
                  .toList())),

            taskButton(context, 'Team Descriptions', () => _showDialog(context, 'Team Descriptions:',
              members.map((member) {
                switch (member.team) {
                  case Team.flutterDevelopment:
                    return '${member.fullName} is a skilled Flutter developer';
                  case Team.uiuxDesign:
                    return '${member.fullName} is a talented designer';
                  case Team.iosDevelopment:
                    return '${member.fullName} builds beautiful iOS apps';
                  case Team.androidDevelopment:
                    return '${member.fullName} develops Android applications';
                }
              }).toList())),

            taskButton(context, 'Flutter Members Older Than 25', () => _showDialog(context, 'Flutter Members Older Than 25:',
              members
                  .where((m) => m.age > 25 && m.team == Team.flutterDevelopment)
                  .map((m) => m.fullName)
                  .toList())),

            taskButton(context, 'Promotions by Team', () => _showDialog(context, 'Promotions:',
              members.map((m) {
                switch (m.team) {
                  case Team.flutterDevelopment:
                    return '${m.fullName} promoted to Senior Flutter Developer';
                  case Team.uiuxDesign:
                    return '${m.fullName} promoted to Lead Designer';
                  case Team.iosDevelopment:
                    return '${m.fullName} promoted to Senior iOS Developer';
                  case Team.androidDevelopment:
                    return '${m.fullName} promoted to Senior Android Developer';
                }
              }).toList())),

            taskButton(context, 'Average Age (UI/UX)', () {
              final uiux = members.where((m) => m.team == Team.uiuxDesign).toList();
              final avg = uiux.map((e) => e.age).reduce((a, b) => a + b) / uiux.length;
              _showDialog(context, 'Average Age (UI/UX):', [avg.toStringAsFixed(2)]);

            }),

            taskButton(context, 'Team Messages', () => _showDialog(context, 'Team Messages:',
              Team.values.map((team) {
                switch (team) {
                  case Team.flutterDevelopment:
                    return 'The Flutter Development Team is the backbone of our academy';
                  case Team.uiuxDesign:
                    return 'The UI/UX Design Team is the face of our academy';
                  case Team.iosDevelopment:
                    return 'The iOS Development Team builds elegant solutions';
                  case Team.androidDevelopment:
                    return 'The Android Development Team drives mobile innovation';
                }
              }).toList())),

            taskButton(context, 'iOS Team Contacts', () => _showDialog(context, 'iOS Team Contacts:',
              members
                  .where((m) => m.team == Team.iosDevelopment)
                  .map((m) => m.contactInformation.toString())
                  .toList())),

            taskButton(context, 'Custom Age & Team Message', () => _showDialog(context, 'Custom Messages:',
              members.map((member) {
                if (member.team == Team.flutterDevelopment && member.age > 23) {
                  return '${member.fullName} is a seasoned Flutter developer';
                } else if (member.team == Team.uiuxDesign && member.age < 24) {
                  return '${member.fullName} is a rising star in the design world';
                } else {
                  return '${member.fullName} is a valuable team member';
                }
              }).toList())),
          ],
        ),
      ),
    );
  }

  Widget taskButton(BuildContext context, String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }

  void _showDialog(BuildContext context, String title, List<String> messages) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: messages.map((e) => Text('- $e')).toList(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}