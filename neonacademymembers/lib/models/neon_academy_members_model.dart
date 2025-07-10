import 'package:neonacademymembers/models/team_model.dart';
import 'contact_information.dart';

class NeonAcademyMember {
  final String fullName;
  final String title;
  final String horoscope;
  final String memberLevel;
  final String homeTown;
  final int age;
  final ContactInformation contactInformation;
  final Team  team;

  NeonAcademyMember({
    required this.fullName,
    required this.title,
    required this.horoscope,
    required this.memberLevel,
    required this.homeTown,
    required this.age,
    required this.contactInformation,
    required this.team,
  });

  @override
  String toString() {
    return '''
Name: $fullName
Title: $title
Horoscope: $horoscope
Level: $memberLevel
Hometown: $homeTown
Age: $age
Team: ${team.displayName}
Contact -> $contactInformation
''';
  }
}
