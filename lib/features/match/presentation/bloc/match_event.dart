import 'package:equatable/equatable.dart';
import '../../domain/entities/player.dart';

abstract class MatchEvent extends Equatable {
  const MatchEvent();

  @override
  List<Object> get props => [];
}

class StartMatch extends MatchEvent {
  final Player player1;
  final Player player2;

  const StartMatch({required this.player1, required this.player2});

  @override
  List<Object> get props => [player1, player2];
}

class PointScored extends MatchEvent {
  final int playerIndex; // 1 or 2

  const PointScored(this.playerIndex);

  @override
  List<Object> get props => [playerIndex];
}

class UndoLastPoint extends MatchEvent {}

class ResetMatch extends MatchEvent {}
