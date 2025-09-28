import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationPlugin =
  FlutterLocalNotificationsPlugin();


  Future<void> initNotification() async {
    // Initialize timezone
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.local); // always use device timezone

    // Android settings
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('last');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await _notificationPlugin.initialize(initializationSettings);
  }


  // Show notification immediately
  Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'main_channel', // use ONE channel everywhere
      'Main Notifications',
      channelDescription: 'All notifications',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification_sound'),


    );

    const NotificationDetails platformDetails =
    NotificationDetails(android: androidDetails);

    await _notificationPlugin.show(
      0,
      title,
      body,
      platformDetails,
    );
  }

  // Schedule notification
  Future<void> scheduleNotification({
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'main_channel',
      'Main Notifications',
      channelDescription: 'All notifications',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification_sound'), // no extension

    );

    const platformDetails = NotificationDetails(android: androidDetails);

    final now = DateTime.now();
    var scheduleTime = DateTime(now.year, now.month, now.day, hour, minute);

    if (scheduleTime.isBefore(now)) {
      scheduleTime = scheduleTime.add(const Duration(days: 1));
    }

    await _notificationPlugin.zonedSchedule(
      1,
      title,
      body,
      tz.TZDateTime.from(scheduleTime, tz.local),
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
       matchDateTimeComponents: DateTimeComponents.time,
    );

    print('Scheduled notification for $scheduleTime');
  }
}

