import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:turnotask/data/theme/app_colours.dart';
import 'package:turnotask/data/values/text_styles.dart';

class AppTheme {
  static MaterialColor generateMaterialColor(Color color) {
    return MaterialColor(color.value, <int, Color>{
      50: _tintColor(color, 0.9),
      100: _tintColor(color, 0.8),
      200: _tintColor(color, 0.6),
      300: _tintColor(color, 0.4),
      400: _tintColor(color, 0.2),
      500: color,
      600: _shadeColor(color, 0.1),
      700: _shadeColor(color, 0.2),
      800: _shadeColor(color, 0.3),
      900: _shadeColor(color, 0.4),
    });
  }

  static Color _tintColor(Color color, double factor) => Color.fromRGBO(
    color.red + ((255 - color.red) * factor).round(),
    color.green + ((255 - color.green) * factor).round(),
    color.blue + ((255 - color.blue) * factor).round(),
    1,
  );

  static Color _shadeColor(Color color, double factor) => Color.fromRGBO(
    (color.red * (1 - factor)).round(),
    (color.green * (1 - factor)).round(),
    (color.blue * (1 - factor)).round(),
    1,
  );

  static final darkTheme = ThemeData(
    fontFamily: 'Inter',
    primaryColor: AppColors.primaryColorNew,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryColorNew,
      secondary: AppColors.colorNeutralDark300,
      surface: AppColors.backgroundDark,
      error: Colors.red,
    ),
    primarySwatch: generateMaterialColor(AppColors.primaryColorNew),
    brightness: Brightness.dark,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.colorNeutralDark700,
      selectionColor: AppColors.primaryColorNew,
      selectionHandleColor: AppColors.primaryColorNew,
    ),
    useMaterial3: true,
    textTheme: TextTheme(
      headlineSmall: TurnoTextStyle.turno20Inter600,
      headlineMedium: TurnoTextStyle.turno24Inter600,
      headlineLarge: TurnoTextStyle.turno30Inter600,
      displayLarge: TurnoTextStyle.turno18Inter600,
      labelLarge: TurnoTextStyle.turno16Inter600,
      bodySmall: TurnoTextStyle.turno14Inter400,
      displaySmall: TurnoTextStyle.turno12Inter600,
      titleSmall: TurnoTextStyle.turno10Inter400,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColorNew,
        textStyle: TurnoTextStyle.turno14Inter600,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.w)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.w),
        borderSide: const BorderSide(color: AppColors.colorNeutralDark200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.w),
        borderSide: const BorderSide(color: AppColors.primaryColorNew),
      ),
    ),
    scaffoldBackgroundColor: AppColors.black,
    //AppColors.backgroundDark,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryColorNew,
      titleTextStyle: TurnoTextStyle.turno18Inter600,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      elevation: 0,
      centerTitle: false,
      toolbarHeight: 72.h,
      scrolledUnderElevation: 0.0,
      iconTheme: const IconThemeData(color: AppColors.colorNeutralDark700),
    ),
  );

  static final lightTheme = ThemeData(
    fontFamily: 'Inter',
    primaryColor: AppColors.primaryColorNew,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryColorNew,
      secondary: AppColors.colorNeutral300,
      surface: AppColors.bgColor,
      error: Colors.red,
    ),
    primarySwatch: generateMaterialColor(AppColors.primaryColorNew),
    brightness: Brightness.light,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.colorNeutral700,
      selectionColor: AppColors.primaryColorNew,
      selectionHandleColor: AppColors.primaryColorNew,
    ),
    useMaterial3: true,
    textTheme: TextTheme(
      headlineSmall: TurnoTextStyle.turno20Inter600,
      headlineMedium: TurnoTextStyle.turno24Inter600,
      headlineLarge: TurnoTextStyle.turno30Inter600,
      displayLarge: TurnoTextStyle.turno18Inter600,
      labelLarge: TurnoTextStyle.turno16Inter600,
      bodySmall: TurnoTextStyle.turno14Inter600,
      displaySmall: TurnoTextStyle.turno12Inter600,
      titleSmall: TurnoTextStyle.turno10Inter400,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColorNew,
        textStyle: TurnoTextStyle.turno14Inter600,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.w)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.w),
        borderSide: const BorderSide(color: AppColors.colorNeutral200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.w),
        borderSide: const BorderSide(color: AppColors.primaryColorNew),
      ),
    ),
    scaffoldBackgroundColor: AppColors.bgColor,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.bgColor,
      titleTextStyle: TurnoTextStyle.turno18Inter600,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      elevation: 0,
      centerTitle: false,
      toolbarHeight: 72.h,
      scrolledUnderElevation: 0.0,
      iconTheme: const IconThemeData(color: AppColors.colorNeutral700),
    ),
  );
}

extension ThemeExtensions on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;

  ThemeData get theme => Theme.of(this);

  bool get isLightTheme => Theme.of(this).brightness == Brightness.light;

  bool get isDarkTheme => Theme.of(this).brightness == Brightness.dark;

  Color adaptiveColor(Color lightColor, Color darkColor) =>
      isDarkTheme ? darkColor : lightColor;

  Color get primaryColor => theme.primaryColor;

  Color get secondaryColor => theme.colorScheme.secondary;
}

extension CustomTextStyles on TextStyle {
  TextStyle withAdaptiveColor(
    BuildContext context, {
    required Color lightColor,
    required Color darkColor,
    double? letterSpacing,
    double? height,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? fontSize,
  }) {
    return copyWith(
      color: context.isDarkTheme ? darkColor : lightColor,
      letterSpacing: letterSpacing,
      height: height,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      fontSize: fontSize,
    );
  }

  TextStyle withSize(double size) => copyWith(fontSize: size);
}
