
import 'package:turnotask/services/get_it_service.dart';

enum PrefKeys {
  notificationTaskID,
}

class PrefServices {
  void clear() {
    gSPrefs.clear();
  }

  void setNotificationTaskId(int? taskID) {
    gSPrefs.setInt(PrefKeys.notificationTaskID.name, taskID ?? -1);
  }

  int getNotificationTaskId() {
    return gSPrefs.getInt(PrefKeys.notificationTaskID.name) ?? -1;
  }

}
