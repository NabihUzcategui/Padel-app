import '../../../match/domain/entities/match.dart';
import '../entities/match_analysis.dart';

class MatchAnalyzer {
  static MatchAnalysis analyze(Match match) {
    final currentSet = match.sets.last;
    final player1Games = currentSet.player1Games;
    final player2Games = currentSet.player2Games;
    final gamesDifference = player1Games - player2Games;

    // Calcular sets ganados
    int player1Sets = 0;
    int player2Sets = 0;
    for (var set in match.sets) {
      if (set.player1Games > set.player2Games) {
        player1Sets++;
      } else if (set.player2Games > set.player1Games) {
        player2Sets++;
      }
    }
    final setsDifference = player1Sets - player2Sets;

    // Determinar si está perdiendo (asumiendo que player1 es "Tú")
    final isLosing = setsDifference < 0 || 
                     (setsDifference == 0 && gamesDifference < 0) ||
                     (setsDifference == 0 && gamesDifference == 0 && 
                      match.currentGameScore.player1Points < match.currentGameScore.player2Points);
    
    final isWinning = setsDifference > 0 || 
                      (setsDifference == 0 && gamesDifference > 0) ||
                      (setsDifference == 0 && gamesDifference == 0 && 
                       match.currentGameScore.player1Points > match.currentGameScore.player2Points);

    final isClose = setsDifference == 0 && gamesDifference.abs() <= 1;

    // Detectar momentos críticos
    String? criticalMoment;
    final score = match.currentGameScore;
    
    if (score.isTieBreak) {
      if ((score.player1Points >= 6 && score.player1Points > score.player2Points) ||
          (score.player2Points >= 6 && score.player2Points > score.player1Points)) {
        criticalMoment = 'set_point';
      }
    } else {
      if (score.player1Points == 3 && score.player2Points < 3) {
        criticalMoment = 'game_point';
      } else if (score.player2Points == 3 && score.player1Points < 3) {
        criticalMoment = 'break_point';
      } else if (score.player1Points == 4 || score.player2Points == 4) {
        criticalMoment = 'advantage';
      } else if (score.player1Points == 3 && score.player2Points == 3) {
        criticalMoment = 'deuce';
      }
    }

    // Detectar set point o match point
    if (player1Games == 5 && player2Games <= 3 && gamesDifference >= 2) {
      criticalMoment = 'set_point';
    } else if (player2Games == 5 && player1Games <= 3 && gamesDifference <= -2) {
      criticalMoment = 'set_point';
    }

    if (player1Sets == 1 && player1Games >= 5 && gamesDifference >= 2) {
      criticalMoment = 'match_point';
    } else if (player2Sets == 1 && player2Games >= 5 && gamesDifference <= -2) {
      criticalMoment = 'match_point';
    }

    return MatchAnalysis(
      match: match,
      isLosing: isLosing,
      isWinning: isWinning,
      isClose: isClose,
      setsDifference: setsDifference,
      gamesDifference: gamesDifference,
      isTieBreak: score.isTieBreak,
      isDeuce: score.player1Points == 3 && score.player2Points == 3 && !score.isTieBreak,
      isAdvantage: score.player1Points == 4 || score.player2Points == 4,
      criticalMoment: criticalMoment,
    );
  }
}


