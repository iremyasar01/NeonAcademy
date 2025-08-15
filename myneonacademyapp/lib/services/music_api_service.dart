import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:myneonacademyapp/models/track_model.dart';

class MusicApiService {
  final Dio _dio = Dio();

  MusicApiService() {
    // Dio ayarları
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    
    // Debug için interceptor ekle
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }

  Future<List<Track>> searchTracks(String term) async {
    try {
      debugPrint('🔍 Arama yapılıyor: $term');
      
      final response = await _dio.get(
        'https://itunes.apple.com/search',
        queryParameters: {
          'term': term,
          'country': 'US',
          'media': 'music',
          'entity': 'song', // Sadece şarkıları getir
          'limit': 20,
        },
      );

      debugPrint('📡 Response Status: ${response.statusCode}');
      debugPrint('📊 Response Data Type: ${response.data.runtimeType}');

      if (response.statusCode == 200 && response.data != null) {
        // Eğer response String ise JSON'a parse et
        dynamic data = response.data;
        if (data is String) {
          data = jsonDecode(data);
        }
        
        final Map<String, dynamic> jsonData = data as Map<String, dynamic>;
        final List results = jsonData['results'] ?? [];
        
        debugPrint('✅ API Yanıtı: ${results.length} sonuç bulundu');
        
        if (results.isEmpty) {
          debugPrint('⚠️ Sonuç bulunamadı. Arama terimi: $term');
          return [];
        }

        // İlk birkaç sonucu debug için yazdır
        for (int i = 0; i < (results.length > 3 ? 3 : results.length); i++) {
          final item = results[i];
          debugPrint('🎵 Track ${i + 1}: ${item['trackName']} - ${item['artistName']}');
          debugPrint('🔗 Preview URL: ${item['previewUrl']}');
        }

        final tracks = results
            .map((json) {
              try {
                return Track.fromJson(json);
              } catch (e) {
                debugPrint('❌ Track parse hatası: $e');
                debugPrint('📄 Hatalı JSON: $json');
                return null;
              }
            })
            .where((track) => track != null && track.previewUrl.isNotEmpty)
            .cast<Track>()
            .toList();

        debugPrint('🎯 Filtrelenmiş track sayısı: ${tracks.length}');
        return tracks;
      } else {
        throw Exception('API hatası - Status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('🚨 Dio Exception: ${e.type}');
      debugPrint('📄 Error Message: ${e.message}');
      debugPrint('📡 Response: ${e.response?.data}');
      
      String errorMessage;
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          errorMessage = 'Bağlantı zaman aşımı';
          break;
        case DioExceptionType.receiveTimeout:
          errorMessage = 'Veri alma zaman aşımı';
          break;
        case DioExceptionType.connectionError:
          errorMessage = 'İnternet bağlantısı hatası';
          break;
        default:
          errorMessage = 'Ağ hatası: ${e.message}';
      }
      
      throw Exception(errorMessage);
    } catch (e) {
      debugPrint('🚨 Genel hata: $e');
      throw Exception('Bilinmeyen hata: $e');
    }
  }
  // In MusicApiService class, add this method:
Future<List<Track>> getRecommendedTracks() async {
  try {
    // Using different search terms to get variety
    final terms = ['selena gomez', 'taylor swift', 'ariana grande'];
    final randomTerm = terms[DateTime.now().second % terms.length];
    return searchTracks(randomTerm);
  } catch (e) {
    debugPrint('Error getting recommended tracks: $e');
    return [];
  }
}
}