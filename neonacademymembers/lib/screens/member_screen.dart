import 'package:flutter/material.dart';
import 'package:neonacademymembers/models/contact_information.dart';
import 'package:neonacademymembers/models/neon_academy_members_model.dart';
class MemberScreen extends StatelessWidget {
  const MemberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Üyeleri oluştur
    final members = [
      NeonAcademyMember(
        fullName: 'Ayşe Güneş',
        title: 'Flutter Mentor',
        horoscope: 'Yay',
        memberLevel: 'Elite',
        homeTown: 'İstanbul',
        age: 29,
        contactInformation: ContactInformation(
          phoneNumber: '+90 555 111 2233',
          email: 'ayse.dev@neonacademy.com',
        ),
      ),
      NeonAcademyMember(
        fullName: 'Burak Demir',
        title: 'UI/UX Designer',
        horoscope: 'Kova',
        memberLevel: 'Intermediate',
        homeTown: 'Ankara',
        age: 25,
        contactInformation: ContactInformation(
          phoneNumber: '+90 532 444 5566',
          email: 'burak.ui@neonacademy.com',
        ),
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
