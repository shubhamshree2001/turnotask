import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:turnotask/data/theme/app_theme.dart';
import 'package:turnotask/services/get_it_service.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState()) {
    getThemeFromStorage();
  }

  void setThemeMode(ThemeModeOption mode) {
    turnoStorage.setThemeMode(mode);
    ThemeData themeData;
    switch (mode) {
      case ThemeModeOption.dark:
        themeData = AppTheme.darkTheme;
        break;
      case ThemeModeOption.light:
        themeData = AppTheme.lightTheme;
        break;
      case ThemeModeOption.system:
      default:
        // Use system setting
        final brightness =
            SchedulerBinding.instance.platformDispatcher.platformBrightness;
        themeData = brightness == Brightness.dark
            ? AppTheme.darkTheme
            : AppTheme.lightTheme;
        break;
    }

    emit(state.copyWith(themeMode: mode, theme: themeData));
  }

  Future<void> getThemeFromStorage() async {
    final mode = await turnoStorage.getThemeMode();
    ThemeData themeData;

    switch (mode) {
      case ThemeModeOption.dark:
        themeData = AppTheme.darkTheme;
        break;
      case ThemeModeOption.light:
        themeData = AppTheme.lightTheme;
        break;
      case ThemeModeOption.system:
      default:
        final brightness =
            SchedulerBinding.instance.platformDispatcher.platformBrightness;
        themeData = brightness == Brightness.dark
            ? AppTheme.darkTheme
            : AppTheme.lightTheme;
        break;
    }

    emit(state.copyWith(themeMode: mode, theme: themeData));
  }

  ThemeMode mapThemeMode(ThemeModeOption option) {
    switch (option) {
      case ThemeModeOption.light:
        return ThemeMode.light;
      case ThemeModeOption.dark:
        return ThemeMode.dark;
      case ThemeModeOption.system:
      default:
        return ThemeMode.system;
    }
  }
}
