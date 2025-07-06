import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turnotask/data/routes/app_routes.dart';
import 'package:turnotask/data/theme/app_theme.dart';
import 'package:turnotask/data/theme/bloc/theme_cubit.dart';
import 'package:turnotask/services/get_it_service.dart';

import 'data/cache/task_cache_manager.dart';
import 'modules/home/bloc/home_cubit.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await setup();
  const MethodChannel platform = MethodChannel('local_notifications');

  platform.setMethodCallHandler((call) async {
    if(Platform.isAndroid) {
      if (call.method == 'markDoneTapped') {
        int? taskId = call.arguments != null ? call.arguments['taskId'] : null;
        debugPrint('taskId from intent: $taskId');

        if (taskId == null || taskId == -1) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          taskId = prefs.getInt('flutter.notificationTaskID') ?? -1;
          debugPrint('taskId from prefs: $taskId');
        }

        if (taskId != -1) {
          await TaskCacheManager.markTaskAsCompletedById(taskId);
          final ctx = navigatorKey.currentContext;
          if (ctx != null) {
            await ctx.read<HomeCubit>().loadAndCacheTask();
          }
          gPrefs.clear();
        }
      }
      if (call.method == 'notificationTapped') {
        debugPrint('Notification body tapped');
      }
    }else{
      if (call.method == 'markDoneTapped') {
        final args = call.arguments as Map?;
        final taskId = args?['taskId'] as String?;
        debugPrint('iOS called markDoneTapped $taskId');
        if (taskId != null) {
          await TaskCacheManager.markTaskAsCompletedById(int.parse(taskId));
          final ctx = navigatorKey.currentContext;
          if (ctx != null) {
            await ctx.read<HomeCubit>().loadAndCacheTask();
          }
        }
      }
    }
    return;
  });
  await TaskCacheManager.handleBootReschedule();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const TurnoTaskApp());
}

class TurnoTaskApp extends StatelessWidget {
  const TurnoTaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => HomeCubit()),
        BlocProvider(create: (BuildContext context) => ThemeCubit()),
      ],
      child: ScreenUtilInit(
        minTextAdapt: false,
        splitScreenMode: false,
        designSize: const Size(360, 800),
        enableScaleText: () => false,
        builder: (context, child) {
          return BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              final ThemeCubit themeCubit = context.read<ThemeCubit>();
              return MaterialApp(
                builder: (context, child) {
                  return MediaQuery(
                    data: MediaQuery.of(
                      context,
                    ).copyWith(textScaler: const TextScaler.linear(1)),
                    child: child!,
                  );
                },
                navigatorKey: navigatorKey,
                title: 'Turno Task',
                debugShowCheckedModeBanner: false,
                themeMode: themeCubit.mapThemeMode(state.themeMode),
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                initialRoute: Routes.splashScreen,
                routes: Routes.routes,
              );
            },
          );
        },
      ),
    );
  }
}
