import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turnotask/data/utils/app_storage.dart';
import 'package:turnotask/data/utils/prefs_storage.dart';
import 'package:turnotask/modules/home/model/task_model.dart';
import 'package:turnotask/modules/home/model/task_respnse_hive_adaptor.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  await _initSharedPref();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('tasksBox');
  getIt.registerLazySingleton(() => AppStorage());
  getIt.registerLazySingleton(() => PrefServices());
}
Future<void> _initSharedPref() async {
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPref);
}

/// Global Getters
AppStorage get turnoStorage => getIt.get<AppStorage>();

SharedPreferences get gSPrefs => getIt.get<SharedPreferences>();

PrefServices get gPrefs => getIt.get<PrefServices>();
