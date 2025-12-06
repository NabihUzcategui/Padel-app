import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeKey = 'app_theme_mode';
  final SharedPreferences prefs;

  ThemeCubit(this.prefs) : super(const ThemeState()) {
    _loadTheme();
  }

  void _loadTheme() async {
    final savedTheme = prefs.getString(_themeKey);
    if (savedTheme != null) {
      final themeMode = AppThemeMode.values.firstWhere(
        (mode) => mode.name == savedTheme,
        orElse: () => AppThemeMode.system,
      );
      emit(ThemeState(themeMode: themeMode));
    }
  }

  void setTheme(AppThemeMode mode) {
    prefs.setString(_themeKey, mode.name);
    emit(ThemeState(themeMode: mode));
  }

  void toggleTheme() {
    final newMode = state.themeMode == AppThemeMode.light
        ? AppThemeMode.dark
        : AppThemeMode.light;
    setTheme(newMode);
  }
}
