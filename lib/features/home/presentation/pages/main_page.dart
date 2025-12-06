import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/theme/theme_state.dart';
import '../../../match/presentation/pages/match_page.dart';
import '../../../calendar/presentation/pages/calendar_page.dart';
import '../../../stats/presentation/pages/stats_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const MatchPage(),
    const CalendarPage(),
    const StatsPage(),
    const Center(child: Text('Comunidad')), // Placeholder
  ];

  final List<String> _titles = [
    'Marcador',
    'Calendario',
    'Estadísticas',
    'Comunidad',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        actions: [
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return IconButton(
                icon: Icon(
                  state.themeMode == AppThemeMode.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
                onPressed: () {
                  context.read<ThemeCubit>().toggleTheme();
                },
                tooltip: 'Cambiar tema',
              );
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.sports_tennis),
            label: 'Marcador',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today),
            label: 'Calendario',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart),
            label: 'Estadísticas',
          ),
          NavigationDestination(icon: Icon(Icons.group), label: 'Comunidad'),
        ],
      ),
    );
  }
}
