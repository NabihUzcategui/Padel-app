import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/match.dart';

abstract class MatchRepository {
  Future<Either<Failure, void>> saveMatch(Match match);
  Future<Either<Failure, List<Match>>> getMatches();
}
