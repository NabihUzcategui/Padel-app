import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

enum AppThemeMode { light, dark, system }

class ThemeState extends Equatable {
  final AppThemeMode themeMode;

  const ThemeState({this.themeMode = AppThemeMode.system});

  ThemeMode get materialThemeMode {
    switch (themeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  ThemeState copyWith({AppThemeMode? themeMode}) {
    return ThemeState(themeMode: themeMode ?? this.themeMode);
  }

  @override
  List<Object> get props => [themeMode];
}
