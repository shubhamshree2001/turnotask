import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turnotask/data/routes/app_routes.dart';
import 'package:turnotask/data/theme/app_colours.dart';
import 'package:turnotask/data/theme/app_theme.dart';
import 'package:turnotask/modules/home/bloc/home_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool hasNavigated = false;

  @override
  void initState() {
    super.initState();
    final HomeCubit homeCubit = context.read<HomeCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await insideInitCalledFnc(homeCubit);
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (!hasNavigated && mounted) {
        _navigate();
      }
    });
  }

  Future<void> insideInitCalledFnc(HomeCubit homeCubit) async {
    await Future.wait([homeCubit.loadAndCacheTask()]);
    if (!hasNavigated && mounted) {
      _navigate();
    }
  }

  void _navigate() async {
    if (hasNavigated || !mounted) return;
    hasNavigated = true;
    Navigator.pushReplacementNamed(context, Routes.homeScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.isLightTheme
          ? AppColors.bgColor
          : AppColors.bgColorDark,
      body: Center(
        child: Text(
          'TURNO TASK',
          style: context.textTheme.displayLarge?.withAdaptiveColor(
            context,
            lightColor: AppColors.colorNeutral900,
            darkColor: AppColors.colorNeutralDark900,
          ),
        ),
      ),
    );
  }
}
