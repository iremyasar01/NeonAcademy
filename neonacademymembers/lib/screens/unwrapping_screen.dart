import 'package:flutter/material.dart';
import '../models/neon_academy_members_model.dart';
import '../data/members_data.dart';

class UnwrappingScreen extends StatefulWidget {
  const UnwrappingScreen({super.key});

  @override
  State<UnwrappingScreen> createState() => _UnwrappingScreenState();
}

class _UnwrappingScreenState extends State<UnwrappingScreen> {
  late NeonAcademyMember selectedMember;

  @override
  void initState() {
    super.initState();
    selectedMember = members.first;
  }

  void increaseMotivation(NeonAcademyMember member, int amount) {
    setState(() {
      if (member.motivationLevel == null) {
        member.motivationLevel = 1;
      } else {
        member.motivationLevel = member.motivationLevel! + amount;
      }
    });
  }

  void describeMotivation(NeonAcademyMember member) {
    if (member.motivationLevel == null) {
      _showDialog("Motivation Status", ["This member has no motivation level set"]);
      return;
    }
    if (member.motivationLevel! > 5) {
      _showDialog("Motivation Status", ["This member is highly motivated"]);
    } else {
      _showDialog("Motivation Status", ["This member is moderately motivated"]);
    }
  }

  String getMotivationDescription(int? level) {
    if (level == null) return "Not motivated at all";
    if (level > 5) return "Highly motivated";
    if (level > 2) return "Moderately motivated";
    return "Barely motivated";
  }

  int getMotivationOrZero(NeonAcademyMember member) {
    return member.motivationLevel ?? 0;
  }

  bool hasReachedMotivation(NeonAcademyMember member, int targetLevel) {
    final current = member.motivationLevel;
    if (current != null) {
      return current >= targetLevel;
    }
    return false;
  }

  void _showDialog(String title, List<String> messages) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: messages.map((e) => Text("- $e")).toList(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"),
          )
        ],
      ),
    );
  }

  Widget actionButton(String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: SizedBox(
        width: 250,
        child: ElevatedButton(onPressed: onPressed, child: Text(label)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Unwrapping Examples")),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<NeonAcademyMember>(
                value: selectedMember,
                onChanged: (value) {
                  setState(() => selectedMember = value!);
                },
                items: members.map((m) => DropdownMenuItem(
                  value: m,
                  child: Text(m.fullName),
                )).toList(),
              ),
              const SizedBox(height: 20),
              actionButton("Increase Motivation by 2", () => increaseMotivation(selectedMember, 2)),
              actionButton("Describe Motivation", () => describeMotivation(selectedMember)),
              actionButton("Describe Motivation Level Text", () {
                final result = getMotivationDescription(selectedMember.motivationLevel);
                _showDialog("Motivation Description", [result]);
              }),
              actionButton("Get Motivation Level or 0", () {
                final result = getMotivationOrZero(selectedMember);
                _showDialog("Motivation Value", ["Motivation: $result"]);
              }),
              actionButton("Check If Reached Target", () {
                final reached = hasReachedMotivation(selectedMember, 5);
                _showDialog("Motivation Check", [reached ? "Reached!" : "Not yet..."]);
              }),
            ],
          ),
        ),
      ),
    );
  }
}

