import 'package:appoint_webapp/doctor/appointment_form.dart';
import 'package:appoint_webapp/model/AppointmentInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/User.dart';
import 'appointment_archives.dart';
import 'list_of_appointments.dart';

class AppointmentStatistics extends StatelessWidget {
  late NewAppointment appointment;
  late User user;
  AppointmentStatistics({Key? key, required this.appointment, required this.user})
      : super(key: key);

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
              case 1:
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AppointmentArchives(
                              user: user,
                            )));
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
        child: ListView(
            padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
            children: _buildGeneralInformation(context)),
      )),
    );
  }

  _buildGeneralInformation(BuildContext context) {
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
        children: [
          const Text(
            "Name: ",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Text(appointment.patientName, style: const TextStyle(fontSize: 17)),
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        children: [
          const Text(
            "Surname: ",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Text(appointment.patientSurname, style: TextStyle(fontSize: 17)),
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        children: [
          const Text(
            "PESEL: ",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Text("98040705050", style: TextStyle(fontSize: 17)),
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        children: [
          const Text(
            "Phone number: ",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Text(appointment.phoneNumber, style: TextStyle(fontSize: 17)),
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        children: [
          const Text(
            "Visit date: ",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Text(appointment.date, style: TextStyle(fontSize: 17)),
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        children: [
          const Text(
            "Visit time: ",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Text(appointment.time, style: TextStyle(fontSize: 17)),
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
        height: 60,
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 60, 0),
        child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AppointmentForm(
                            user: user,
                            appointment: ArchivedAppointment.fromNewAppointment(
                                appointment),
                          )));
            },
            child: const Text(
              "App. Form",
              style: TextStyle(fontSize: 18),
            ),
            style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(const Size(60, 60)),
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xFF5DB075)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                )))),
      ),
      const SizedBox(
        height: 30,
      ),
    ];
  }
}
