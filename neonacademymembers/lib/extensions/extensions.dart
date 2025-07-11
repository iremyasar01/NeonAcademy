import 'dart:math';

extension PalindromeString on String {
  bool get isPalindrome {
    final cleaned = toLowerCase().replaceAll(RegExp(r'[^\p{L}]', unicode: true), '').trim();
    if (cleaned.isEmpty) return false;
    return cleaned == cleaned.split('').reversed.join('');
  }
}

extension PrimeInt on int {
  bool get isPrime {
    if (this < 2) return false;
    if (this == 2) return true;
    if (isEven) return false;
    final limit = sqrt(this).toInt() + 1;
    for (var i = 3; i < limit; i += 2) {
      if (this % i == 0) return false;
    }
    return true;
  }
}

extension DateTimeExtensions on DateTime {
  int daysBetween(DateTime other) {
    final start = DateTime(year, month, day);
    final end = DateTime(other.year, other.month, other.day);
    return end.difference(start).inDays.abs();
  }
}

extension BoolExtensions on bool {
  String toLogicResult({String trueResult = "✅ Yes", String falseResult = "❌ No"}) {
    return this ? trueResult : falseResult;
  }
  
  bool and(bool other) => this && other;
  bool or(bool other) => this || other;
  bool xor(bool other) => this != other;
}

extension DynamicExtensions on dynamic {
  String get describeType {
    if (this == null) return 'Null';
    if (this is List) return 'List<${(this as List).elementTypeName}>';
    return runtimeType.toString();
  }
}

extension SetComplaintFilter<T> on Set<T> {
  Set<String> removeDuplicateComplaints() {
    return map((e) => e.toString().toLowerCase().trim()).toSet();
  }
}

extension GroupBySurname on Map<dynamic, String> {
  Map<String, List<String>> groupBySurname() {
    final grouped = <String, List<String>>{};
    final surnameMarkers = ["oğlu", "zade", "van", "de", "bin"];
    
    forEach((_, fullname) {
      final parts = fullname.trim().split(RegExp(r'\s+'));
      String surname = parts.length >= 2 ? parts.last : '(Single Name)';
      
      for (final marker in surnameMarkers) {
        for (int i = parts.length - 2; i >= 0; i--) {
          if (parts[i].toLowerCase().contains(marker)) {
            surname = parts.sublist(i).join(' ');
            break;
          }
        }
      }
      
      grouped.putIfAbsent(surname, () => []).add(fullname);
    });
    return grouped;
  }
}

extension ElementTypeName on List {
  String get elementTypeName => isEmpty ? 'dynamic' : first.runtimeType.toString();
}

String describeDynamicType(dynamic value) {
  if (value == null) return 'Null';
  if (value is List) return 'List<${value.isEmpty ? 'dynamic' : value.first.runtimeType}>';
  return value.runtimeType.toString();
}


