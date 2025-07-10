import 'package:flutter/material.dart';
import 'package:neonacademymembers/models/contact_information.dart';
import 'package:neonacademymembers/models/neon_academy_members_model.dart';
class MemberScreen extends StatelessWidget {
  const MemberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contactMentor = ContactInformation(
      phoneNumber: '+90 555 123 4567',
      email: 'hasabektas@gmail.com',
    );
    final contactIrem = ContactInformation(
      phoneNumber: '+90 555 987 6543',
      email: 'iremyasar@gmail.com',
    );
    final contactEsra = ContactInformation(
      phoneNumber: '+90 535 976 6647',
      email: 'esra@gmail.com',
    );
      final contactDeniz = ContactInformation(
      phoneNumber: '+90 534 986 9647',
      email: 'deniz@gmail.com',
    );
      final contactUmut = ContactInformation(
      phoneNumber: '+90 535 976 3465',
      email: 'umut@gmail.com',
    );
     final contactMert = ContactInformation(
      phoneNumber: '+90 536 456 3435',
      email: 'mert@gmail.com',
    );
     final contactMelih = ContactInformation(
      phoneNumber: '+90 505 123 6892',
      email: 'melih@gmail.com',
    );
     final contactNesli = ContactInformation(
      phoneNumber: '+90 536 789 5634',
      email: 'nesli@gmail.com',
    );
     final contactIlayda = ContactInformation(
      phoneNumber: '+90 536 789 5456',
      email: 'ilayda@gmail.com',
    );
    final contactOguzhan = ContactInformation(
      phoneNumber: '+90 535 767 5456',
      email: 'oguzhan@gmail.com',
    );
    final members = [
      NeonAcademyMember(
        fullName: 'Hasan Bektaş',
        title: 'Flutter Mentor',
        horoscope: 'Yay',
        memberLevel: 'A4',
        homeTown: 'İstanbul',
        age: 29,
        contactInformation: contactMentor,
        ),
    
      NeonAcademyMember(
        fullName: 'İrem Yaşar',
        title: 'Flutter Developer',
        horoscope: 'Koç',
        memberLevel: 'A1',
        homeTown: 'Hatay',
        age: 24,
        contactInformation: contactIrem,
        ),
        NeonAcademyMember(
        fullName: 'Esra Yılmaz',
        title: 'ios Developer',
        horoscope: 'Balık',
        memberLevel: 'A4',
        homeTown: 'Sinop',
        age: 22,
        contactInformation: contactEsra,      
        ),
          NeonAcademyMember(
        fullName: 'Deniz Türkoğlu',
        title: 'Flutter Developer',
        horoscope: 'Yengeç',
        memberLevel: 'A3',
        homeTown: 'İstanbul',
        age: 28,
        contactInformation: contactDeniz,      
        ),
          NeonAcademyMember(
        fullName: 'Umut Kaya',
        title: 'ios Developer',
        horoscope: 'Başak',
        memberLevel: 'A2',
        homeTown: 'Bursa',
        age: 23,
        contactInformation: contactUmut,      
        ),
           NeonAcademyMember(
        fullName: 'Mert Göksu',
        title: 'UI/UX Designer',
        horoscope: 'Kova',
        memberLevel: 'A3',
        homeTown: 'İzmir',
        age: 26,
        contactInformation: contactMert,      
        ),
          NeonAcademyMember(
        fullName: 'Melih Emre Ergin',
        title: 'ios Developer',
        horoscope: 'Aslan',
        memberLevel: 'A1',
        homeTown: 'Ankara',
        age: 29,
        contactInformation: contactMelih,      
        ),
            NeonAcademyMember(
        fullName: 'Neslişah Çelik',
        title: 'UI/UX Designer',
        horoscope: 'Kova',
        memberLevel: 'A3',
        homeTown: 'Balıkesir',
        age: 19,
        contactInformation: contactNesli,      
        ),
            NeonAcademyMember(
        fullName: 'İlayda Arıkan',
        title: 'UI/UX Designer',
        horoscope: 'Terazi',
        memberLevel: 'A2',
        homeTown: 'Çanakkale',
        age: 21,
        contactInformation: contactIlayda,      
        ),
           NeonAcademyMember(
        fullName: 'Oğuzhan Kara',
        title: 'Flutter Developer',
        horoscope: 'Balık',
        memberLevel: 'A1',
        homeTown: 'Kocaeli',
        age: 27,
        contactInformation: contactOguzhan,      
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
