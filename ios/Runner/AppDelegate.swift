import UIKit
import Flutter
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {

  private let CHANNEL = "local_notifications"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: CHANNEL, binaryMessenger: controller.binaryMessenger)

    channel.setMethodCallHandler { [weak self] (call, result) in
      switch call.method {
      case "scheduleNotification":
        if let args = call.arguments as? [String: Any],
           let id = args["id"] as? String,
           let title = args["title"] as? String,
           let body = args["body"] as? String,
           let timestamp = args["timestamp"] as? Double,
           let repeatInterval = args["repeatInterval"] as? String {
          self?.scheduleNotification(id: id, title: title, body: body, timestamp: timestamp, repeatInterval: repeatInterval)
          result(nil)
        } else {
          result(FlutterError(code: "INVALID_ARGS", message: "Missing arguments", details: nil))
        }

      case "cancelNotification":
        if let id = call.arguments as? String {
          UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
          result(nil)
        } else {
          result(FlutterError(code: "INVALID_ARGS", message: "Missing ID", details: nil))
        }

      case "requestNotificationPermission":
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
          DispatchQueue.main.async {
            if let error = error {
              result(FlutterError(code: "PERMISSION_ERROR", message: error.localizedDescription, details: nil))
            } else {
              result(granted)
            }
          }
        }

      case "hasNotificationPermission":
        UNUserNotificationCenter.current().getNotificationSettings { settings in
          let granted = settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional
          DispatchQueue.main.async {
            result(granted)
          }
        }


      default:
        result(FlutterMethodNotImplemented)
      }
    }

    UNUserNotificationCenter.current().delegate = self
    setupNotificationCategories()

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  /// Schedule notification with daily, weekly, monthly repeat
  private func scheduleNotification(id: String, title: String, body: String, timestamp: TimeInterval, repeatInterval: String) {
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = .default
    content.categoryIdentifier = "TASK_CATEGORY"

    let triggerDate = Date(timeIntervalSince1970: timestamp / 1000)
    var dateComponents: DateComponents

    switch repeatInterval {
    case "daily":
      dateComponents = Calendar.current.dateComponents([.hour, .minute], from: triggerDate)
    case "weekly":
      dateComponents = Calendar.current.dateComponents([.weekday, .hour, .minute], from: triggerDate)
    case "monthly":
      dateComponents = Calendar.current.dateComponents([.day, .hour, .minute], from: triggerDate)
    default:
      dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
    }

    let repeats = repeatInterval != "once"
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeats)

    let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request) { error in
      if let error = error {
        print("Error scheduling notification: \(error.localizedDescription)")
      } else {
        print("Notification scheduled with ID: \(id)")
      }
    }
  }

  /// Define actions for notifications
  private func setupNotificationCategories() {
    let markDoneAction = UNNotificationAction(identifier: "MARK_DONE", title: "Mark as Done", options: [.foreground])
    let category = UNNotificationCategory(identifier: "TASK_CATEGORY", actions: [markDoneAction], intentIdentifiers: [], options: [])
    UNUserNotificationCenter.current().setNotificationCategories([category])
  }

  /// Handle notification actions
  override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {
    print("Notification action received: \(response.actionIdentifier)")
    if response.actionIdentifier == "MARK_DONE" {
      let id = response.notification.request.identifier
      print("Task \(id) marked as done!")
      // TODO: Send this info back to Flutter if you want.
    }
    completionHandler()
  }

  /// Show notifications while app is foregrounded
  override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    if #available(iOS 14.0, *) {
      completionHandler([.banner, .sound])
    } else {
      completionHandler([.alert, .sound])
    }
  }
}