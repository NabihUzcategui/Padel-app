import 'package:equatable/equatable.dart';

class PlayerStats extends Equatable {
  final int matchesPlayed;
  final int matchesWon;
  final List<int> weeklyActivity; // Games played per day (Mon-Sun)
  final double lobSuccessRate;
  final double smashSuccessRate;

  const PlayerStats({
    required this.matchesPlayed,
    required this.matchesWon,
    required this.weeklyActivity,
    required this.lobSuccessRate,
    required this.smashSuccessRate,
  });

  double get winRate =>
      matchesPlayed > 0 ? (matchesWon / matchesPlayed) * 100 : 0;

  @override
  List<Object> get props => [
    matchesPlayed,
    matchesWon,
    weeklyActivity,
    lobSuccessRate,
    smashSuccessRate,
  ];
}
