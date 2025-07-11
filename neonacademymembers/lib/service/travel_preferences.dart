import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TravelPreferences {
  static const String _placesKey = 'places';

  Future<void> savePlaces(List<Map<String, dynamic>> places) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(places);
    await prefs.setString(_placesKey, encoded);
  }

  Future<List<Map<String, dynamic>>> loadPlaces() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_placesKey);
    if (data != null) {
      return List<Map<String, dynamic>>.from(jsonDecode(data));
    } else {
      return [];
    }
  }

  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_placesKey);
  }
}
