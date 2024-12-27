import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  // اطلاعات API
  final String apiKey = 'b12a39b621964269a0da06699f814f01';  // کلید API شما
  final String endpoint = 'https://marchv1.openai.azure.com/';  // Endpoint شما
  final String assistantId = 'asst_MTOT6iTFyXCuRGxDjO3h8rzS';  // Assistant ID شما

  // تابعی برای ارسال پیام و دریافت پاسخ از OpenAI
  Future<String> getChatResponse(String message) async {
    final url = Uri.parse('$endpoint/openai/deployments/$assistantId/completions?api-version=2023-10-01');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    final body = jsonEncode({
      "prompt": message,
      "max_tokens": 150,
      "temperature": 0.7,
      "top_p": 1.0,
      "frequency_penalty": 0.0,
      "presence_penalty": 0.0,
      "stop": ["\n"]
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['choices'][0]['text'];
        return text;
      } else {
        return 'Error: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}
