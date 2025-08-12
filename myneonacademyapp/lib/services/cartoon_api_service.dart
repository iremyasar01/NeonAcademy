import 'dart:convert';
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
        final cartoons = data.map((json) => CartoonsModel.fromJson(json)).toList();

        print('Toplam çizgi film sayısı: ${cartoons.length}');
        
        // Geçerli URL'leri asenkron olarak doğrula
        final validCartoons = <CartoonsModel>[];
        
        // Paralel işlem için batch'lere böl (10'ar 10'ar kontrol et)
        for (int i = 0; i < cartoons.length; i += 10) {
          final int end = (i + 10 < cartoons.length) ? i + 10 : cartoons.length;
          final batch = cartoons.sublist(i, end);
          
          // Bu batch'teki tüm çizgi filmleri paralel olarak kontrol et
          final futures = batch.map((cartoon) => _isValidCartoon(cartoon));
          final results = await Future.wait(futures);
          
          // Geçerli olanları listeye ekle
          for (int j = 0; j < batch.length; j++) {
            if (results[j]) {
              validCartoons.add(batch[j]);
            }
          }
          
          // Sunucuya yük bindirmemek için küçük bir bekleme
          if (i + 10 < cartoons.length) {
            await Future.delayed(const Duration(milliseconds: 100));
          }
        }
        
        print('Geçerli çizgi film sayısı: ${validCartoons.length}');
        return validCartoons;
        
      } else {
        throw Exception('Çizgi filmler yüklenemedi: ${response.statusCode}');
      }
    } catch (e) {
      print('API Hatası: $e');
      throw Exception('Bağlantı hatası: $e');
    }
  }

  Future<bool> _isValidCartoon(CartoonsModel cartoon) async {
    // Temel URL doğrulama
    if (!_isPotentiallyValidUrl(cartoon.image)) {
      return false;
    }

    // HTTP status kodu kontrolü
    try {
      final isValid = await ImageValidator.isValid(cartoon.image!);
      if (!isValid) {
        print('Geçersiz resim URL: ${cartoon.image} - ${cartoon.title}');
      }
      return isValid;
    } catch (e) {
      print('Resim doğrulama hatası: ${cartoon.image} - $e');
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