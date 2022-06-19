import 'dart:convert';
import 'dart:io';

import 'package:appoint_webapp/doctor/accumulated_statistics.dart';
import 'package:appoint_webapp/doctor/appointment_archives.dart';
import 'package:appoint_webapp/doctor/appointments_statistics.dart';
import 'package:appoint_webapp/model/AppointmentInfo.dart';
import 'package:appoint_webapp/model/ScheduledNotification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import '../generated/l10n.dart';
import '../main.dart';
import '../model/AppointmentList.dart';
import '../model/User.dart';

class ListOfAppointments extends StatefulWidget {
  late User user;

  @override
  _ListOfAppointmentsState createState() => _ListOfAppointmentsState();

  ListOfAppointments({Key? key, required this.user}) : super(key: key);
}

class _ListOfAppointmentsState extends State<ListOfAppointments> {
  int day = 0;
  final String SERVER_IP = 'https://pz-backend2022.herokuapp.com/api';
  late final AppointmentList _appointmentList = AppointmentList();
  late List _dayOfAppointment = _appointmentList.getDay(DateTime.now().weekday);
  late List _displayDayOfAppointment = [];
  final List<String> _columnList = [
    "patientName",
    "patientSurname",
    "telephoneNumber",
    "date",
    "time"
  ];
  late User user;
  late List displayDayOfWeek = [
    S.of(context).monday,
    S.of(context).tuesday,
    S.of(context).wednesday,
    S.of(context).thursday,
    S.of(context).friday,
    S.of(context).saturday,
    S.of(context).sunday
  ];

  @override
  void initState() {
    super.initState();
    user = widget.user;
    initAppointmentList();
    initNotification();
  }

  DateTime _toDateTime(appointment) {
    return DateTime.parse("${appointment["date"]} ${appointment["time"]}");
  }

  int _compareAppointments(appointmentOld, appointmentNew) {
    DateTime newDate = _toDateTime(appointmentOld);
    DateTime oldDate = _toDateTime(appointmentNew);
    return newDate.isAfter(oldDate) ? 1 : -1;
  }

  int _findAppointmentIndex() {
    DateTime now = DateTime.now();
    for (int i = 0; i < _dayOfAppointment.length; i++) {
      if (now.isBefore(_toDateTime(_dayOfAppointment[i]))) {
        if (i == 0) {
          return i;
        } else if (now.isAfter(_toDateTime(_dayOfAppointment[i - 1]))) {
          return i;
        }
      }
    }
    return -1;
  }

  initNotification() async {
    if (_dayOfAppointment.isEmpty) return;

    _dayOfAppointment.sort(_compareAppointments);
    int index = _findAppointmentIndex();
    if (index == -1) {
      print("Error with findAppointmentIndex no appointment found");
      return;
    }
    String appointmentDate =
        _toDateTime(_dayOfAppointment[index]).toIso8601String();
    // DateTime parsedDate = DateTime.parse(appointmentDate);
    NotificationAppLaunchDetails? details =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    print(details?.didNotificationLaunchApp);
    String date = "${_dayOfAppointment[0]["date"]}";
    String time = "${_dayOfAppointment[0]["time"]}";
    NewAppointment appointment = NewAppointment(
        patientName: _dayOfAppointment[0]["patientName"],
        patientSurname: _dayOfAppointment[0]["patientSurname"],
        phoneNumber: _dayOfAppointment[0]["telephoneNumber"],
        date: date,
        time: time,
        length: _dayOfAppointment[0]["length"],
        roomNumber: _dayOfAppointment[0]["roomNumber"],
        roomSpecialization: _dayOfAppointment[0]["roomSpecialization"],
        id: _dayOfAppointment[0]["id"]);
    ScheduledNotification startNotification = ScheduledNotification(
        id: 0,
        title: S.of(context).appointmentStarted,
        body: S.of(context).yourAppointmentOn +
            date +
            S.of(context).at +
            time +
            S.of(context).hasStarted,
        payload:
            "${appointment.patientName}/${appointment.patientSurname}/${appointment.phoneNumber}/${appointment.date}/${appointment.time}/${user.username}/${user.token}/${user.refreshToken}",
        delay: ScheduledNotification.countDelayInMinutes(appointmentDate));
    startNotification.scheduleNotification();
    details =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    print(details?.didNotificationLaunchApp);
  }

  initAppointmentList() async {
    await _getAppointmentList();
    _dayOfAppointment = _appointmentList.getDay(DateTime.now().weekday);
    _displayDayOfAppointment = _dayOfAppointment;
    setState(() {});
  }

  Future<AppointmentList?> _getAppointmentList() async {
    var res = await http.get(
      Uri.parse("$SERVER_IP/Doctor/Appointments"),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer " + user.token,
        HttpHeaders.contentTypeHeader: "application/json; charset=utf-8",
      },
    );
    print("getting appointment list");
    print(res.statusCode);
    // print(res.body);
    if (res.statusCode != 200) {
      print("Error");
      return null;
    } else {
      Map jsonResponse = json.decode(res.body);
      print("app list response:\n$jsonResponse");

      _appointmentList.setAppointmentMap(jsonResponse);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.teal,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.menu_book),
              label: S.of(context).appList,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: S.of(context).statistics,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.library_books),
              label: S.of(context).appHistory,
            ),
          ],
          onTap: (option) {
            switch (option) {
              case 1:
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AccumulatedStatistics(user: user)));
                break;
              case 2:
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AppointmentArchives(user: user)));
                break;
            }
          },
          selectedItemColor: Colors.white),
      appBar: AppBar(
        title: Text(
          S.of(context).listOfAppointments,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: _buildList(context),
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 40,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              child: TextField(
                  onChanged: (input) {
                    _displayDayOfAppointment = _dayOfAppointment
                        .where((value) =>
                            value["patientName"].toString().contains(input) ||
                            value["patientSurname"].toString().contains(input))
                        .toList();
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    hintText: S.of(context).namesurname,
                  )),
            ),
          ],
        ),
        const SizedBox(height: 30),
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 37,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.teal, width: 2.0),
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.white,
            ),
            child: ListView.builder(
              itemCount: _appointmentList.length(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  color: index % 2 == 1
                      ? const Color.fromARGB(119, 126, 219, 192)
                      : null,
                  child: InkWell(
                    onTap: () async {
                      switch (index) {
                        case 0:
                          _dayOfAppointment = _appointmentList.getMonday();
                          _displayDayOfAppointment = _dayOfAppointment;
                          setState(() {});
                          break;
                        case 1:
                          _dayOfAppointment = _appointmentList.getTuesday();
                          _displayDayOfAppointment = _dayOfAppointment;
                          setState(() {});
                          break;
                        case 2:
                          _dayOfAppointment = _appointmentList.getWednesday();
                          _displayDayOfAppointment = _dayOfAppointment;
                          setState(() {});
                          break;
                        case 3:
                          _dayOfAppointment = _appointmentList.getThursday();
                          _displayDayOfAppointment = _dayOfAppointment;
                          setState(() {});
                          break;
                        case 4:
                          _dayOfAppointment = _appointmentList.getFriday();
                          _displayDayOfAppointment = _dayOfAppointment;
                          setState(() {});
                          break;
                        case 5:
                          _dayOfAppointment = _appointmentList.getSaturday();
                          _displayDayOfAppointment = _dayOfAppointment;
                          setState(() {});
                          break;
                        case 6:
                          _dayOfAppointment = _appointmentList.getSunday();
                          _displayDayOfAppointment = _dayOfAppointment;
                          setState(() {});
                          break;
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        // _appointmentList.getDays()[index],
                        displayDayOfWeek[index],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Center(
          child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                      blurRadius: 8,
                      offset: Offset(5, 5),
                      color: Color.fromRGBO(87, 136, 141, 0.5019607843137255),
                      spreadRadius: 1)
                ],
                border: Border.all(color: Colors.teal, width: 2.0),
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
              ),
              margin: const EdgeInsets.all(16.0),
              child: ListView.builder(
                  itemCount: 5,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index1) {
                    return Container(
                      color: index1 % 2 == 1
                          ? const Color.fromARGB(119, 126, 219, 192)
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SizedBox(
                          width: 80.0,
                          height: 200.0,
                          child: ListView.builder(
                              itemCount: _displayDayOfAppointment.length + 1,
                              itemBuilder: (context, index2) {
                                if (index2 == 0) {
                                  if (index1 == 0) {
                                    return Center(
                                      child: SizedBox(
                                          height: 50,
                                          child: Text(
                                            S.of(context).name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                    );
                                  } else if (index1 == 1) {
                                    return Center(
                                      child: SizedBox(
                                          height: 50,
                                          child: Text(S.of(context).surname,
                                              style: const TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    );
                                  } else if (index1 == 2) {
                                    return Center(
                                      child: SizedBox(
                                          height: 50,
                                          child: Text(S.of(context).phoneNumber,
                                              style: const TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    );
                                  } else if (index1 == 3) {
                                    return Center(
                                      child: SizedBox(
                                          height: 50,
                                          child: Text(S.of(context).date,
                                              style: const TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    );
                                  } else {
                                    return Center(
                                      child: SizedBox(
                                          height: 50,
                                          child: Text(S.of(context).time,
                                              style: const TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    );
                                  }
                                } else {
                                  return InkWell(
                                    onTap: () {
                                      NewAppointment appointment = NewAppointment(
                                          patientName:
                                              _displayDayOfAppointment[index2 - 1]
                                                  ["patientName"],
                                          patientSurname:
                                              _displayDayOfAppointment[index2 - 1]
                                                  ["patientSurname"],
                                          phoneNumber:
                                              _displayDayOfAppointment[index2 - 1]
                                                  ["telephoneNumber"],
                                          date:
                                              "${_displayDayOfAppointment[index2 - 1]["date"]}",
                                          time:
                                              "${_displayDayOfAppointment[index2 - 1]["time"]}",
                                          length:
                                              _displayDayOfAppointment[index2 - 1]
                                                  ["length"],
                                          roomNumber:
                                              _displayDayOfAppointment[index2 - 1]
                                                  ["roomNumber"],
                                          roomSpecialization:
                                              _displayDayOfAppointment[index2 - 1]
                                                  ["roomSpecialization"],
                                          id: _displayDayOfAppointment[index2 - 1]
                                              ["id"]);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AppointmentStatistics(
                                                    appointment: appointment,
                                                    user: user),
                                          ));
                                    },
                                    child: Center(
                                      child: SizedBox(
                                          height: 35,
                                          child: Text(_displayDayOfAppointment[
                                                  index2 - 1]
                                              [_columnList[index1]])),
                                    ),
                                  );
                                }
                              }),
                        ),
                      ),
                    );
                  })),
        ),
      ],
    );
  }

// _buildTextField(String hintText) {
//   return TextField(
//       decoration: InputDecoration(
//     contentPadding: const EdgeInsets.symmetric(vertical: 10),
//     prefixIcon: const Icon(Icons.search),
//     border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
//     hintText: hintText,
//   ));
// }
}
