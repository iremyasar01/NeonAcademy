import 'package:http/http.dart' as http;

class ImageValidator {
  static final Set<String> _badUrls = {};

  static Future<bool> isValid(String url) async {
    // Önceden bilinen hatalı URL'ler
    if (_badUrls.contains(url)) return false;
    
    try {
      final response = await http.head(Uri.parse(url));
      
      // 4xx ve 5xx hatalarını filtrele
      if (response.statusCode >= 400) {
        _badUrls.add(url);
        return false;
      }
      
      return true;
    } catch (e) {
      _badUrls.add(url);
      return false;
    }
  }
}