import 'package:appoint_webapp/model/ArchivedAppointment.dart';
import 'package:flutter/material.dart';

import '../model/User.dart';
import 'appointment_form.dart';
import 'list_of_patients.dart';

class AppointmentArchives extends StatelessWidget {
  late User user;
  AppointmentArchives({Key? key, required this.user}) : super(key: key);
  List<ArchivedAppointment> archivedAppointments = [
    ArchivedAppointment("Jan Kowalski","26:01:2021","success")
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
          backgroundColor: const Color(0xFF5DB075),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book),
              label: 'App. List',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article),
              label: 'App. Form',
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ListOfPatients(user: user)));
                break;
              case 1:
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AppointmentForm(user: user)));
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
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.7,
              child: ListView(
                  padding: const EdgeInsets.fromLTRB(60, 0, 0, 0),
                  children: [
                    for ( var archApp in archivedAppointments ) _buildArchivedVisit(archApp)
                  ]
              ),
            ),
          )),
    );
  }

  _buildArchivedVisit(ArchivedAppointment archivedAppointment){
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
              Text("Patient Name:  ", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
              Text(archivedAppointment.patient,style: TextStyle(fontSize: 17))
            ],
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              Text("App. Date:  ", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
              Text(archivedAppointment.date,style: TextStyle(fontSize: 17))
            ],
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              Text("App. Status:  ", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
              Text(archivedAppointment.status,style: TextStyle(fontSize: 17, color: _determineStatusTextColor(archivedAppointment.status)))
            ],
          ),
        ],
      ),
    ),
    );
  }
  _determineStatusTextColor(String status){
    switch(status){
      case "success":
        return Colors.green;
      case "fail":
        return Colors.red;
      default:
        return Colors.white;
    }

  }
}
