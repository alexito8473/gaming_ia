import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get geminiApiKey {
    final key = dotenv.env['GEMINI_API_KEY'];

    if (key == null || key.isEmpty) {
      throw Exception('GEMINI_API_KEY no está configurada');
    }

    return key;
  }

  static String get geminiModel {
    return dotenv.env['GEMINI_MODEL'] ?? 'gemini-2.5-flash';
  }
}