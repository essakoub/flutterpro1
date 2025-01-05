import 'dart:convert';
import 'package:http/http.dart' as http;

class BackendService {
  final String baseUrl;

  BackendService(this.baseUrl);

  Future<void> saveHighScore(int score) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/store_highscore.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'score': score}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to save high score: ${response.body}');
      }
    } catch (error) {
      print('Error saving high score: $error');
    }
  }

  Future<int> getHighScore() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/store_highscore.php'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          return data['highScore'] ?? 0;
        } else {
          throw Exception('Error from server: ${data['message']}');
        }
      } else {
        throw Exception('Failed to fetch high score: ${response.body}');
      }
    } catch (error) {
      print('Error fetching high score: $error');
      return 0;
    }
  }
}
