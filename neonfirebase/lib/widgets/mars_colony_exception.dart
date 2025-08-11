class MarsColonyException implements Exception {
  final String message;
  final String errorCode;
  final String sector;
  final DateTime timestamp;

  MarsColonyException(
    this.message, {
    required this.errorCode,
    required this.sector,
  }) : timestamp = DateTime.now();

  @override
  String toString() {
    return 'MarsColonyException: $message\n'
           'Error Code: $errorCode\n'
           'Sector: $sector\n'
           'Mars Time: $timestamp\n'
           'Reported by: Alex - Mars Development Intern';
  }
}