import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:read_lao/utilities/hive_utility.dart';

class NotificationUtility {
  static const int _id = 1;
  static const String _channelId = 'daily_reminder';
  static const String _channelName = 'Daily Reminder';

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    tz_data.initializeTimeZones();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await _plugin.initialize(initializationSettings);
  }

  static Future<bool> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      return granted ?? false;
    }

    final darwin = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (darwin != null) {
      final granted = await darwin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    return true;
  }

  static Future<void> scheduleReminder() async {
    if (!HiveUtility.getNotificationsEnabled()) return;

    await cancelReminder();

    final int minutesSinceMidnight = HiveUtility.getNotificationMinutes();
    final tz.TZDateTime scheduledTime = _nextOccurrence(minutesSinceMidnight);

    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.zonedSchedule(
      _id,
      'Time to practice Lao!',
      'Keep your streak alive - just 5 minutes a day.',
      scheduledTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelReminder() async {
    await _plugin.cancel(_id);
  }

  static tz.TZDateTime _nextOccurrence(int minutesSinceMidnight) {
    final now = tz.TZDateTime.now(tz.local);
    final int hour = minutesSinceMidnight ~/ 60;
    final int minute = minutesSinceMidnight % 60;

    tz.TZDateTime scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    return scheduledTime;
  }
}
