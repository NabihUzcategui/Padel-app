import 'package:equatable/equatable.dart';
import '../../../match/domain/entities/match.dart';

class MatchAnalysis extends Equatable {
  final Match match;
  final bool isLosing;
  final bool isWinning;
  final bool isClose;
  final int setsDifference;
  final int gamesDifference;
  final bool isTieBreak;
  final bool isDeuce;
  final bool isAdvantage;
  final String? criticalMoment; // 'set_point', 'match_point', 'break_point', etc.

  const MatchAnalysis({
    required this.match,
    required this.isLosing,
    required this.isWinning,
    required this.isClose,
    required this.setsDifference,
    required this.gamesDifference,
    required this.isTieBreak,
    required this.isDeuce,
    required this.isAdvantage,
    this.criticalMoment,
  });

  @override
  List<Object?> get props => [
        match,
        isLosing,
        isWinning,
        isClose,
        setsDifference,
        gamesDifference,
        isTieBreak,
        isDeuce,
        isAdvantage,
        criticalMoment,
      ];
}


