import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/scan_result_model.dart';

class GeminiDiyTextService {
  final String _apiKey = '';
  final String _model = 'gemini-2.5-flash-lite';

  Future<ScanResult> getEcoInsight(String label) async {
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1/models/$_model:generateContent?key=$_apiKey',
    );

    final prompt = '''
You are an eco assistant. Analyze the object and return ONLY valid JSON with no markdown, no backticks, no extra text.

Object: $label

Return this exact JSON structure:
{
  "shortDescription": "One sentence describing what it is.",
  "isRecyclable": true,
  "confidence": 0.85,
  "recyclingInfo": "Short paragraph about whether/how it can be recycled.",
  "reuseIdeas": [
    "First reuse idea",
    "Second reuse idea",
    "Third reuse idea"
  ],
  "disposalAdvice": "Short disposal advice.",
  "ecoPoints": 15
}

Rules:
- confidence: float 0.0 to 1.0 based on how sure you are about the object
- ecoPoints: integer 5–30 based on eco-friendliness of proper disposal
- isRecyclable: boolean
- Return ONLY the JSON object, nothing else
''';

    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": prompt}
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
      throw Exception('API error ${response.statusCode}: ${response.body}');
    }

    final apiJson = jsonDecode(response.body);
    final rawText =
    apiJson['candidates'][0]['content']['parts'][0]['text'] as String;

    // Strip any accidental markdown fences
    final cleaned = rawText
        .replaceAll('```json', '')
        .replaceAll('```', '')
        .trim();

    final Map<String, dynamic> data = jsonDecode(cleaned);

    return ScanResult(
      objectName: label,
      shortDescription: data['shortDescription'] ?? '',
      confidence: (data['confidence'] as num?)?.toDouble() ?? 0.7,
      isRecyclable: data['isRecyclable'] as bool? ?? false,
      recyclingInfo: data['recyclingInfo'] ?? '',
      reuseIdeas: (data['reuseIdeas'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      disposalAdvice: data['disposalAdvice'] ?? '',
      ecoPoints: (data['ecoPoints'] as num?)?.toInt() ?? 10,
    );
  }
}