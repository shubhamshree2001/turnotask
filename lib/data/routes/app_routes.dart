import 'package:flutter/material.dart';
import 'package:turnotask/modules/home/ui/screens/splash_screen.dart';
import 'package:turnotask/modules/home/ui/screens/home_screen.dart';

class Routes {
  static const initial = '/';
  static const splashScreen = '/splashScreen';
  static const homeScreen = '/homeScreen';

  static Map<String, WidgetBuilder> routes = {
    splashScreen: (context) => const SplashScreen(),
    homeScreen: (context) => const HomeScreen(),
  };
}
