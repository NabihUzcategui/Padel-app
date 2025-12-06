import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/services/ai_coach_service.dart';
import '../../domain/services/match_analyzer.dart';
import 'coach_event.dart';
import 'coach_state.dart';

class CoachBloc extends Bloc<CoachEvent, CoachState> {
  final AICoachService aiCoachService;

  CoachBloc({required this.aiCoachService}) : super(CoachInitial()) {
    on<AnalyzeMatch>(_onAnalyzeMatch);
    on<GetAdvice>(_onGetAdvice);
    on<ResetCoach>(_onResetCoach);
  }

  void _onAnalyzeMatch(AnalyzeMatch event, Emitter<CoachState> emit) {
    try {
      final analysis = MatchAnalyzer.analyze(event.match);
      emit(CoachReady(analysis: analysis));
    } catch (e) {
      emit(CoachError('Error al analizar el partido: $e'));
    }
  }

  Future<void> _onGetAdvice(GetAdvice event, Emitter<CoachState> emit) async {
    try {
      emit(CoachLoading());
      final analysis = MatchAnalyzer.analyze(event.match);
      final advice = await aiCoachService.getAdvice(analysis);
      
      if (state is CoachReady) {
        final currentState = state as CoachReady;
        emit(currentState.copyWith(
          analysis: analysis,
          currentAdvice: advice,
        ));
      } else {
        emit(CoachReady(analysis: analysis, currentAdvice: advice));
      }
    } catch (e) {
      emit(CoachError('Error al obtener consejo: $e'));
    }
  }

  void _onResetCoach(ResetCoach event, Emitter<CoachState> emit) {
    emit(CoachInitial());
  }
}


