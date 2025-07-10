import 'package:flutter/material.dart';
import 'package:neonacademymembers/data/members_data.dart'; // members listesini buradan alıyoruz

class MemberScreen extends StatelessWidget {
  const MemberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Members')),
      body: ListView.builder(
        itemCount: members.length,
        itemBuilder: (context, index) {
          final member = members[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(member.fullName),
              subtitle: Text('${member.title} • ${member.horoscope}'),
              trailing: Text(member.memberLevel),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(member.fullName),
                    content: Text(member.toString()),
                    actions: [
                      TextButton(
                        child: const Text('Close'),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

