import 'dart:convert';
import 'dart:io';

import 'package:appoint_webapp/secretary/register_patient.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ScheduleAppointment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String SERVER_IP = "https://pz-backend2022.herokuapp.com/api";

    registerAppointment() async {
      var response = http.post(Uri.parse('$SERVER_IP/Appointment/Register'),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json; charset=utf-8"
          },
          body: jsonEncode({}));
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
                  height: MediaQuery.of(context).size.height * 0.39,
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
                      itemCount: 7,
                      itemBuilder: (context, index) {
                        if (index < 6)
                          return _buildRecord(
                              "Jan Kowalski", "696809569", index);
                        else {
                          return _buildAddPatient(context, index);
                        }
                      })),
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
            SizedBox(
              height: 40,
            ),
          ],
        ));
  }

  _buildRecord(String name, String number, int index) {
    return Container(
      decoration:
          BoxDecoration(color: index % 2 == 1 ? Color(0x7B5DB075) : null),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 15, 0, 15),
        child: Row(
          children: const [
            Text(
              "Jan Kowalski",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              width: 30,
            ),
            Text(
              "696809569",
              style: TextStyle(fontSize: 20),
            )
          ],
        ),
      ),
    );
  }

  _buildTextField(String hintText) {
    return TextField(
        decoration: InputDecoration(
      contentPadding: EdgeInsets.symmetric(vertical: 10),
      prefixIcon: Icon(Icons.search),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      hintText: hintText,
    ));
  }

  Widget _buildAddPatient(context, index) {
    return InkWell(
      key: Key("add patient ink"),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => RegisterPatient()));
      },
      child: Container(
        decoration:
            BoxDecoration(color: index % 2 == 1 ? Color(0x7B5DB075) : null),
        child: Padding(
          padding: EdgeInsets.fromLTRB(40, 15, 0, 15),
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
