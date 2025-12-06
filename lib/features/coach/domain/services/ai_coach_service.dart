import '../entities/coach_advice.dart';
import '../entities/match_analysis.dart';

abstract class AICoachService {
  Future<CoachAdvice> getAdvice(MatchAnalysis analysis);
}


