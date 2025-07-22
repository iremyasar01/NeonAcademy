import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;


class JokeService {
  static Future<String> fetchRandomJoke() async {
    try {
      final response = await http.get(
        Uri.parse('https://icanhazdadjoke.com/'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['joke'] ?? "No joke found";
      }
      return _getBackupJoke();
    } catch (e) {
      return _getBackupJoke();
    }
  }

  static String _getBackupJoke() {
    final jokes = [
      "Why do programmers prefer dark mode? Because light attracts bugs.",
      "Why don't skeletons ride roller coasters? They don't have the stomach for it.",
      "Why do Java developers wear glasses? Because they don't see sharp.",
      "Why was the math book sad? Because it had too many problems.",
    ];
    return jokes[Random().nextInt(jokes.length)];
  }
}