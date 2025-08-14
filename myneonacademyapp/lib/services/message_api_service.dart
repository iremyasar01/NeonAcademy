import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myneonacademyapp/constants/message_api_constants.dart';
import '../models/message_model.dart';

class MessageApiService {
  static const String _baseUrl = MessageApiConstants.MBASEURL;

  // Ortak header ayarları
  Map<String, String> get _headers {
    return {
      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36',
      'Accept': 'application/json',
      'Accept-Language': 'tr-TR,tr;q=0.9,en-US;q=0.8,en;q=0.7',
      'Connection': 'keep-alive',
      'Referer': 'https://jsonplaceholder.typicode.com/',
      'Sec-Fetch-Dest': 'document',
      'Sec-Fetch-Mode': 'navigate',
      'Sec-Fetch-Site': 'same-origin',
    };
    //accept:json beklediğimi söylüyo
    //türkçe dil desteği (language)
    //istek tarayıcıdan geliyormuş gibi gösteriyo
  }

  Future<List<Message>> fetchMessages() async {
    final uri = Uri.parse("$_baseUrl?postId=1");
    
    // Cloudflare için kritik başlık kombinasyonu
    final headers = {
      ..._headers,
      'Host': uri.host,
      'Origin': 'https://${uri.host}',
    };

    final response = await http.get(uri, headers: headers);

    // 403 hatası durumunda alternatif endpoint deneme
    //yani  Cloudflare beni bot sanıyomuş.
    if (response.statusCode == 403) {
      return _tryAlternativeEndpoint();
    }

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data
          .map((msg) => Message(
                id: msg['id'],
                name: msg['name'],
                body: msg['body'],
                email: msg['email'],
                time: DateTime.now(),
              ))
          .toList();
    } else {
      throw Exception('Mesajlar yüklenemedi. Status: ${response.statusCode}');
    }
  }

  // 403 hatası durumunda kullanılacak alternatif endpoint
  Future<List<Message>> _tryAlternativeEndpoint() async {
    try {
      final fallbackUri = Uri.parse('https://dummyjson.com/comments?postId=1');
      final response = await http.get(fallbackUri, headers: _headers);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['comments'] as List)
            .map((msg) => Message(
                  id: msg['id'],
                  name: msg['user']['username'] ?? 'Ken',
                  body: msg['body'],
                  email: msg['user']['email'] ?? 'ken@example.com',
                  time: DateTime.now(),
                ))
            .toList();
      }
    } catch (e) {
      throw Exception('Alternatif API hatası: $e');
    }
    throw Exception('Tüm kaynaklar tükendi');
  }

  Future<bool> sendMessage(String name, String email, String body) async {
    final headers = {
      ..._headers,
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: headers,
      body: json.encode({
        'postId': 1,
        'name': name,
        'email': email,
        'body': body,
      }),
    );
   
    // 403 durumunda alternatif POST endpoint
    if (response.statusCode == 403) {
      return _sendViaAlternativeApi(name, email, body);
    }
    
    return response.statusCode == 201;
  }
  // Alternatif POST endpoint
  Future<bool> _sendViaAlternativeApi(String name, String email, String body) async {
    try {
      const altUrl = 'https://dummyjson.com/comments/add';
      final response = await http.post(
        Uri.parse(altUrl),
        headers: _headers,
        body: json.encode({
          'body': body,
          'postId': 1,
          'userId': 5, // Ken'in kullanıcı ID'si
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}