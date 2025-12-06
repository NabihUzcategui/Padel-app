import 'package:flutter/material.dart';
import '../../../match/domain/entities/match.dart';
import '../../../../injection_container.dart' as di;
import '../bloc/coach_bloc.dart';
import 'coach_dialog.dart';
import '../../domain/services/match_analyzer.dart';

class CoachFloatingButton extends StatelessWidget {
  final Match match;

  const CoachFloatingButton({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        final analysis = MatchAnalyzer.analyze(match);
        showDialog(
          context: context,
          builder: (context) =>
              CoachDialog(analysis: analysis, coachBloc: di.sl<CoachBloc>()),
        );
      },
      icon: const Icon(Icons.psychology),
      label: const Text('Coach IA'),
      backgroundColor: const Color(0xFF8B5CF6),
      foregroundColor: Colors.white,
    );
  }
}
  