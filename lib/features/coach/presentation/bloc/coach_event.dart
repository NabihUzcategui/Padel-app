import 'package:equatable/equatable.dart';
import '../../../match/domain/entities/match.dart';

abstract class CoachEvent extends Equatable {
  const CoachEvent();

  @override
  List<Object> get props => [];
}

class AnalyzeMatch extends CoachEvent {
  final Match match;

  const AnalyzeMatch(this.match);

  @override
  List<Object> get props => [match];
}

class GetAdvice extends CoachEvent {
  final Match match;

  const GetAdvice(this.match);

  @override
  List<Object> get props => [match];
}

class ResetCoach extends CoachEvent {}


