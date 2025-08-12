import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RatingSystem {
  static const String _prefix = "rating_";

  static Future<void> saveRating(int? cartoonId, double rating) async {
    if (cartoonId == null) return;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('$_prefix$cartoonId', rating);
    debugPrint('Puan kaydedildi: ID $cartoonId -> $rating'); 
  }

  static Future<double> getRating(int? cartoonId) async {
    if (cartoonId == null) return 0.0;
    
    final prefs = await SharedPreferences.getInstance();
    final rating = prefs.getDouble('$_prefix$cartoonId') ?? 0.0;
    debugPrint('Puan yüklendi: ID $cartoonId -> $rating'); 
    return rating;
  }
}