part of 'theme_cubit.dart';

enum ThemeModeOption { system, light, dark }

class ThemeState extends Equatable {
  final ThemeModeOption themeMode;
  final ThemeData? theme;

  const ThemeState({this.themeMode = ThemeModeOption.system, this.theme});

  ThemeState copyWith({ThemeModeOption? themeMode, ThemeData? theme}) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      theme: theme ?? this.theme,
    );
  }

  @override
  List<Object?> get props => [themeMode, theme];
}
