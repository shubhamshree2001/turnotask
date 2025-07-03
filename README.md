# 📋 Task Manager App

A simple cross-platform **Task Manager** built with **Flutter**. Create, view, and manage tasks with **native local notifications** implemented using **platform channels** — **no third-party notification package** required!

---

## ✨ **Core Features**

✅ **Add Tasks**\
Create tasks with a title, description, and reminder time.

✅ **View Tasks**\
View all tasks with their scheduled reminders.

✅ **Native Local Notifications** *(No Package)*

- iOS: Uses **UNUserNotificationCenter** via **method channels**.
- Android: Uses **AlarmManager** + **BroadcastReceiver** with method channels.
- Notifications work even if the app is closed.
- Android supports **action buttons** and persists after reboot.

✅ **Date & Time Selection**\
Uses native date & time pickers with platform styling.

✅ **Task Completion & History**\
Mark tasks as completed and view a log with timestamps.

✅ **Platform Enhancements**

- 📱 **iOS:** Custom payloads & haptic feedback on task actions.
- 🤖 **Android:** Persistent notifications, action buttons, and boot receivers.

✅ **Bonus**

- 🔄 Recurring tasks (daily, weekly, monthly).
- 🌙 Dark Mode follows system theme.
- 🔔 Notification actions: Mark complete or snooze (Android).

---

## 🚀 **Setup & Installation**

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/shubhamshree2001/turnotask.git
cd task-manager-app
```

### 2️⃣ Install Dependencies

```bash
flutter pub get
```

---

## ✅ **Native Notification Setup (No Package)**

### 📱 **iOS Setup**

1. **Permissions in **``

   ```xml
   <key>UIBackgroundModes</key>
   <array>
     <string>fetch</string>
     <string>remote-notification</string>
   </array>
   <key>NSUserNotificationUsageDescription</key>
   <string>We use notifications to remind you about your tasks.</string>
   ```

2. **Platform Channels**

    - Implement `UNUserNotificationCenter` scheduling in `AppDelegate.swift`.
    - Set up `FlutterMethodChannel` to handle `scheduleNotification` and `cancelNotification`.

3. **Haptics**

    - Use Flutter’s `HapticFeedback` for tactile actions.


---

### 🤖 **Android Setup**

1. **Permissions in **``

   ```xml
   <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
   <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
   ```

2. **Receivers in **``

   ```xml
   <receiver
       android:name=".NotificationReceiver"
       android:exported="false" />
   <receiver
       android:name=".NotificationBootReceiver"
       android:enabled="true"
       android:exported="false">
       <intent-filter>
           <action android:name="android.intent.action.BOOT_COMPLETED"/>
       </intent-filter>
   </receiver>
   ```

3. **Platform Channels**

    - Use `AlarmManager` to schedule alarms.
    - Create `BroadcastReceiver` to trigger notifications.
    - Reschedule alarms after reboot with `BOOT_COMPLETED`.



---

## ✅ **Sample Flutter Method Channel**

```dart
import 'package:flutter/services.dart';

class NotificationHelper {
  static const MethodChannel _channel = MethodChannel('com.yourapp/notifications');

  static Future<void> scheduleNotification({required Task task}) async {
    await _channel.invokeMethod('scheduleNotification', {
      'id': task.id,
      'title': task.title,
      'body': task.description,
      'timestamp': task.dateTime.millisecondsSinceEpoch,
      'repeatInterval': task.recurrence.name ?? 'once',
    });
  }

  static Future<void> cancelNotification(int id) async {
    await _channel.invokeMethod('cancelNotification', {'id': id});
  }
}
```

---

## ⚙️ **Platform-Specific Behavior**

| Feature              | iOS                        | Android                                                |
| -------------------- | -------------------------- | ------------------------------------------------------ |
| Notifications        | UNUserNotificationCenter   | AlarmManager + BroadcastReceiver + NotificationManager |
| Boot Persistence     | N/A (handled by system)    | Boot receiver to re-schedule alarms                    |
| Notification Actions | Limited                    | Action buttons supported                               |
| Haptics              | Flutter HapticFeedback API | Flutter HapticFeedback API                             |
| Dark Mode            | `ThemeMode.system`         | `ThemeMode.system`                                     |

---

## ⚡️ **Challenges**

- 🧩 Managing native code for two platforms adds complexity.
- 📱 Real device testing required for notifications & boot persistence.
- 🔐 Requires proper permissions, especially on Android 13+ (`POST_NOTIFICATIONS`).

---

## ✅ **Testing Notes**

- Tested on:
    - **iOS Simulator:** Limited notification and haptic testing. Final tests done on real devices.
    - **Android Emulator:** Works for scheduling and viewing notifications. Real device tests verified boot persistence and action buttons.
- Recommended:
    - Always test **notifications and haptics on real devices** for best accuracy.
    - Check dark mode on both system themes.
---



