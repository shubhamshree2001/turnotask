import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:turnotask/data/utils/app_storage.dart';
import 'package:turnotask/modules/home/model/task_model.dart';
import 'package:turnotask/modules/home/model/task_respnse_hive_adaptor.dart';


final getIt = GetIt.instance;

Future<void> setup() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('tasksBox');
  getIt.registerLazySingleton(() => AppStorage());
}



/// Global Getters
AppStorage get turnoStorage => getIt.get<AppStorage>();
