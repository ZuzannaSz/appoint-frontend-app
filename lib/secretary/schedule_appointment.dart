import 'dart:convert';
import 'dart:io';

import 'package:appoint_webapp/secretary/register_patient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import '../model/Patient.dart';
import '../model/User.dart';

class ScheduleAppointment extends StatefulWidget {
  late User user;

  @override
  _ScheduleAppointment createState() => _ScheduleAppointment();

  ScheduleAppointment({Key? key, required this.user}) : super(key: key);
}

class _ScheduleAppointment extends State<ScheduleAppointment> {


  int chosenRecord = 9999;
  static const String SERVER_IP = 'https://pz-backend2022.herokuapp.com/api';
  late User user;
  late List<Patient> _patientList;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  @override
  void initState() {
    user = widget.user;
    _patientList = [];
    _getPatientList();
    super.initState();
  }



  _getPatientList() async {
    print("$SERVER_IP/Doctor/Appointments");
    var res = await http.get(Uri.parse("$SERVER_IP/Registrator/Patients"),
        headers: {HttpHeaders.authorizationHeader: "Bearer " + user.token});
    print("getting appointment list");
    print(res.body);
    if (res.statusCode != 200) {
      print("Error");
    } else {
      var jsonResponse = json.decode(res.body);
      print(jsonResponse);

      for (var record in jsonResponse) {
        _patientList.add(Patient(
            record["name"], record["surname"], record["telephoneNumber"]));
      }
      setState(() {});
      // for (var member in jsonResponse["board"]["members"]) {
      //   if (member["email"] == user.email) user.name = member["name"];
      //   table.members.add(member["email"]);
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String SERVER_IP = "https://pz-backend2022.herokuapp.com/api";

    registerAppointment() async {
      var response = http.post(Uri.parse('$SERVER_IP/Appointment/Register'),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json; charset=utf-8"
          },
          body: jsonEncode({
            "date":"${_dateController.text}T${_timeController.text}.000Z",
            "length": 0,
            "patientId": 0,
            "userId": 0,
            "roomId": 0
          }));
      print("${_dateController.text}T${_timeController.text}.000Z");
      print(response.then((value) => print(value.statusCode)));
    }

    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: const Color(0xFF5DB075),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book),
                label: 'Schedule',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_box),
                label: 'Register',
              ),
            ],
            onTap: (option) {
              if (option == 1) {
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RegisterPatient()));
              }
            },
            selectedItemColor: Colors.white),
        appBar: AppBar(
          backgroundColor: const Color(0xFF5DB075),
          title: const Text(
            "Schedule Appointment",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: ListView(
          children: [
            const SizedBox(
              height: 40,
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(60, 0, 0, 0),
              child: Text(
                "Patient List",
                style: TextStyle(
                    color: Color(0xFF424242),
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: _buildTextField("Name/Surname"),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Container(
                  width: 300.0,
                  height: MediaQuery.of(context).size.height * 0.55,
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                          blurRadius: 8,
                          offset: Offset(5, 5),
                          color: Color.fromRGBO(127, 140, 141, 0.5),
                          spreadRadius: 1)
                    ],
                    border: Border.all(color: Color(0xFF5DB075), width: 2.0),
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white,
                  ),
                  margin: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                      itemCount: _patientList.length + 1,
                      itemBuilder: (context, index) {
                        if (index < _patientList.length) {
                          return _buildRecord(
                              "${_patientList[index].name} ${_patientList[index].surname}",
                              _patientList[index].telephoneNumber,
                              index);
                        } else {
                          return _buildAddPatient(context, index);
                        }
                      })),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(60, 0, 100, 0),
              child: TextField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.calendar_today),
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                    hintText: "yyyy-mm-dd",
                  )),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(60, 0, 100, 0),
              child: TextField(
                  controller: _timeController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.watch),
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                    hintText: "hh:mm:ss",
                  )),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(100, 0, 0, 0),
              child: Row(
                children: [
                  FloatingActionButton(
                    onPressed: () {},
                    child: Icon(Icons.calendar_today),
                    backgroundColor: Color(0xFF5DB075),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  const Text(
                    "Calendar",
                    style: TextStyle(fontSize: 17),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(130, 0, 130, 0),
              child: ElevatedButton(
                  onPressed: () {
                    registerAppointment();
                  },
                  child: const Text(
                    "Schedule",
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(const Size(150, 60)),
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xFF5DB075)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      )))),
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ));
  }

  _buildRecord(String name, String number, int index) {
    return InkWell(
      onTap: (){
        print(chosenRecord);
        if(chosenRecord == index) {
          chosenRecord = 9999;
        } else {
          chosenRecord = index;
        }
        // _patientList[index].id;
        setState(() {

        });
      },
      child: Container(
        width: 100,
        height: 60,
        decoration:
            BoxDecoration(color: chosenRecord == index? const Color(0xFF5DB075): index % 2 == 1 ? Color(0x7B5DB075) : null),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 0, 15),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 20, color: chosenRecord == index?Colors.white:Colors.black),
              ),
              const SizedBox(
                width: 30,
              ),
              Text(
                number,
                style: const TextStyle(fontSize: 20),
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildTextField(String hintText) {
    return TextField(
        decoration: InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 10),
      prefixIcon: const Icon(Icons.search),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      hintText: hintText,
    ));
  }

  Widget _buildAddPatient(context, index) {
    return InkWell(
      key: const Key("add patient ink"),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => RegisterPatient()));
      },
      child: Container(
        decoration:
            BoxDecoration(color: index % 2 == 1 ? Color(0x7B5DB075) : null),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 15, 0, 15),
          child: Row(
            children: const [
              Icon(Icons.add),
              SizedBox(
                width: 30,
              ),
              Text(
                "Add Patient",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
