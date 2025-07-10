import 'package:flutter/material.dart';
import 'package:neonacademymembers/models/contact_information.dart';
import 'package:neonacademymembers/models/neon_academy_members_model.dart';
class MemberScreen extends StatelessWidget {
  const MemberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ContactMentor = ContactInformation(
      phoneNumber: '+90 555 123 4567',
      email: 'hasabektas@gmail.com',
    );
    final ContactJr = ContactInformation(
      phoneNumber: '+90 555 987 6543',
      email: 'iremyasar@gmail.com',
    );
    final members = [
      NeonAcademyMember(
        fullName: 'Hasan Bektaş',
        title: 'Flutter Mentor',
        horoscope: 'Yay',
        memberLevel: 'Mentor',
        homeTown: 'İstanbul',
        age: 29,
        contactInformation: ContactMentor,
        ),
    
      NeonAcademyMember(
        fullName: 'İrem Yaşar',
        title: 'Flutter Developer',
        horoscope: 'Koç',
        memberLevel: 'Beginner',
        homeTown: 'Hatay',
        age: 24,
        contactInformation: ContactJr,
        ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text( 'Members')),
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
                        child: const Text('Kapat'),
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
