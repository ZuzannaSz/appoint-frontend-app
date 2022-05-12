import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../main.dart';

class ScheduledNotification {
  final int id;
  final String? title;
  final String? body;
  final String? payload;
  final int delay;
  
  ScheduledNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
    required this.delay
  });

 
  static countDelayInMinutes(String date){
    return DateTime.parse(date).difference(DateTime.now()).inMinutes;
  }

  Future<void> scheduleNotification() async {


    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        title,
        body,

        tz.TZDateTime.now(tz.local).add(Duration(minutes: delay)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }
}