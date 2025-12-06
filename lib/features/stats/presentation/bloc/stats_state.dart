import 'package:equatable/equatable.dart';
import '../../domain/entities/player_stats.dart';

abstract class StatsState extends Equatable {
  const StatsState();

  @override
  List<Object> get props => [];
}

class StatsInitial extends StatsState {}

class StatsLoading extends StatsState {}

class StatsLoaded extends StatsState {
  final PlayerStats stats;

  const StatsLoaded(this.stats);

  @override
  List<Object> get props => [stats];
}

class StatsError extends StatsState {
  final String message;

  const StatsError(this.message);

  @override
  List<Object> get props => [message];
}
