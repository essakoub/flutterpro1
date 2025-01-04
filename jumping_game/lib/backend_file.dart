import 'dart:convert';
import 'package:http/http.dart' as http;

class BackendService {
  final String baseUrl;

  BackendService(this.baseUrl);

 
  Future<void> saveHighScore(String playerName, int score) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/save_highscore'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'playerName': playerName,
          'score': score,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to save high score: ${response.body}');
      }
    } catch (error) {
      print('Error saving high score: $error');
    }
  }
}
