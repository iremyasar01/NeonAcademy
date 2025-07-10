import 'package:flutter/material.dart';
import 'package:neonacademymembers/data/members_data.dart';
import 'package:neonacademymembers/models/neon_academy_members_model.dart';
import 'package:neonacademymembers/models/contact_information.dart';
import 'package:neonacademymembers/models/team_model.dart';

class TaskTwoScreen extends StatefulWidget {
  const TaskTwoScreen({super.key});

  @override
  State<TaskTwoScreen> createState() => _TaskTwoScreenState();
}

class _TaskTwoScreenState extends State<TaskTwoScreen> {
  List<NeonAcademyMember> localMembers = List.from(members);

  final levelPriority = {
    'Mentor': 5,
    'A4': 4,
    'A3': 3,
    'A2': 2,
    'A1': 1,
  };

  void showResultsDialog({
    required String title,
    required List<String> before,
    required List<String> after,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Before:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...before.map((e) => Text('- $e')),
                const SizedBox(height: 10),
                const Text('After:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...after.map((e) => Text('- $e')),
              ],
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

  Widget actionButton(String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ElevatedButton(onPressed: onPressed, child: Text(label)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Two')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            actionButton('Remove 3rd Member', () {
              final before = localMembers.map((e) => e.fullName).toList();
              if (localMembers.length > 2) {
                localMembers.removeAt(2);
              }
              final after = localMembers.map((e) => e.fullName).toList();
              showResultsDialog(title: 'Removed 3rd Member', before: before, after: after);
            }),
            actionButton('Sort by Age (Descending)', () {
              final before = localMembers.map((e) => e.fullName).toList();
              localMembers.sort((a, b) => b.age.compareTo(a.age));
              final after = localMembers.map((e) => e.fullName).toList();
              showResultsDialog(title: 'Sorted by Age (Descending)', before: before, after: after);
            }),
            actionButton('Sort by Name (Z-A)', () {
              final before = localMembers.map((e) => e.fullName).toList();
              localMembers.sort((a, b) => b.fullName.compareTo(a.fullName));
              final after = localMembers.map((e) => e.fullName).toList();
              showResultsDialog(title: 'Sorted by Name (Z-A)', before: before, after: after);
            }),
            actionButton('Filter Members > 24 Age', () {
              final filtered = localMembers.where((m) => m.age > 24).map((e) => e.fullName).toList();
              showResultsDialog(title: 'Members Older Than 24', before: [], after: filtered);
            }),
            actionButton('Count iOS Developers', () {
              final count = localMembers.where((m) => m.title.toLowerCase() == 'ios developer').length;
              showResultsDialog(title: 'Number of iOS Developers', before: [], after: ['Total: $count']);
            }),
            actionButton('Find Index of İrem Yaşar', () {
              final index = localMembers.indexWhere((m) => m.fullName == 'İrem Yaşar');
              showResultsDialog(title: 'Index of İrem Yaşar', before: [], after: ['Index: $index']);
            }),
            actionButton('Add Mentor', () {
              final before = localMembers.map((e) => e.fullName).toList();
              final exists = localMembers.any((m) => m.fullName == 'Hasan Bektaş');
              if (!exists) {
                final mentor = NeonAcademyMember(
                  fullName: 'Hasan Bektaş',
                  title: 'Mentor',
                  horoscope: 'Koç',
                  memberLevel: 'Mentor',
                  homeTown: 'Istanbul',
                  age: 30,
                  contactInformation: ContactInformation(
                    phoneNumber: '+90 545 521 1324',
                    email: 'hasanbektas@gmail.com',
                  ),
                  team: Team.flutterDevelopment,
                );
                localMembers.add(mentor);
              }
              final after = localMembers.map((e) => e.fullName).toList();
              showResultsDialog(title: 'After Adding Mentor (if not present)', before: before, after: after);
            }),
            actionButton('Remove Members with A1 Level', () {
              final before = localMembers.map((e) => e.fullName).toList();
              localMembers.removeWhere((m) => m.memberLevel == 'A1');
              final after = localMembers.map((e) => e.fullName).toList();
              showResultsDialog(title: 'Removed Members with Level A1', before: before, after: after);
            }),
            actionButton('Find Oldest Member', () {
              final oldest = localMembers.reduce((a, b) => a.age > b.age ? a : b);
              showResultsDialog(title: 'Oldest Member', before: [], after: ['${oldest.fullName} (${oldest.age})']);
            }),
            actionButton('Find Longest Name', () {
              final longest = localMembers.reduce((a, b) => a.fullName.length > b.fullName.length ? a : b);
              showResultsDialog(title: 'Member with Longest Name', before: [], after: ['${longest.fullName} (${longest.fullName.length})']);
            }),
            actionButton('Group by Horoscope', () {
              final Map<String, List<NeonAcademyMember>> grouped = {};
              for (var member in localMembers) {
                grouped.putIfAbsent(member.horoscope, () => []).add(member);
              }
              final List<String> resultList = [];
              grouped.forEach((key, value) {
                if (value.length > 1) {
                  resultList.add('$key:');
                  resultList.addAll(value.map((e) => ' - ${e.fullName}'));
                }
              });
              showResultsDialog(title: 'Grouped by Horoscope', before: [], after: resultList);
            }),
            actionButton('Find Most Common Hometown', () {
              final Map<String, int> hometownFrequency = {};
              for (var member in localMembers) {
                hometownFrequency.update(member.homeTown, (value) => value + 1, ifAbsent: () => 1);
              }
              final mostCommon = hometownFrequency.entries.reduce((a, b) => a.value > b.value ? a : b);
              showResultsDialog(title: 'Most Common Hometown', before: [], after: ['${mostCommon.key} (${mostCommon.value} members)']);
            }),
            actionButton('Calculate Average Age', () {
              final avgAge = localMembers.map((e) => e.age).reduce((a, b) => a + b) / localMembers.length;
              showResultsDialog(title: 'Average Age of Members', before: [], after: ['Average Age: ${avgAge.toStringAsFixed(2)}']);
            }),
            actionButton('Show All Emails', () {
              final emails = localMembers.map((e) => e.contactInformation.email).toList();
              showResultsDialog(title: 'Emails of All Members', before: [], after: emails);
            }),
            actionButton('Sort by Member Level (High to Low)', () {
              final before = localMembers.map((e) => e.fullName).toList();
              localMembers.sort((a, b) =>
                (levelPriority[b.memberLevel] ?? 0).compareTo(levelPriority[a.memberLevel] ?? 0));
              final after = localMembers.map((e) => e.fullName).toList();
              showResultsDialog(title: 'Sorted by Member Level', before: before, after: after);
            }),
            actionButton('Group Phones by Title', () {
              final Map<String, List<ContactInformation>> titleGroups = {};
              for (var member in localMembers) {
                titleGroups.putIfAbsent(member.title, () => []).add(member.contactInformation);
              }
              final List<String> phones = [];
              titleGroups.forEach((title, contacts) {
                if (contacts.isNotEmpty) {
                  phones.add('$title:');
                  phones.addAll(contacts.map((c) => ' - ${c.phoneNumber}'));
                }
              });
              showResultsDialog(title: 'Phone Numbers Grouped by Title', before: [], after: phones);
            }),
          ],
        ),
      ),
    );
  }
}
