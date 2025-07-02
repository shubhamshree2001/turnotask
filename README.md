
# 📋 Task Manager App

A simple cross-platform Task Manager app built in Flutter (or your framework) that allows users to create, view, and manage tasks with native notifications and platform-specific enhancements.

---

## ✨ **Core Features**

✅ **Add Tasks**
- Create tasks with a title, description, and reminder time.

✅ **View Tasks**
- View all tasks with their scheduled reminders.

✅ **Schedule Notifications**
- Native notifications for reminders:
    - **iOS:** Uses iOS native notification API.
    - **Android:** Uses Android native notification API with action buttons.

✅ **Date & Time Selection**
- Uses native pickers for date and time:
    - **iOS:** Native iOS picker.
    - **Android:** Native Android picker.

✅ **Task Completion & History**
- Mark tasks as completed.
- View a log/history of completed tasks, with completion time.
- Completed tasks are visually marked or moved to a “Completed” section.

✅ **Platform-Specific Enhancements**
- 📱 **iOS:**
    - Custom message with task title in notifications.
    - Haptic feedback when tasks are added or deleted.
- 🤖 **Android:**
    - Notifications include action buttons (e.g., "Mark as Done").
    - Notifications persist after app closure or device reboot.

✅ **Bonus Features**
- 🔄 Recurring tasks (daily, weekly, monthly).
- 🌙 Dark Mode (auto-adapts to system theme).
- 🔔 Notification Actions (mark complete or snooze directly from notifications).

---

## 🚀 **Setup & Installation**

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/your-task-manager-app.git
   cd your-task-manager-app
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Platform-specific setup:**

    - **iOS:**
        - Add notification permissions to `Info.plist`.
        - Ensure Push Notifications capability is enabled.
        - Test on a real device for haptic feedback.

    - **Android:**
        - Configure `AndroidManifest.xml` for notification and boot permissions:
          ```xml
          <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
          <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
          ```
        - Add required broadcast receivers for persistent notifications.
        - Test on a real device for notification actions.

4. **Run the app:**
   ```bash
   flutter run
   ```

---

## ⚙️ **Platform-Specific Implementations**

- **Notifications:**
    - iOS: Uses `flutter_local_notifications` with iOS-specific configurations for custom alerts and haptics.
    - Android: Uses `flutter_local_notifications` with action buttons and boot persistence using `RECEIVE_BOOT_COMPLETED`.

- **Date & Time Pickers:**
    - Uses `showDatePicker` and `showTimePicker` with platform-specific styling.

- **Haptic Feedback:**
    - iOS-specific haptics using `HapticFeedback` API.

- **Dark Mode:**
    - Uses `ThemeMode.system` to adapt to system-wide theme changes.

---

## ⚡️ **Challenges & Trade-offs**

- Handling **persistent notifications** on Android required setting up boot receivers and ensuring proper background execution, which can vary by device manufacturers.
- Ensuring **consistent behavior** across iOS and Android for notification actions and haptics took extra testing time.
- Recurring tasks required additional logic to re-schedule notifications accurately.
- iOS notification action buttons are more limited than Android’s.

---

## ✅ **Testing Notes**

- Tested on:
    - **iOS Simulator:** Limited notification and haptic testing. Final tests done on real devices.
    - **Android Emulator:** Works for scheduling and viewing notifications. Real device tests verified boot persistence and action buttons.
- Recommended:
    - Always test **notifications and haptics on real devices** for best accuracy.
    - Check dark mode on both system themes.

---

## 📝 **License**

MIT License (or your license of choice)
