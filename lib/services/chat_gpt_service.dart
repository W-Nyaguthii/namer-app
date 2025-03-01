import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatGPTService {
  final String apiKey =
      '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'; // Replace with your actual API key
  final String apiUrl = 'https://api.openai.com/v1/chat/completions';

  Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo', // or 'gpt-3.5-turbo'
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are a financial assistant helping young professionals.'
            },
            {'role': 'user', 'content': message},
          ],
          'max_tokens': 200,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return responseBody['choices'][0]['message']['content'];
      } else {
        return 'Error: ${response.body}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}
