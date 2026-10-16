import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:flutter_timezone/timezone_info.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotifcationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    InitializationSettings settings = InitializationSettings(
      android: AndroidInitializationSettings("ic_stat_carrotime"),
    );
    flutterLocalNotificationsPlugin.initialize(settings: settings);
  }

  static Future<void> showNotification({
    required String name,
    required DateTime targetEndTime,
  }) async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
    NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        'Carrot_ID',
        'CarroTime_Notification',
        importance: Importance.max,
        priority: Priority.high,

        icon: 'logo',
        fullScreenIntent: true,
        category: AndroidNotificationCategory.alarm,
      ),
    );
    final TimezoneInfo currentTimeZone =
        await FlutterTimezone.getLocalTimezone();
    // int ID =  DateTime.now().microsecondsSinceEpoch;
    tz.setLocalLocation(tz.getLocation(currentTimeZone.identifier));

    // final tz.TZDateTime scheduledDate = tz.TZDateTime.from(
    //   targetEndTime,
    //   tz.local,
    // );
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: 1,
      title: "Harvest Time! 🌱",
      body: "Your $name has fully grown! Take a well-deserved break.",
      scheduledDate: tz.TZDateTime.from(targetEndTime, tz.local),
      // scheduledDate: tz.TZDateTime.now(tz.local).add(Duration(minutes: 5)),
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
    print("Notification scheduled for $targetEndTime");
  }

  static Future<void> Cancel({required int id}) async {
    await flutterLocalNotificationsPlugin.cancel(id: id);
  }
}
