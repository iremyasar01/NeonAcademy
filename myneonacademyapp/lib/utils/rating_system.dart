import 'package:shared_preferences/shared_preferences.dart';

class RatingSystem {
  static const String _prefix = "rating_";

  static Future<void> saveRating(int cartoonId, double rating) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('$_prefix$cartoonId', rating);
  }

  static Future<double> getRating(int cartoonId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('$_prefix$cartoonId') ?? 0.0;
  }
}