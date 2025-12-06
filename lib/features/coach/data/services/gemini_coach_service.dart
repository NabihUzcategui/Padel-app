import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/coach_advice.dart';
import '../../domain/entities/match_analysis.dart';
import '../../domain/services/ai_coach_service.dart';

/// Servicio de coach usando Google Gemini API
/// 
/// Para usar este servicio:
/// 1. Agrega la dependencia: http: ^1.1.0 en pubspec.yaml
/// 2. Obtén tu API key de Google AI Studio: https://makersuite.google.com/app/apikey
/// 3. Reemplaza SmartCoachService con GeminiCoachService en injection_container.dart
/// 
/// Ejemplo de uso:
/// ```dart
/// sl.registerLazySingleton<AICoachService>(
///   () => GeminiCoachService(apiKey: 'tu-api-key'),
/// );
/// ```
class GeminiCoachService implements AICoachService {
  final String apiKey;
  final String baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

  GeminiCoachService({required this.apiKey});

  @override
  Future<CoachAdvice> getAdvice(MatchAnalysis analysis) async {
    try {
      final prompt = _buildPrompt(analysis);
      
      final response = await http.post(
        Uri.parse('$baseUrl?key=$apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {
                  'text': prompt,
                },
              ],
            },
          ],
          'generationConfig': {
            'maxOutputTokens': 150,
            'temperature': 0.7,
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final message = data['candidates'][0]['content']['parts'][0]['text'].trim();
        
        return CoachAdvice(
          message: message,
          type: analysis.isLosing ? AdviceType.motivation : AdviceType.tip,
          title: '🤖 Coach IA',
        );
      } else {
        throw Exception('Error de API: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback a consejo genérico si falla la API
      return CoachAdvice(
        message: 'Mantén la concentración y juega tu mejor padel. ¡Tú puedes!',
        type: AdviceType.motivation,
        title: '💪 Coach',
      );
    }
  }

  String _buildPrompt(MatchAnalysis analysis) {
    final match = analysis.match;
    final currentSet = match.sets.last;
    final score = match.currentGameScore;
    
    String prompt = 'Eres un entrenador profesional de pádel. Analiza esta situación y da un consejo breve y motivador:\n\n';
    prompt += 'Situación del partido:\n';
    prompt += '- Sets: ${_getSetsScore(match.sets)}\n';
    prompt += '- Juegos actuales: ${currentSet.player1Games}-${currentSet.player2Games}\n';
    prompt += '- Puntos: ${score.player1Label}-${score.player2Label}\n';
    
    if (analysis.isLosing) {
      prompt += '- Estoy perdiendo el partido\n';
    } else if (analysis.isWinning) {
      prompt += '- Estoy ganando el partido\n';
    } else {
      prompt += '- Partido muy igualado\n';
    }
    
    if (analysis.isTieBreak) {
      prompt += '- Estamos en tie-break\n';
    }
    
    if (analysis.criticalMoment != null) {
      prompt += '- Momento crítico: ${analysis.criticalMoment}\n';
    }
    
    prompt += '\nDame un consejo breve y motivador (máximo 2 frases) en español para mejorar mi juego.';
    
    return prompt;
  }

  String _getSetsScore(List sets) {
    if (sets.isEmpty) return '0-0';
    return sets.map((s) => '${s.player1Games}-${s.player2Games}').join(', ');
  }
}


