import 'package:neonacademymembers/models/team_model.dart';

import '../models/neon_academy_members_model.dart';
import '../models/contact_information.dart';

final List<NeonAcademyMember> members = [
  NeonAcademyMember(
    fullName: 'Mehmet Yıldırım',
    title: 'Flutter Developer',
    horoscope: 'Yay',
    memberLevel: 'A4',
    homeTown: 'İstanbul',
    age: 29,
    contactInformation: ContactInformation(
      phoneNumber: '+90 555 123 4567',
      email: 'mehmet@gmail.com',
    ),
      team: Team.flutterDevelopment,
  ),
  NeonAcademyMember(
    fullName: 'İrem Yaşar',
    title: 'Flutter Developer',
    horoscope: 'Koç',
    memberLevel: 'A1',
    homeTown: 'Hatay',
    age: 24,
    contactInformation: ContactInformation(
      phoneNumber: '+90 555 987 6543',
      email: 'iremyasar@gmail.com',
    ),
    team: Team.flutterDevelopment,
  ),
  NeonAcademyMember(
    fullName: 'Esra Yılmaz',
    title: 'ios Developer',
    horoscope: 'Balık',
    memberLevel: 'A4',
    homeTown: 'Sinop',
    age: 22,
    contactInformation: ContactInformation(
      phoneNumber: '+90 535 976 6647',
      email: 'esra@gmail.com',
    ),
    team: Team.iosDevelopment,
  ),
  NeonAcademyMember(
    fullName: 'Deniz Türkoğlu',
    title: 'Flutter Developer',
    horoscope: 'Yengeç',
    memberLevel: 'A3',
    homeTown: 'İstanbul',
    age: 28,
    contactInformation: ContactInformation(
      phoneNumber: '+90 534 986 9647',
      email: 'deniz@gmail.com',
    ),
    team: Team.flutterDevelopment,
  ),
  NeonAcademyMember(
    fullName: 'Umut Kaya',
    title: 'ios Developer',
    horoscope: 'Başak',
    memberLevel: 'A2',
    homeTown: 'Bursa',
    age: 23,
    contactInformation: ContactInformation(
      phoneNumber: '+90 535 976 3465',
      email: 'umut@gmail.com',
    ),
    team: Team.iosDevelopment,
  ),
  NeonAcademyMember(
    fullName: 'Mert Göksu',
    title: 'UI/UX Designer',
    horoscope: 'Kova',
    memberLevel: 'A3',
    homeTown: 'İzmir',
    age: 26,
    contactInformation: ContactInformation(
      phoneNumber: '+90 536 456 3435',
      email: 'mert@gmail.com',
    ),
    team: Team.uiuxDesign,
  ),
  NeonAcademyMember(
    fullName: 'Melih Emre Ergin',
    title: 'ios Developer',
    horoscope: 'Aslan',
    memberLevel: 'A1',
    homeTown: 'Ankara',
    age: 29,
    contactInformation: ContactInformation(
      phoneNumber: '+90 505 123 6892',
      email: 'melih@gmail.com',
    ),
    team: Team.iosDevelopment,
  ),
  NeonAcademyMember(
    fullName: 'Neslişah Çelik',
    title: 'UI/UX Designer',
    horoscope: 'Kova',
    memberLevel: 'A3',
    homeTown: 'Balıkesir',
    age: 19,
    contactInformation: ContactInformation(
      phoneNumber: '+90 536 789 5634',
      email: 'nesli@gmail.com',
    ),
    team: Team.uiuxDesign,
  ),
  NeonAcademyMember(
    fullName: 'İlayda Arıkan',
    title: 'UI/UX Designer',
    horoscope: 'Terazi',
    memberLevel: 'A2',
    homeTown: 'Çanakkale',
    age: 21,
    contactInformation: ContactInformation(
      phoneNumber: '+90 536 789 5456',
      email: 'ilayda@gmail.com',
    ),
    team: Team.uiuxDesign,
  ),
  NeonAcademyMember(
    fullName: 'Oğuzhan Kara',
    title: 'Flutter Developer',
    horoscope: 'Balık',
    memberLevel: 'A1',
    homeTown: 'Kocaeli',
    age: 27,
    contactInformation: ContactInformation(
      phoneNumber: '+90 535 767 5456',
      email: 'oguzhan@gmail.com',
    ),
    team: Team.flutterDevelopment,
  ),
];
