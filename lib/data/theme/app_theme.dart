import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:turnotask/data/theme/app_colours.dart';
import 'package:turnotask/data/values/text_styles.dart';

class AppTheme {
  static final darkTheme = ThemeData(
    fontFamily: 'Inter',
    primaryColor: AppColors.primaryDark50,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryDark400,
      secondary: AppColors.colorNeutralDark300,
      surface: AppColors.bgColorDark,
      error: Colors.red,
    ),
    primarySwatch:
        MaterialColor(AppColors.primaryDark400.toARGB32(), const <int, Color>{
          50: AppColors.primaryDark50,
          100: AppColors.primaryDark100,
          200: AppColors.primaryDark200,
          300: AppColors.primaryDark300,
          400: AppColors.primaryDark400,
          500: AppColors.primaryDark500,
          600: AppColors.primaryDark600,
          700: AppColors.primaryDark700,
          800: AppColors.primaryDark800,
          900: AppColors.primaryDark900,
        }),
    brightness: Brightness.dark,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.colorNeutralDark700,
      selectionColor: AppColors.primaryDark100,
      selectionHandleColor: AppColors.primaryDark300,
    ),
    useMaterial3: true,
    textTheme: TextTheme(
      displayLarge: TurnoTextStyle.aller18Inter600,
      labelLarge: TurnoTextStyle.aller16Inter600,
      bodySmall: TurnoTextStyle.aller14Inter400,
      displaySmall: TurnoTextStyle.aller12Inter400,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryDark400,
        textStyle: TurnoTextStyle.aller14Inter600,
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
        borderSide: const BorderSide(color: AppColors.primaryDark100),
      ),
    ),
    scaffoldBackgroundColor: AppColors.bgColorDark,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.bgColorDark,
      titleTextStyle: TurnoTextStyle.aller18Inter600,
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
    primaryColor: AppColors.primary400,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary400,
      secondary: AppColors.colorNeutral300,
      surface: AppColors.bgColor,
      error: Colors.red,
    ),
    primarySwatch:
        MaterialColor(AppColors.primary400.toARGB32(), const <int, Color>{
          50: AppColors.primary50,
          100: AppColors.primary100,
          200: AppColors.primary200,
          300: AppColors.primary300,
          400: AppColors.primary400,
          500: AppColors.primary500,
          600: AppColors.primary600,
          700: AppColors.primary700,
          800: AppColors.primary800,
          900: AppColors.primary900,
        }),
    brightness: Brightness.light,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.colorNeutral700,
      selectionColor: AppColors.primary100,
      selectionHandleColor: AppColors.primary300,
    ),
    useMaterial3: true,
    textTheme: TextTheme(
      displayLarge: TurnoTextStyle.aller18Inter600,
      labelLarge: TurnoTextStyle.aller16Inter600,
      bodySmall: TurnoTextStyle.aller14Inter400,
      displaySmall: TurnoTextStyle.aller12Inter400,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary400,
        textStyle: TurnoTextStyle.aller14Inter600,
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
        borderSide: const BorderSide(color: AppColors.primary100),
      ),
    ),
    scaffoldBackgroundColor: AppColors.bgColor,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.bgColor,
      titleTextStyle: TurnoTextStyle.aller18Inter600,
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
