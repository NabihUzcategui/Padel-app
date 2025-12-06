import 'dart:math';
import '../../domain/entities/coach_advice.dart';
import '../../domain/entities/match_analysis.dart';
import '../../domain/services/ai_coach_service.dart';

/// Servicio de coach inteligente con reglas predefinidas
/// Puede funcionar sin conexión y proporciona consejos contextuales
class SmartCoachService implements AICoachService {
  final Random _random = Random();

  @override
  Future<CoachAdvice> getAdvice(MatchAnalysis analysis) async {
    // Simular un pequeño delay para hacerlo más realista
    await Future.delayed(const Duration(milliseconds: 500));

    // Si está perdiendo, priorizar mensajes de motivación
    if (analysis.isLosing && !analysis.isClose) {
      return _getMotivationalAdvice(analysis);
    }

    // Si está en un momento crítico, dar consejos estratégicos
    if (analysis.criticalMoment != null) {
      return _getCriticalMomentAdvice(analysis);
    }

    // Si está en tie-break, dar consejos específicos
    if (analysis.isTieBreak) {
      return _getTieBreakAdvice(analysis);
    }

    // Si está en deuce o ventaja, dar consejos tácticos
    if (analysis.isDeuce || analysis.isAdvantage) {
      return _getTacticalAdvice(analysis);
    }

    // Consejos generales según la situación
    if (analysis.isClose) {
      return _getCloseMatchAdvice(analysis);
    }

    if (analysis.isWinning) {
      return _getWinningAdvice(analysis);
    }

    // Consejo general
    return _getGeneralAdvice(analysis);
  }

  CoachAdvice _getMotivationalAdvice(MatchAnalysis analysis) {
    final messages = [
      '¡No te rindas! Los partidos se ganan punto a punto. Mantén la concentración.',
      'Recuerda: cada punto es una nueva oportunidad. Sigue luchando.',
      'Los mejores jugadores se destacan en los momentos difíciles. ¡Tú puedes!',
      'El partido no termina hasta el último punto. Mantén la actitud positiva.',
      'Aprovecha cada error del rival. La presión puede hacer que falle.',
      'Confía en tu juego. Has llegado hasta aquí por una razón.',
      'Los comebacks son posibles. Mantén la calma y juega tu mejor padel.',
      'No pienses en el marcador, piensa en el siguiente punto. Uno a la vez.',
    ];

    return CoachAdvice(
      message: messages[_random.nextInt(messages.length)],
      type: AdviceType.motivation,
      title: '💪 Mantén la actitud',
    );
  }

  CoachAdvice _getCriticalMomentAdvice(MatchAnalysis analysis) {
    switch (analysis.criticalMoment) {
      case 'match_point':
        if (analysis.isLosing) {
          return CoachAdvice(
            message: '¡Momento crucial! Si es tu match point, juega seguro y al centro. Si es del rival, presiona y busca el error.',
            type: AdviceType.warning,
            title: '🎯 Match Point',
          );
        } else {
          return CoachAdvice(
            message: '¡Estás a un punto de ganar! Mantén la calma, respira y juega tu mejor punto. No te apresures.',
            type: AdviceType.strategy,
            title: '🏆 Match Point',
          );
        }
      case 'set_point':
        if (analysis.isLosing) {
          return CoachAdvice(
            message: 'Set point en contra. Juega agresivo pero controlado. Busca el error del rival con presión constante.',
            type: AdviceType.strategy,
            title: '⚡ Set Point',
          );
        } else {
          return CoachAdvice(
            message: 'Set point a favor. Juega seguro, al centro y espera el error. No te arriesgues innecesariamente.',
            type: AdviceType.strategy,
            title: '⚡ Set Point',
          );
        }
      case 'break_point':
        return CoachAdvice(
          message: 'Break point en contra. Primero el saque, luego la red. Juega seguro y no regales puntos.',
          type: AdviceType.warning,
          title: '⚠️ Break Point',
        );
      case 'game_point':
        return CoachAdvice(
          message: 'Game point a favor. Cierra el juego con un saque sólido. No te relajes.',
          type: AdviceType.strategy,
          title: '🎯 Game Point',
        );
      case 'advantage':
        if (analysis.match.currentGameScore.player1Points == 4) {
          return CoachAdvice(
            message: 'Ventaja a favor. Un punto más y ganas el juego. Mantén la presión y juega al centro.',
            type: AdviceType.strategy,
            title: '✅ Ventaja',
          );
        } else {
          return CoachAdvice(
            message: 'Ventaja en contra. Defiende bien, busca el deuce. No te des por vencido.',
            type: AdviceType.warning,
            title: '⚠️ Ventaja en contra',
          );
        }
      case 'deuce':
        return CoachAdvice(
          message: 'Deuce. Cada punto cuenta doble. Juega seguro, al centro, y espera el error del rival.',
          type: AdviceType.strategy,
          title: '⚖️ Deuce',
        );
      default:
        return _getGeneralAdvice(analysis);
    }
  }

  CoachAdvice _getTieBreakAdvice(MatchAnalysis analysis) {
    final score = analysis.match.currentGameScore;
    final difference = score.player1Points - score.player2Points;

    if (difference < 0) {
      return CoachAdvice(
        message: 'Tie-break: Estás abajo. Cada punto es crucial. Juega seguro, minimiza errores y espera oportunidades.',
        type: AdviceType.strategy,
        title: '🔀 Tie-Break',
      );
    } else if (difference > 0) {
      return CoachAdvice(
        message: 'Tie-break: Llevas ventaja. Mantén la presión, no te relajes. Cada punto cuenta.',
        type: AdviceType.strategy,
        title: '🔀 Tie-Break',
      );
    } else {
      return CoachAdvice(
        message: 'Tie-break empatado. Juega punto a punto, mantén la calma. El que comete menos errores gana.',
        type: AdviceType.strategy,
        title: '🔀 Tie-Break',
      );
    }
  }

  CoachAdvice _getTacticalAdvice(MatchAnalysis analysis) {
    final tips = [
      'En deuce, juega al centro y espera el error. No te arriesgues innecesariamente.',
      'Mantén la presión con saques profundos. No dejes que el rival se acomode.',
      'Varía tus saques: corto, largo, al cuerpo. Mantén al rival adivinando.',
      'En la red, posición y anticipación. Cubre los ángulos y mantén la calma.',
    ];

    return CoachAdvice(
      message: tips[_random.nextInt(tips.length)],
      type: AdviceType.tip,
      title: '💡 Consejo táctico',
    );
  }

  CoachAdvice _getCloseMatchAdvice(MatchAnalysis analysis) {
    final tips = [
      'Partido muy igualado. Cada punto importa. Mantén la concentración y no te relajes.',
      'En partidos cerrados, el que comete menos errores gana. Juega seguro en los puntos clave.',
      'Confía en tu juego. Estás jugando bien, solo necesitas mantener el nivel.',
      'Varía tu juego: profundidad, ángulos, velocidad. No seas predecible.',
    ];

    return CoachAdvice(
      message: tips[_random.nextInt(tips.length)],
      type: AdviceType.tip,
      title: '⚖️ Partido cerrado',
    );
  }

  CoachAdvice _getWinningAdvice(MatchAnalysis analysis) {
    final tips = [
      'Llevas ventaja. No te relajes, mantén la intensidad y cierra el partido.',
      'Sigue haciendo lo que estás haciendo bien. No cambies una estrategia ganadora.',
      'Aprovecha el momento. Mantén la presión y no dejes que el rival se recupere.',
      'Confianza sí, relajación no. Termina el partido con la misma intensidad.',
    ];

    return CoachAdvice(
      message: tips[_random.nextInt(tips.length)],
      type: AdviceType.tip,
      title: '✅ Llevas ventaja',
    );
  }

  CoachAdvice _getGeneralAdvice(MatchAnalysis analysis) {
    final tips = [
      'Mantén la calma y respira entre puntos. La concentración es clave.',
      'Juega cada punto como si fuera el último. No pienses en el marcador.',
      'Varía tus saques y mantén al rival adivinando. La variación es tu aliada.',
      'En la red, posición y anticipación. Lee el juego del rival.',
      'Comunícate bien con tu compañero. El trabajo en equipo marca la diferencia.',
      'Aprovecha los errores del rival. La presión constante genera fallos.',
      'Mantén la pelota en juego. No todos los puntos tienen que ser ganadores.',
      'Confía en tu técnica. Has entrenado para esto.',
    ];

    return CoachAdvice(
      message: tips[_random.nextInt(tips.length)],
      type: AdviceType.tip,
      title: '💡 Consejo del coach',
    );
  }
}

