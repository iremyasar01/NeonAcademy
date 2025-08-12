import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myneonacademyapp/constants/cartoon_api_constants.dart';
import 'package:myneonacademyapp/models/cartoons_model.dart';
import 'package:myneonacademyapp/widgets/image_validator.dart';

class CartoonApiService {
  static const String _baseUrl = CartoonApiConstants.baseUrl;
  static const String _placeholderPath = 'assets/images/no_image.png';

  Future<List<CartoonsModel>> fetchCartoons() async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/cartoons/cartoons2D"),
        headers: {'User-Agent': 'MyNeonAcademyApp/1.0'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        // 1. ID'ye göre filtrele (23 ve altı)
        final filteredCartoons = data
            .map((json) => CartoonsModel.fromJson(json))
            .where((cartoon) => cartoon.id != null && cartoon.id! <= 23)
            .toList();

        debugPrint('çizgi film sayısı: ${filteredCartoons.length}');

        // 2. Resim URL'lerini doğrula ve geçersiz olanları asset ile değiştir
        final validatedCartoons = <CartoonsModel>[];
        
        for (var cartoon in filteredCartoons) {
          final validated = await _validateImage(cartoon);
          validatedCartoons.add(validated);
        }
        
        debugPrint('Doğrulanmış çizgi film sayısı: ${validatedCartoons.length}');
        return validatedCartoons;
        
      } else {
        throw Exception('Çizgi filmler yüklenemedi: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('API Hatası: $e');
      throw Exception('Bağlantı hatası: $e');
    }
  }

  Future<CartoonsModel> _validateImage(CartoonsModel cartoon) async {
    try {
      // URL geçerli mi?
      final isValidUrl = _isPotentiallyValidUrl(cartoon.image);
      
      // URL geçerliyse ve erişilebilirse olduğu gibi bırak
      if (isValidUrl && await ImageValidator.isValid(cartoon.image!)) {
        return cartoon;
      }
      
      // Geçersiz URL veya erişilemeyen resim için asset kullan
      return cartoon.copyWith(image: _placeholderPath);
    } catch (e) {
      debugPrint('Resim doğrulama hatası: ${cartoon.title} - $e');
      return cartoon.copyWith(image: _placeholderPath);
    }
  }
  

  bool _isPotentiallyValidUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    return url.startsWith('http://') || url.startsWith('https://');
  }
  
}