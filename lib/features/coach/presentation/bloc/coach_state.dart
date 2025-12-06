import 'package:equatable/equatable.dart';
import '../../domain/entities/coach_advice.dart';
import '../../domain/entities/match_analysis.dart';

abstract class CoachState extends Equatable {
  const CoachState();

  @override
  List<Object> get props => [];
}

class CoachInitial extends CoachState {}

class CoachLoading extends CoachState {}

class CoachReady extends CoachState {
  final MatchAnalysis analysis;
  final CoachAdvice? currentAdvice;

  const CoachReady({
    required this.analysis,
    this.currentAdvice,
  });

  @override
  List<Object> get props => [analysis, if (currentAdvice != null) currentAdvice!];

  CoachReady copyWith({
    MatchAnalysis? analysis,
    CoachAdvice? currentAdvice,
  }) {
    return CoachReady(
      analysis: analysis ?? this.analysis,
      currentAdvice: currentAdvice ?? this.currentAdvice,
    );
  }
}

class CoachError extends CoachState {
  final String message;

  const CoachError(this.message);

  @override
  List<Object> get props => [message];
}

