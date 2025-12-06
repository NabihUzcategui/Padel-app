import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/player_stats.dart';
import 'stats_event.dart';
import 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  StatsBloc() : super(StatsInitial()) {
    on<LoadStats>(_onLoadStats);
  }

  void _onLoadStats(LoadStats event, Emitter<StatsState> emit) async {
    emit(StatsLoading());
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock Data
    final stats = const PlayerStats(
      matchesPlayed: 24,
      matchesWon: 16,
      weeklyActivity: [4, 3, 2, 6, 5, 9, 7], // Mon-Sun
      lobSuccessRate: 0.85,
      smashSuccessRate: 0.40,
    );

    emit(StatsLoaded(stats));
  }
}
