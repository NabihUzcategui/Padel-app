import 'package:equatable/equatable.dart';
import '../../domain/entities/game_event.dart';

abstract class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object> get props => [];
}

class CalendarInitial extends CalendarState {}

class CalendarLoading extends CalendarState {}

class CalendarLoaded extends CalendarState {
  final List<GameEvent> events;

  const CalendarLoaded(this.events);

  @override
  List<Object> get props => [events];
}

class CalendarError extends CalendarState {
  final String message;

  const CalendarError(this.message);

  @override
  List<Object> get props => [message];
}
