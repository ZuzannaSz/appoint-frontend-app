import 'package:appoint_webapp/secretary/schedule_appointment.dart';
import 'package:flutter/material.dart';

class RegisterPatient extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 1,
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
            if (option == 0) {
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ScheduleAppointment()));
            }
          },
          selectedItemColor: Colors.white,
        ),
        appBar: AppBar(
          backgroundColor: const Color(0xFF5DB075),
          title: const Text(
            "Register Patient",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Center(
            child: Column(
          children: [
            const SizedBox(height: 90),
            const Text(
              "Register Patient",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 40),
            _buildTextField("Name"),
            const SizedBox(height: 40),
            _buildTextField("Surname"),
            const SizedBox(
              height: 40,
            ),
            _buildTextField("Phone Number"),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
                onPressed: () {},
                child: const Text(
                  "Register",
                  style: TextStyle(fontSize: 20),
                ),
                style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(const Size(150, 60)),
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xFF5DB075)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ))))
          ],
        )));
  }

  _buildTextField(String hintText) {
    return SizedBox(
      width: 300,
      child: TextField(
          decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        hintText: hintText,
      )),
    );
  }
}
