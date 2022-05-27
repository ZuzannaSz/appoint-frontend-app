import 'package:appoint_webapp/doctor/appointment_form.dart';
import 'package:appoint_webapp/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'model/AppointmentInfo.dart';
import 'model/User.dart';

String? selectedNotificationPayload;
final BehaviorSubject<String?> selectNotificationSubject =
    BehaviorSubject<String?>();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
String _timezone = 'Unknown';
List<String> _availableTimezones = <String>[];
bool notificationStarted = false;
late User user;
void main() async {
  runApp(const MyApp());
}

Future<void> _configureLocalTimeZone() async {
  DateTime dateTime = DateTime.now();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation("Europe/Warsaw"));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  _initNotifications(BuildContext context) async {
    WidgetsFlutterBinding.ensureInitialized();
    _configureLocalTimeZone();
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        print(payload);
        List<String> payloadList = payload.split('/');
        print(payloadList);
        // ArchivedAppointment appointment = ArchivedAppointment(
        //     payloadList[0], payloadList[1], payloadList[2], payloadList[3]);
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => AppointmentForm(
        //               user: User.withData(payloadList[4], payloadList[5], payloadList[6]),
        //               appointment: appointment,
        //             )));
      }
      selectedNotificationPayload = payload;
      selectNotificationSubject.add(payload);
    });
  }

  @override
  Widget build(BuildContext context) {
    _initNotifications(context);
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginPage());
  }
}
