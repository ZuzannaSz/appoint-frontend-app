import 'dart:convert';
import 'dart:io';

import 'package:appoint_webapp/secretary/schedule_appointment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPatient extends StatelessWidget {
  final String SERVER_IP = "https://pz-backend2022.herokuapp.com/api";

  _registerPatient() async {
    var response = http.post(Uri.parse('$SERVER_IP/Patient/Register'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json; charset=utf-8"
        },
        body: jsonEncode({
          "name" : _patientName.text,
          "surname" : _patientSurname.text,
          "telephoneNumber" : _phoneNumber.text
        }));
    print(response.then((value) => print(value.statusCode)));
  }

  TextEditingController _patientName = TextEditingController();
  TextEditingController _patientSurname = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();
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
            _buildTextField("Name", _patientName),
            const SizedBox(height: 40),
            _buildTextField("Surname", _patientSurname),
            const SizedBox(
              height: 40,
            ),
            _buildTextField("Phone Number", _phoneNumber),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
                onPressed: () {
                  if(_patientName.text.isEmpty){
                    _showMissingInputError("Name", context);
                    return;
                  }
                  if(_patientSurname.text.isEmpty){
                    _showMissingInputError("Surname", context);
                    return;
                  }
                  if(_phoneNumber.text.isEmpty){
                    _showMissingInputError("Phone Number", context);
                    return;
                  }
                  _registerPatient();
                },
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

  _buildTextField(String hintText, TextEditingController textController) {
    return SizedBox(
      width: 300,
      child: TextField(
        controller: textController,
          decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        hintText: hintText,
      )),
    );
  }
  _showMissingInputError(String missingInput, BuildContext context){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Padding(
          padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
          child: Text("Field $missingInput is missing, please fill it",style: TextStyle(fontSize: 18),),
        ),
        content: Padding(
          padding: EdgeInsets.fromLTRB(80, 30, 80, 0),
          child: ElevatedButton(
              style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(const Size(50, 40)),
                  backgroundColor:
                  MaterialStateProperty.all(const Color(0xFF5DB075)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ))),
              child: Text("OK"),
            onPressed: (){
                Navigator.of(context).pop();
            },
            ),
        )
      );
    });
  }
}
