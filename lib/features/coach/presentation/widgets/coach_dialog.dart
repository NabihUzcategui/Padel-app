import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/coach_advice.dart';
import '../../domain/entities/match_analysis.dart';
import '../bloc/coach_bloc.dart';
import '../bloc/coach_event.dart';
import '../bloc/coach_state.dart';

class CoachDialog extends StatefulWidget {
  final MatchAnalysis analysis;
  final CoachBloc coachBloc;

  const CoachDialog({
    super.key,
    required this.analysis,
    required this.coachBloc,
  });

  @override
  State<CoachDialog> createState() => _CoachDialogState();
}

class _CoachDialogState extends State<CoachDialog> {
  @override
  void initState() {
    super.initState();
    // Disparar el evento para obtener el consejo solo una vez
    widget.coachBloc.add(GetAdvice(widget.analysis.match));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.coachBloc,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          child: BlocBuilder<CoachBloc, CoachState>(
            builder: (context, state) {
              if (state is CoachLoading) {
                return const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('El coach está analizando...'),
                  ],
                );
              }

              if (state is CoachError) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cerrar'),
                    ),
                  ],
                );
              }

              if (state is CoachReady && state.currentAdvice != null) {
                final advice = state.currentAdvice!;
                return _buildAdviceContent(context, advice, widget.analysis);
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAdviceContent(
    BuildContext context,
    CoachAdvice advice,
    MatchAnalysis analysis,
  ) {
    final color = _getAdviceColor(advice.type);
    final icon = _getAdviceIcon(advice.type);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    advice.title ?? 'Coach IA',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                  ),
                  Text(
                    _getSubtitle(analysis),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        const SizedBox(height: 20),
        
        // Advice Message
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Text(
            advice.message,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.5,
                ),
          ),
        ),
        const SizedBox(height: 20),

        // Match Status Summary
        if (analysis.isLosing || analysis.isClose)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  analysis.isLosing ? Icons.trending_down : Icons.balance,
                  color: Colors.orange,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    analysis.isLosing
                        ? 'Estás perdiendo el partido'
                        : 'Partido muy igualado',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.orange[800],
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: 20),

        // Actions
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                widget.coachBloc.add(GetAdvice(widget.analysis.match));
              },
              child: const Text('Nuevo consejo'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
              ),
              child: const Text('Entendido'),
            ),
          ],
        ),
      ],
    );
  }

  Color _getAdviceColor(AdviceType type) {
    switch (type) {
      case AdviceType.motivation:
        return Colors.orange;
      case AdviceType.strategy:
        return Colors.blue;
      case AdviceType.tip:
        return Colors.purple;
      case AdviceType.warning:
        return Colors.red;
    }
  }

  IconData _getAdviceIcon(AdviceType type) {
    switch (type) {
      case AdviceType.motivation:
        return Icons.favorite;
      case AdviceType.strategy:
        return Icons.psychology;
      case AdviceType.tip:
        return Icons.lightbulb;
      case AdviceType.warning:
        return Icons.warning;
    }
  }

  String _getSubtitle(MatchAnalysis analysis) {
    if (analysis.isTieBreak) {
      return 'Tie-break en curso';
    }
    if (analysis.criticalMoment != null) {
      switch (analysis.criticalMoment) {
        case 'match_point':
          return 'Match point';
        case 'set_point':
          return 'Set point';
        case 'break_point':
          return 'Break point';
        case 'game_point':
          return 'Game point';
        default:
          return 'Momento clave';
      }
    }
    return 'Análisis en tiempo real';
  }
}

