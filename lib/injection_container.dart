import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/theme_cubit.dart';
import 'features/match/presentation/bloc/match_bloc.dart';
import 'features/calendar/presentation/bloc/calendar_bloc.dart';
import 'features/stats/presentation/bloc/stats_bloc.dart';
import 'features/coach/presentation/bloc/coach_bloc.dart';
import 'features/coach/domain/services/ai_coach_service.dart';
import 'features/coach/data/services/smart_coach_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Core
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit(sl()));

  // Features - Match
  sl.registerFactory(() => MatchBloc());

  // Features - Calendar
  sl.registerFactory(() => CalendarBloc());

  // Features - Stats
  sl.registerFactory(() => StatsBloc());

  // Features - Coach
  sl.registerLazySingleton<AICoachService>(() => SmartCoachService());
  sl.registerFactory(() => CoachBloc(aiCoachService: sl()));
}
