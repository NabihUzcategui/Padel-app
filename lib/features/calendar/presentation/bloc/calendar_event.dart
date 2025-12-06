import 'package:equatable/equatable.dart';
import '../../domain/entities/game_event.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object> get props => [];
}

class LoadEvents extends CalendarEvent {}

class AddEvent extends CalendarEvent {
  final GameEvent event;

  const AddEvent(this.event);

  @override
  List<Object> get props => [event];
}
