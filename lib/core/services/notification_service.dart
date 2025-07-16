import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _notifications.initialize(initSettings);
  }

  Future<void> showWorkoutProgress({
    required int id,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'workout_channel',
      'Workout Notifications',
      importance: Importance.max,
      priority: Priority.high,
      ongoing: true,
      playSound: true,
      enableVibration: true,
      onlyAlertOnce: true,
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'pauseActionId',
          // isPaused ? 'Resume' :
          'Pause',
          showsUserInterface: true,
          cancelNotification: false,
        ),
      ],
    );

    const iosDetails = DarwinNotificationDetails();
    const details =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _notifications.show(id, title, body, details);
  }

  Future<void> cancel(int id) async {
    await _notifications.cancel(id);
  }
}
