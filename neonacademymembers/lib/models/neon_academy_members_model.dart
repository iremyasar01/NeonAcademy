import 'contact_information.dart';

class NeonAcademyMember {
  final String fullName;
  final String title;
  final String horoscope;
  final String memberLevel;
  final String homeTown;
  final int age;
  final ContactInformation contactInformation;

  NeonAcademyMember({
    required this.fullName,
    required this.title,
    required this.horoscope,
    required this.memberLevel,
    required this.homeTown,
    required this.age,
    required this.contactInformation,
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
Contact -> $contactInformation
''';
  }
}
