import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
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
    if (call.method == 'markDoneTapped') {
      debugPrint('✅main file Mark as Done tapped → do your update');
      // e.g. context.read<HomeCubit>().markTaskDoneFromNotification();
    }
    if (call.method == 'notificationTapped') {
      debugPrint('✅ Notification body tapped → maybe navigate');
      // e.g. navigate to task detail page
    }
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
