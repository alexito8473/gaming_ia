
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gaming_ia/domain/models/project.dart';
import 'package:gaming_ia/domain/repositories/abstract/game_repository.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';


class GeminiGameRepository implements GameRepository {
  final http.Client _client;

  GeminiGameRepository({
    http.Client? client,
  }) : _client = client ?? http.Client();

  @override
  Future<Project> generateGame({
    required String prompt,
  }) async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    final model = dotenv.env['GEMINI_MODEL'] ?? 'gemini-3.5-flash-lite';

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('No se ha encontrado GEMINI_API_KEY en .env');
    }

    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent',
    );

    final response = await _client
        .post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-goog-api-key': apiKey,
      },
      body: jsonEncode({
        'system_instruction': {
          'parts': [
            {
              'text': '''
Eres un desarrollador profesional especializado en videojuegos HTML5 para dispositivos móviles.

Tu trabajo es crear un videojuego COMPLETO, FUNCIONAL Y EJECUTABLE utilizando exclusivamente HTML, CSS y JavaScript.

OBJETIVO:
Crear un juego que funcione correctamente dentro de una aplicación Flutter mediante Android WebView.

REGLAS OBLIGATORIAS:

1. Devuelve un documento HTML completo, desde <!DOCTYPE html> hasta </html>.
2. Incluye todo el CSS dentro de <style>.
3. Incluye todo el JavaScript dentro de <script>.
4. No utilices librerías, frameworks, CDN, imágenes externas ni archivos externos.
5. El juego debe funcionar sin conexión a Internet.
6. Utiliza Canvas 2D cuando sea necesario para dibujar el juego.
7. Adapta el diseño al tamaño de pantalla del móvil.
8. Utiliza controles táctiles cuando el juego los necesite.
9. Los botones deben tener eventos funcionales y producir el resultado esperado.
10. El juego debe poder iniciarse desde su pantalla inicial.
11. Implementa las mecánicas principales de forma real, no mediante simples simulaciones visuales.
12. Evita funcionalidades que no puedas implementar correctamente.
13. No utilices localStorage ni sessionStorage.
14. No utilices APIs que no sean compatibles con Android WebView.
15. Evita código innecesariamente complejo y optimiza el rendimiento.
16. No dejes funciones vacías, comentarios que sustituyan código ni partes pendientes de implementar.
17. No utilices pseudocódigo ni fragmentos de ejemplo.
18. Todas las variables, funciones y elementos HTML utilizados deben estar definidos.
19. Comprueba que los identificadores utilizados en JavaScript existen en el HTML.
20. Gestiona correctamente los errores de JavaScript para evitar que el juego se quede bloqueado.

CONTROL DE COMPLEJIDAD:

- Prioriza un juego pequeño, completo y divertido antes que uno enorme e incompleto.
- Si el usuario solicita un juego muy complejo, crea una versión simplificada que conserve sus mecánicas principales.
- No intentes reproducir sistemas propios de videojuegos AAA si no puedes implementarlos correctamente.
- Divide internamente la lógica en funciones pequeñas y organizadas.
- Evita generar código repetido o innecesario.
- No añadas características que el usuario no haya solicitado si pueden comprometer el funcionamiento.

COMPATIBILIDAD MÓVIL:

- Utiliza correctamente window.innerWidth y window.innerHeight.
- Ajusta el Canvas al cambiar la orientación o el tamaño de pantalla.
- Evita el desplazamiento accidental de la página durante el juego.
- Los controles táctiles deben responder correctamente.
- Evita que los botones queden fuera de la pantalla.
- No dependas de teclado físico para las acciones principales en móviles.

COMPROBACIÓN FINAL OBLIGATORIA:

Antes de responder, revisa internamente que:

- El documento HTML está completo.
- Todas las etiquetas están correctamente cerradas.
- El JavaScript tiene sus llaves y paréntesis cerrados.
- No existen funciones sin implementar.
- No existen variables utilizadas sin definir.
- Los botones tienen sus eventos correspondientes.
- El juego puede iniciarse, jugarse y reiniciarse.
- No hay referencias a archivos externos.
- No has dejado el código cortado.

FORMATO DE RESPUESTA:

- Devuelve exclusivamente el código HTML.
- No utilices Markdown.
- No incluyas explicaciones.
- No escribas texto antes ni después del HTML.
- Comienza obligatoriamente por <!DOCTYPE html>.
- Termina obligatoriamente por </html>.
- Nunca sustituyas partes del código por puntos suspensivos.
- Nunca entregues solamente una parte del juego.

Si no puedes implementar alguna característica, simplifícala hasta conseguir una versión completamente funcional.

La prioridad absoluta es entregar un juego COMPLETO que funcione, no un juego enorme que esté incompleto.
'''
            }
          ]
        },
        'contents': [
          {
            'role': 'user',
            'parts': [
              {'text': prompt}
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.4,
          'maxOutputTokens': 16384,
        },
      }),
    )
        .timeout(const Duration(seconds: 180));
    if (response.statusCode != 200) {
      throw Exception(
        'Error Gemini ${response.statusCode}: ${response.body}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    final candidates = data['candidates'] as List<dynamic>?;

    if (candidates == null || candidates.isEmpty) {
      throw Exception('Gemini no ha devuelto ningún resultado.');
    }

    final candidate = candidates.first as Map<String, dynamic>;
    final content = candidate['content'] as Map<String, dynamic>?;
    final parts = content?['parts'] as List<dynamic>?;

    if (parts == null || parts.isEmpty) {
      throw Exception('La respuesta de Gemini está vacía.');
    }

    var html = parts
        .whereType<Map<String, dynamic>>()
        .where((part) => part['text'] != null)
        .map((part) => part['text'].toString())
        .join('\n')
        .trim();

    // Eliminar posibles bloques Markdown.
    html = html.replaceFirst(
      RegExp(r'^```(?:html)?\s*', caseSensitive: false),
      '',
    );

    html = html.replaceFirst(
      RegExp(r'\s*```$'),
      '',
    ).trim();

    // Validar HTML.
    final lowerHtml = html.toLowerCase();

    if (!lowerHtml.contains('<html') &&
        !lowerHtml.contains('<!doctype html')) {
      throw Exception('Gemini no ha generado HTML válido.');
    }

    // Añadir compatibilidad temporal con localStorage y sessionStorage.
    html = _injectStoragePolyfill(html);

    final now = DateTime.now();

    // Crear el proyecto.
    final project = Project(
      id: const Uuid().v4(),
      title: _generateTitle(prompt),
      description: prompt,
      prompt: prompt,
      gameCode: html,
      createdAt: now,
      updatedAt: now,
    );

    return project;
  }

  String _generateTitle(String prompt) {
    final cleanPrompt = prompt.trim().replaceAll(
      RegExp(r'\s+'),
      ' ',
    );

    if (cleanPrompt.length <= 40) {
      return cleanPrompt;
    }

    return '${cleanPrompt.substring(0, 37)}...';
  }

  String _injectStoragePolyfill(String html) {
    const storageFix = '''
<script>
(function() {
  function createStorage() {
    const data = {};

    return {
      getItem: function(key) {
        return Object.prototype.hasOwnProperty.call(data, key)
          ? data[key]
          : null;
      },
      setItem: function(key, value) {
        data[key] = String(value);
      },
      removeItem: function(key) {
        delete data[key];
      },
      clear: function() {
        Object.keys(data).forEach(function(key) {
          delete data[key];
        });
      },
      key: function(index) {
        return Object.keys(data)[index] || null;
      },
      get length() {
        return Object.keys(data).length;
      }
    };
  }

  try {
    Object.defineProperty(window, 'localStorage', {
      configurable: true,
      value: createStorage()
    });
  } catch (e) {
    console.error('Error localStorage:', e);
  }

  try {
    Object.defineProperty(window, 'sessionStorage', {
      configurable: true,
      value: createStorage()
    });
  } catch (e) {
    console.error('Error sessionStorage:', e);
  }
})();
</script>
''';

    final headRegex = RegExp(
      r'<head[^>]*>',
      caseSensitive: false,
    );

    final headMatch = headRegex.firstMatch(html);

    if (headMatch != null) {
      final position = headMatch.end;

      return html.substring(0, position) +
          storageFix +
          html.substring(position);
    }

    final htmlRegex = RegExp(
      r'<html[^>]*>',
      caseSensitive: false,
    );

    final htmlMatch = htmlRegex.firstMatch(html);

    if (htmlMatch != null) {
      final position = htmlMatch.end;

      return '${html.substring(0, position)}<head>$storageFix</head>${html.substring(position)}';
    }

    return html;
  }

  void dispose() {
    _client.close();
  }
}
