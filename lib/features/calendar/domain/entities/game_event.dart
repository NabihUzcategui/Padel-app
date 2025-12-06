import 'package:equatable/equatable.dart';

class GameEvent extends Equatable {
  final String id;
  final String title;
  final DateTime date;
  final String location;
  final List<String> playerIds;

  const GameEvent({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    this.playerIds = const [],
  });

  @override
  List<Object> get props => [id, title, date, location, playerIds];
}
