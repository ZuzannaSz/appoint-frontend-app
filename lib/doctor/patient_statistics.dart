import 'dart:collection';
import 'dart:collection';

import 'package:appoint_webapp/doctor/appointment_form.dart';
import 'package:appoint_webapp/model/AppointmentList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/User.dart';
import 'appointment_archives.dart';
import 'list_of_patients.dart';

class PatientStatistics extends StatelessWidget {

  late User user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xFF5DB075),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book),
              label: 'App. List',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article),
              label: 'App. form',
            ),
          ],
          onTap: (option) {
            switch (option) {
              case 0:
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ListOfPatients(user: user)));
                break;
              case 1:
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AppointmentForm()));
                break;
              case 2:
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AppointmentArchives()));
                break;
            }
          },
          selectedItemColor: Colors.white),
      appBar: AppBar(
        backgroundColor: Color(0xFF5DB075),
        title: const Text(
          "Patient Statistics",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
          child: Container(
        width: 300.0,
        height: MediaQuery.of(context).size.height * 0.7,
        margin: const EdgeInsets.all(16.0),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(60, 0, 0, 0),
          children: _buildGeneralInformation()
        ),
      )),
    );
  }


  _buildGeneralInformation(){
    return [
      const SizedBox(
        height: 40,
      ),
      const Text(
        "General Information",
        style: TextStyle(
            color: Color(0xFF5DB075),
            fontSize: 24,
            fontWeight: FontWeight.bold),
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        children: const [
          Text(
            "Name: ",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Text("Name ", style: TextStyle(fontSize: 17)),
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        children: const [
          Text(
            "Surname: ",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Text("Surname ", style: TextStyle(fontSize: 17)),
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        children: const [
          Text(
            "PESEL: ",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Text("901324241 ", style: TextStyle(fontSize: 17)),
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        children: const [
          Text(
            "Phone number: ",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Text("783 210 231 ", style: TextStyle(fontSize: 17)),
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        children: const [
          Text(
            "Visit date: ",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Text("2000-10-31", style: TextStyle(fontSize: 17)),
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        children: const [
          Text(
            "Visit time: ",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Text("12:30:00", style: TextStyle(fontSize: 17)),
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        children: const [
          Text(
            "Is urgent?: ",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Text("No", style: TextStyle(fontSize: 17)),
        ],
      ),
      const SizedBox(
        height: 100,
      ),
    ];
  }
}
