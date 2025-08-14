import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myneonacademyapp/constants/message_api_constants.dart';
import '../models/message_model.dart';

class MessageApiService {
  static const String _baseUrl = MessageApiConstants.MBASEURL;

  Future<List<Message>> fetchMessages() async {
    final response = await http.get(Uri.parse("$_baseUrl?postId=1"));
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
      throw Exception('Mesajlar yüklenemedi');
    }
  }

  Future<bool> sendMessage(String name, String email, String body) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
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