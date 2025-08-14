import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myneonacademyapp/constants/message_api_constants.dart';
import '../models/message_model.dart';

class MessageApiService {
  static const String _baseUrl = MessageApiConstants.MBASEURL;

  // Optimize header seti
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
      'Pragma': 'no-cache',
      'Cache-Control': 'no-cache',
    };
    //403 hatasını engellemek için Cloudflare engelliyo bot sanıyo.
    //accept: json istiyom türkçe dil desteğiyle
  
  }
//apiden istek al
  Future<List<Message>> fetchMessages() async {
    final uri = Uri.parse("$_baseUrl?postId=1");
    
    final headers = {
      ..._headers,
      'Host': uri.host,
      'Origin': 'https://${uri.host}',
    };

    final response = await http.get(uri, headers: headers);

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
      throw Exception('JSONPlaceholder: Mesajlar yüklenemedi. Status: ${response.statusCode}');
    }
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
    
    return response.statusCode == 201;
  }
}