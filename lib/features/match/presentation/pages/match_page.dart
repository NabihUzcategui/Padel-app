import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/player.dart';
import '../bloc/match_bloc.dart';
import '../bloc/match_event.dart';
import '../bloc/match_state.dart';
import '../widgets/score_card.dart';
import '../../../coach/presentation/widgets/coach_dialog.dart';
import '../../../coach/domain/services/match_analyzer.dart';
import '../../../coach/presentation/bloc/coach_bloc.dart';

class MatchPage extends StatelessWidget {
  const MatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<MatchBloc>()
            ..add(
              const StartMatch(
                player1: Player(id: '1', name: 'Tú'),
                player2: Player(id: '2', name: 'Rival'),
              ),
            ),
        ),
        BlocProvider(create: (_) => sl<CoachBloc>()),
      ],
      child: const MatchView(),
    );
  }
}

class MatchView extends StatelessWidget {
  const MatchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<MatchBloc, MatchState>(
          builder: (context, state) {
            if (state is MatchInProgress) {
              final match = state.match;
              final currentSetIndex = match.sets.length - 1;
              final currentSet = match.sets.last;

              return Column(
                children: [
                  // Header with Gradient
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 24,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withValues(alpha: 0.8),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).primaryColor.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.sports_tennis,
                              color: Colors.white.withValues(alpha: 0.9),
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Partido en Vivo',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Set ${currentSetIndex + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Container(
                                width: 1,
                                height: 16,
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                              const SizedBox(width: 16),
                              const Text(
                                'Al mejor de 3',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Set Score Summary with Card
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: Theme.of(
                            context,
                          ).primaryColor.withValues(alpha: 0.2),
                          width: 2,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.emoji_events_outlined,
                              color: Theme.of(context).primaryColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _buildSetScoreString(match.sets),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Score Cards
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          ScoreCard(
                            player: match.player1,
                            score: match.currentGameScore.player1Label,
                            games: currentSet.player1Games,
                            color: const Color(0xFF2563EB),
                            onPointScored: () {
                              context.read<MatchBloc>().add(
                                const PointScored(1),
                              );
                            },
                          ),
                          const SizedBox(width: 16),
                          ScoreCard(
                            player: match.player2,
                            score: match.currentGameScore.player2Label,
                            games: currentSet.player2Games,
                            color: const Color(0xFFF43F5E),
                            onPointScored: () {
                              context.read<MatchBloc>().add(
                                const PointScored(2),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Actions
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final analysis = MatchAnalyzer.analyze(match);
                              final coachBloc = context.read<CoachBloc>();
                              showDialog(
                                context: context,
                                builder: (context) => CoachDialog(
                                  analysis: analysis,
                                  coachBloc: coachBloc,
                                ),
                              );
                            },
                            icon: const Icon(Icons.psychology),
                            label: const Text('Análisis Coach IA'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8B5CF6),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            context.read<MatchBloc>().add(ResetMatch());
                            context.read<MatchBloc>().add(
                              const StartMatch(
                                player1: Player(id: '1', name: 'Tú'),
                                player2: Player(id: '2', name: 'Rival'),
                              ),
                            );
                          },
                          child: const Text(
                            'Reiniciar Partido',
                            style: TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else if (state is MatchFinished) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      size: 80,
                      color: Colors.amber,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      '¡Partido Finalizado!',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Ganador: ${state.match.winnerId == state.match.player1.id ? state.match.player1.name : state.match.player2.name}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        context.read<MatchBloc>().add(
                          const StartMatch(
                            player1: Player(id: '1', name: 'Tú'),
                            player2: Player(id: '2', name: 'Rival'),
                          ),
                        );
                      },
                      child: const Text('Nuevo Partido'),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  String _buildSetScoreString(List<dynamic> sets) {
    // Helper to show previous sets score
    // e.g. "6-4, 2-6"
    if (sets.isEmpty) return '0 - 0';

    return sets
        .map((set) => '${set.player1Games}-${set.player2Games}')
        .join(', ');
  }
}
