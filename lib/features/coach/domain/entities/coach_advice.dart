import 'package:equatable/equatable.dart';

enum AdviceType {
  tip,
  motivation,
  strategy,
  warning,
}

class CoachAdvice extends Equatable {
  final String message;
  final AdviceType type;
  final String? title;
  final DateTime timestamp;

  CoachAdvice({
    required this.message,
    required this.type,
    this.title,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  List<Object?> get props => [message, type, title, timestamp];
}

