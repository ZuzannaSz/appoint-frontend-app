import 'dart:convert';
import 'dart:io';

import 'package:appoint_webapp/model/AppointmentInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/Medicine.dart';
import '../model/Patient.dart';
import '../model/User.dart';
import 'arch_appointment_statistics.dart';
import 'list_of_appointments.dart';

class AppointmentArchives extends StatefulWidget {
  AppointmentArchives({Key? key, required this.user}) : super(key: key);
  late User user;

  @override
  _AppointmentArchivesState createState() => _AppointmentArchivesState();
}

class _AppointmentArchivesState extends State<AppointmentArchives> {
  final String SERVER_IP = 'https://pz-backend2022.herokuapp.com/api';
  List<ArchivedAppointment> archivedAppointments = [
    ArchivedAppointment("Jurek", "Kowalski", "26:01:2021", "12:42")
  ];
  int patientIndex = 1;

  getArchivedAppointments(int id) async {
    var res = await http.get(
      Uri.parse("$SERVER_IP/Patient/ArchivedAppointments/$id"),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer " + user.token,
        HttpHeaders.contentTypeHeader: "application/json; charset=utf-8",
      },
    );
    if (res.statusCode != 200) {
      print("Error with Archived Appointments");
      print(res.statusCode);
      print(res.reasonPhrase);
    } else {
      archivedAppointments.clear();
      List jsonMap = await jsonDecode(res.body);
      print(jsonMap);
      for (var appointment in jsonMap) {
        List<Medicine> medicineList = [];
        for (var medicine in appointment["medicine"]) {
          medicineList.add(Medicine.withoutId(
              doses: medicine["dosage"],
              name: medicine["name"],
              remarks: medicine["remarks"],
              prescriptionDate:
                  "${medicine["prescriptionDate"][""]} ${medicine["prescriptionDate"]} ${medicine["prescriptionDate"]}",
              schedule: medicine["schedule"],
              unit: medicine["timeUnit"]));
        }

        archivedAppointments.add(ArchivedAppointment.withDetailedInfo(
            appointment["id"],
            appointment["patientName"],
            appointment["patientSurname"],
            "${appointment["date"]["year"]}-${appointment["date"]["month"]}-${appointment["date"]["day"]}",
            appointment["length"],
            appointment["wasNecessary"],
            appointment["patientRemarks"][0]["remarks"],
            appointment["wasPrescriptionIssued"],
            appointment["tookPlace"],
            appointment["visitRemarks"],
            "${appointment["time"]["hour"]}:${appointment["time"]["minute"]}:${appointment["time"]["second"]}",
            appointment["roomNumber"],
            medicineList));
      }
    }
  }

  late User user;

  @override
  void initState() {
    user = widget.user;
    getPatientList();
    super.initState();
  }

  getPatientList() async {
    var res = await http.get(
      Uri.parse("$SERVER_IP/Registrator/Patients/"),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer " + user.token,
        HttpHeaders.contentTypeHeader: "application/json; charset=utf-8",
      },
    );
    if (res.statusCode != 200) {
      print("Error with Registrator PAtients");
      print(res.statusCode);
      print(res.reasonPhrase);
    } else {
      List jsonMap = await jsonDecode(res.body);
      print(jsonMap);
      for (var jsonPatient in jsonMap) {
        if(jsonPatient["name"].contains("Testo")){
          jsonPatient["name"] = "Testo";
          jsonPatient["surname"] = "Testowy";
        }

        patientList.add(Patient.withId(jsonPatient["id"], jsonPatient["name"],
            jsonPatient["surname"], jsonPatient["telephoneNumber"]));
      }
      patientIndex = patientList[0].id;
    }
    setState(() {});
  }

  late List<Patient> patientList = [
    Patient.withId(0, "jurek", "ogorek", "783210056")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: 1,
          backgroundColor: const Color(0xFF5DB075),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book),
              label: 'App. List',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books),
              label: 'App. History',
            ),
          ],
          onTap: (option) {
            switch (option) {
              case 0:
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ListOfAppointments(user: user)));
                break;
            }
          },
          selectedItemColor: Colors.white),
      appBar: AppBar(
        backgroundColor: Color(0xFF5DB075),
        title: const Text(
          "Appointment History",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
        child: SizedBox(
          width: 350.0,
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                child: Container(
                  width: 330.0,
                  height: 80.0,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                    child: Row(
                      children: [
                        const Text(
                          "Patients: ",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        DropdownButton(
                            value: patientIndex,
                            items: [
                              for (int indx = 0;
                                  indx < patientList.length;
                                  indx++)
                                DropdownMenuItem(
                                    child: Text(
                                        "${patientList[indx].name} ${patientList[indx].surname}"),
                                    value: indx)
                            ],
                            onChanged: (value) {
                              if (value is int) {
                                archivedAppointments.clear();
                                getArchivedAppointments(patientList[value].id);
                                patientIndex = value;
                                setState(() {});
                              }
                            }),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xFF5DB075), width: 2.0),
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                          blurRadius: 8,
                          offset: Offset(5, 5),
                          color: Color.fromRGBO(127, 140, 141, 0.5),
                          spreadRadius: 1)
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 370,
                child: ListView(
                    padding: const EdgeInsets.fromLTRB(60, 0, 0, 0),
                    children: [
                      for (var archApp in archivedAppointments)
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ArchAppointmentStatistics(
                                            appointment:
                                                archivedAppointments[0],
                                            user: user),
                                  ));
                            },
                            child: _buildArchivedVisit(archApp))
                    ]),
              ),
            ],
          ),
        ),
      )),
    );
  }

  _buildArchivedVisit(ArchivedAppointment archivedAppointment) {
    return Container(
      width: 300.0,
      height: 150.0,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF5DB075), width: 2.0),
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
              blurRadius: 8,
              offset: Offset(5, 5),
              color: Color.fromRGBO(127, 140, 141, 0.5),
              spreadRadius: 1)
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  "Patient Name:  ",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                Text(
                    "${archivedAppointment.patientName} ${archivedAppointment.patientSurname}",
                    style: TextStyle(fontSize: 17))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Text(
                  "App. Date:  ",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                Text(archivedAppointment.date, style: TextStyle(fontSize: 17))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Text(
                  "App. Time:  ",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                Text(archivedAppointment.time, style: TextStyle(fontSize: 17))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
