class ContactInformation {
  final String phoneNumber;
  final String email;

  ContactInformation({
    required this.phoneNumber,
    required this.email,
  });

  @override
  String toString() {
    return 'Phone: $phoneNumber, Email: $email';
  }
}
