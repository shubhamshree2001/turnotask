import 'package:get_storage/get_storage.dart';
import 'package:turnotask/data/theme/bloc/theme_cubit.dart';

class AppStorage {
  final _box = GetStorage();

  Future<void> setNotificationTaskId(int notificationTaskId) async {
    await _box.write(TurnoStorageKeys.notificationTaskId, notificationTaskId);
  }

  Future<int?> getNotificationTaskId() async {
    int? val = await _box.read(TurnoStorageKeys.notificationTaskId);
    return val;
  }


  Future<void> setThemeMode(ThemeModeOption mode) async {
    await _box.write(TurnoStorageKeys.themeMode, mode.name);
  }

  Future<ThemeModeOption> getThemeMode() async {
    final storedValue = await _box.read(TurnoStorageKeys.themeMode);
    if (storedValue == null) return ThemeModeOption.system;
    return ThemeModeOption.values.firstWhere(
      (e) => e.name == storedValue,
      orElse: () => ThemeModeOption.system,
    );
  }

  Future<void> erase() async {
    await _box.erase();
  }

  Future<void> remove(String key) async {
    await _box.remove(key);
  }
}

class TurnoStorageKeys {
  static const themeMode = 'theme_mode';
  static const notificationTaskId = 'notificationTaskId';
}
