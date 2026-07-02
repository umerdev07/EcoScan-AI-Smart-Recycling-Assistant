import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class GeminiVisionService {
  final String _apiKey = ''; // 🔒 move to env/backend
  final String _model = 'gemini-2.5-flash-lite';

  Future<String> detectObjectBytes(Uint8List bytes) async {
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1/models/$_model:generateContent?key=$_apiKey',
    );

    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {
              "text":
              "Detect the main object in this image. Reply ONLY with the object name, nothing else."
            },
            {
              "inline_data": {
                "mime_type": "image/jpeg",
                "data": base64Encode(bytes),
              }
            }
          ]
        }
      ]
    });

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('Vision API error ${response.statusCode}: ${response.body}');
    }

    final json = jsonDecode(response.body);
    return json['candidates'][0]['content']['parts'][0]['text']
        ?.trim() ??
        'Unknown object';
  }
}