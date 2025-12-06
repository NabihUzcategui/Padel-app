import 'package:equatable/equatable.dart';
import 'player.dart';

enum MatchStatus { inProgress, finished }

class Match extends Equatable {
  final String id;
  final Player player1; // Or Team 1
  final Player player2; // Or Team 2
  final List<MatchSet> sets;
  final GameScore currentGameScore;
  final MatchStatus status;
  final String? winnerId;

  const Match({
    required this.id,
    required this.player1,
    required this.player2,
    required this.sets,
    required this.currentGameScore,
    this.status = MatchStatus.inProgress,
    this.winnerId,
  });

  // Factory for initial match
  factory Match.initial(Player p1, Player p2) {
    return Match(
      id: DateTime.now().toIso8601String(),
      player1: p1,
      player2: p2,
      sets: const [MatchSet(player1Games: 0, player2Games: 0)],
      currentGameScore: const GameScore(player1Points: 0, player2Points: 0),
    );
  }

  @override
  List<Object?> get props => [
    id,
    player1,
    player2,
    sets,
    currentGameScore,
    status,
    winnerId,
  ];
}

class MatchSet extends Equatable {
  final int player1Games;
  final int player2Games;

  const MatchSet({required this.player1Games, required this.player2Games});

  @override
  List<Object> get props => [player1Games, player2Games];
}

class GameScore extends Equatable {
  final int player1Points; // 0, 1, 2, 3 (0, 15, 30, 40)
  final int player2Points;
  final bool isTieBreak;

  const GameScore({
    required this.player1Points,
    required this.player2Points,
    this.isTieBreak = false,
  });

  String get player1Label => _getScoreLabel(player1Points);
  String get player2Label => _getScoreLabel(player2Points);

  String _getScoreLabel(int points) {
    if (isTieBreak) return points.toString();
    switch (points) {
      case 0:
        return '0';
      case 1:
        return '15';
      case 2:
        return '30';
      case 3:
        return '40';
      case 4:
        return 'AD'; // Advantage
      default:
        return '';
    }
  }

  @override
  List<Object> get props => [player1Points, player2Points, isTieBreak];
}
