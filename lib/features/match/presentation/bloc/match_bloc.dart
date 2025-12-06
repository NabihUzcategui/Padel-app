import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/match.dart';
import 'match_event.dart';
import 'match_state.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  // Stack to keep history for Undo
  final List<Match> _history = [];

  MatchBloc() : super(MatchInitial()) {
    on<StartMatch>(_onStartMatch);
    on<PointScored>(_onPointScored);
    on<UndoLastPoint>(_onUndoLastPoint);
    on<ResetMatch>(_onResetMatch);
  }

  void _onStartMatch(StartMatch event, Emitter<MatchState> emit) {
    final match = Match.initial(event.player1, event.player2);
    _history.clear();
    _history.add(match);
    emit(MatchInProgress(match));
  }

  void _onPointScored(PointScored event, Emitter<MatchState> emit) {
    if (state is! MatchInProgress) return;
    final currentMatch = (state as MatchInProgress).match;

    // Save current state to history before modifying
    _history.add(currentMatch);

    final newMatch = _calculateNewScore(currentMatch, event.playerIndex);

    if (newMatch.status == MatchStatus.finished) {
      emit(MatchFinished(newMatch));
    } else {
      emit(MatchInProgress(newMatch));
    }
  }

  void _onUndoLastPoint(UndoLastPoint event, Emitter<MatchState> emit) {
    if (_history.length > 1) {
      _history.removeLast(); // Remove current state
      final previousMatch = _history.last;
      emit(MatchInProgress(previousMatch));
    }
  }

  void _onResetMatch(ResetMatch event, Emitter<MatchState> emit) {
    _history.clear();
    emit(MatchInitial());
  }

  Match _calculateNewScore(Match match, int playerScored) {
    // Deep copy of sets to modify
    List<MatchSet> sets = List.from(match.sets);
    GameScore score = match.currentGameScore;

    int p1Points = score.player1Points;
    int p2Points = score.player2Points;

    bool isTieBreak = score.isTieBreak;

    if (isTieBreak) {
      // Tie-break logic (First to 7, win by 2)
      if (playerScored == 1) {
        p1Points++;
      } else {
        p2Points++;
      }

      if ((p1Points >= 7 || p2Points >= 7) &&
          (p1Points - p2Points).abs() >= 2) {
        // Set won via Tie-break
        return _winSet(match, sets, playerScored);
      } else {
        return _updateScore(
          match,
          sets,
          GameScore(
            player1Points: p1Points,
            player2Points: p2Points,
            isTieBreak: true,
          ),
        );
      }
    } else {
      // Standard Game Logic
      if (playerScored == 1) {
        if (p1Points == 3 && p2Points < 3) {
          // 40-0, 40-15, 40-30 -> Game
          return _winGame(match, sets, 1);
        } else if (p1Points == 3 && p2Points == 3) {
          // Deuce -> Advantage P1
          return _updateScore(
            match,
            sets,
            const GameScore(player1Points: 4, player2Points: 3),
          );
        } else if (p1Points == 4) {
          // Advantage P1 -> Game
          return _winGame(match, sets, 1);
        } else if (p1Points == 3 && p2Points == 4) {
          // Advantage P2 -> Deuce
          return _updateScore(
            match,
            sets,
            const GameScore(player1Points: 3, player2Points: 3),
          );
        } else {
          // 0->15, 15->30, 30->40
          return _updateScore(
            match,
            sets,
            GameScore(player1Points: p1Points + 1, player2Points: p2Points),
          );
        }
      } else {
        // Player 2 Scored (Mirror logic)
        if (p2Points == 3 && p1Points < 3) {
          return _winGame(match, sets, 2);
        } else if (p2Points == 3 && p1Points == 3) {
          return _updateScore(
            match,
            sets,
            const GameScore(player1Points: 3, player2Points: 4),
          );
        } else if (p2Points == 4) {
          return _winGame(match, sets, 2);
        } else if (p2Points == 3 && p1Points == 4) {
          return _updateScore(
            match,
            sets,
            const GameScore(player1Points: 3, player2Points: 3),
          );
        } else {
          return _updateScore(
            match,
            sets,
            GameScore(player1Points: p1Points, player2Points: p2Points + 1),
          );
        }
      }
    }
  }

  Match _updateScore(Match match, List<MatchSet> sets, GameScore newScore) {
    return Match(
      id: match.id,
      player1: match.player1,
      player2: match.player2,
      sets: sets,
      currentGameScore: newScore,
      status: match.status,
    );
  }

  Match _winGame(Match match, List<MatchSet> sets, int playerWonGame) {
    MatchSet currentSet = sets.last;
    int p1Games = currentSet.player1Games;
    int p2Games = currentSet.player2Games;

    if (playerWonGame == 1) {
      p1Games++;
    } else {
      p2Games++;
    }

    // Update current set
    sets[sets.length - 1] = MatchSet(
      player1Games: p1Games,
      player2Games: p2Games,
    );

    // Check Set Win Condition
    bool setWon = false;
    if ((p1Games == 6 && p2Games <= 4) || (p2Games == 6 && p1Games <= 4)) {
      setWon = true;
    } else if (p1Games == 7 || p2Games == 7) {
      setWon = true;
    }

    if (setWon) {
      // Check Match Win Condition (Best of 3)
      int p1Sets = 0;
      int p2Sets = 0;
      for (var s in sets) {
        if (s.player1Games > s.player2Games) {
          p1Sets++;
        } else {
          p2Sets++;
        }
      }

      if (p1Sets == 2 || p2Sets == 2) {
        return Match(
          id: match.id,
          player1: match.player1,
          player2: match.player2,
          sets: sets,
          currentGameScore: const GameScore(player1Points: 0, player2Points: 0),
          status: MatchStatus.finished,
          winnerId: p1Sets == 2 ? match.player1.id : match.player2.id,
        );
      } else {
        // Start new set
        sets.add(const MatchSet(player1Games: 0, player2Games: 0));
        return Match(
          id: match.id,
          player1: match.player1,
          player2: match.player2,
          sets: sets,
          currentGameScore: const GameScore(player1Points: 0, player2Points: 0),
          status: match.status,
        );
      }
    } else {
      // Check for Tie-break
      if (p1Games == 6 && p2Games == 6) {
        return Match(
          id: match.id,
          player1: match.player1,
          player2: match.player2,
          sets: sets,
          currentGameScore: const GameScore(
            player1Points: 0,
            player2Points: 0,
            isTieBreak: true,
          ),
          status: match.status,
        );
      }

      // Continue Set, Reset Game Score
      return Match(
        id: match.id,
        player1: match.player1,
        player2: match.player2,
        sets: sets,
        currentGameScore: const GameScore(player1Points: 0, player2Points: 0),
        status: match.status,
      );
    }
  }

  Match _winSet(Match match, List<MatchSet> sets, int playerWonSet) {
    // Tie-break win logic is slightly different, but results in set win.
    // We can reuse the logic by forcing the set games to 7-6 or 6-7
    MatchSet currentSet = sets.last;
    if (playerWonSet == 1) {
      sets[sets.length - 1] = MatchSet(
        player1Games: 7,
        player2Games: currentSet.player2Games,
      );
    } else {
      sets[sets.length - 1] = MatchSet(
        player1Games: currentSet.player1Games,
        player2Games: 7,
      );
    }

    // Check Match Win (Copy-paste logic from above, or refactor. For now copy-paste for safety)
    int p1Sets = 0;
    int p2Sets = 0;
    for (var s in sets) {
      if (s.player1Games > s.player2Games) {
        p1Sets++;
      } else {
        p2Sets++;
      }
    }

    if (p1Sets == 2 || p2Sets == 2) {
      return Match(
        id: match.id,
        player1: match.player1,
        player2: match.player2,
        sets: sets,
        currentGameScore: const GameScore(player1Points: 0, player2Points: 0),
        status: MatchStatus.finished,
        winnerId: p1Sets == 2 ? match.player1.id : match.player2.id,
      );
    } else {
      sets.add(const MatchSet(player1Games: 0, player2Games: 0));
      return Match(
        id: match.id,
        player1: match.player1,
        player2: match.player2,
        sets: sets,
        currentGameScore: const GameScore(player1Points: 0, player2Points: 0),
        status: match.status,
      );
    }
  }
}
