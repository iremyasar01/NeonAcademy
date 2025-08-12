import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myneonacademyapp/constants/cartoon_api_constants.dart';
import 'package:myneonacademyapp/models/cartoons_model.dart';
import 'package:myneonacademyapp/widgets/image_validator.dart';

class CartoonApiService {
  static const String _baseUrl = CartoonApiConstants.baseUrl;

  Future<List<CartoonsModel>> fetchCartoons() async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/cartoons/cartoons2D"),
        headers: {'User-Agent': 'MyNeonAcademyApp/1.0'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        // 1. Önce ID'ye göre filtrele (23 ve altı)
        final filteredCartoons = data
            .map((json) => CartoonsModel.fromJson(json))
            .where((cartoon) => cartoon.id != null && cartoon.id! <= 23)
            .toList();

        debugPrint('çizgi film sayısı: ${filteredCartoons.length}');

        // 2. Geçerli resim URL'lerini asenkron olarak doğrula
        final validCartoons = <CartoonsModel>[];
        
        // Paralel işlem için batch'ler halinde kontrol et
        for (int i = 0; i < filteredCartoons.length; i += 10) {
          final end = (i + 10 < filteredCartoons.length) 
              ? i + 10 
              : filteredCartoons.length;
          
          final batch = filteredCartoons.sublist(i, end);
          final futures = batch.map((c) => _isValidCartoon(c));
          final results = await Future.wait(futures);
          
          for (int j = 0; j < batch.length; j++) {
            if (results[j]) {
              validCartoons.add(batch[j]);
            }
          }
          
          // Sunucu yükünü azaltmak için bekleme
          if (i + 10 < filteredCartoons.length) {
            await Future.delayed(const Duration(milliseconds: 100));
          }
        }
        
        debugPrint('Geçerli çizgi film sayısı: ${validCartoons.length}');
        return validCartoons;
        
      } else {
        throw Exception('Çizgi filmler yüklenemedi: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('API Hatası: $e');
      throw Exception('Bağlantı hatası: $e');
    }
  }

  Future<bool> _isValidCartoon(CartoonsModel cartoon) async {
    if (!_isPotentiallyValidUrl(cartoon.image)) {
      return false;
    }

    try {
      return await ImageValidator.isValid(cartoon.image!);
    } catch (e) {
      debugPrint('Resim doğrulama hatası: ${cartoon.image} - $e');
      return false;
    }
  }

  bool _isPotentiallyValidUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    
    try {
      final uri = Uri.parse(url);
      return uri.isAbsolute && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }
}