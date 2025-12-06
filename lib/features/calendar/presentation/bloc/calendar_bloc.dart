import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/game_event.dart';
import 'calendar_event.dart';
import 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final List<GameEvent> _events = [];

  CalendarBloc() : super(CalendarInitial()) {
    on<LoadEvents>(_onLoadEvents);
    on<AddEvent>(_onAddEvent);
  }

  void _onLoadEvents(LoadEvents event, Emitter<CalendarState> emit) {
    emit(CalendarLoaded(List.from(_events)));
  }

  void _onAddEvent(AddEvent event, Emitter<CalendarState> emit) {
    _events.add(event.event);
    emit(CalendarLoaded(List.from(_events)));
  }
}
