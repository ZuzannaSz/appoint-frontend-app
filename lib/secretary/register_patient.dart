import 'dart:convert';
import 'dart:io';

import 'package:appoint_webapp/login_page.dart';
import 'package:appoint_webapp/secretary/schedule_appointment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../generated/l10n.dart';
import '../model/User.dart';
import 'admin_panel.dart';

class RegisterPatient extends StatefulWidget {
  late User user;

  RegisterPatient({Key? key, required this.user}) : super(key: key);

  @override
  State<RegisterPatient> createState() => _RegisterPatient();
}

class _RegisterPatient extends State<RegisterPatient> {
  final String SERVER_IP = "https://pz-backend2022.herokuapp.com/api";
  late User user;
  TextEditingController _patientName = TextEditingController();
  TextEditingController _patientSurname = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();
  late String gender;
  late String phoneError;

  @override
  void initState() {
    user = widget.user;
    gender = "M";
    super.initState();
  }

  _registerPatient() async {
    var response = http.post(Uri.parse('$SERVER_IP/Patient/Register'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json; charset=utf-8",
          HttpHeaders.authorizationHeader: "Bearer ${user.token}"
        },
        body: jsonEncode({
          "name": _patientName.text,
          "surname": _patientSurname.text,
          "telephoneNumber": _phoneNumber.text,
          "sex": gender
        }));
    print(response.then((value) => print(value.statusCode)));
    print(response.then((value) => print(value.reasonPhrase)));
    print(response.then((value) => value.statusCode == 200
        ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(S.of(context).patientAddedSuccessfully),
            duration: Duration(seconds: 1),
          ))
        : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(S.of(context).errorSavingThePatient),
            duration: Duration(seconds: 1),
          ))));
    _patientName.text = "";
    _patientSurname.text = "";
    _phoneNumber.text = "";
  }

  bool validatePhoneNumber() {
    final text = _phoneNumber.value.text;
    RegExp regExp = new RegExp(
        r'(^[0-9]{2}(\s)?[0-9]{3}(\s)?(([0-9]{3}(\s)?[0-9]{3})|([0-9]{2}(\s)?[0-9]{2}))$)');
    if (regExp.hasMatch(text)) {
      return true;
    }
    return false;
  }

  String? get _errorText {
    final text = _phoneNumber.value.text;
    if (!text.isEmpty && !validatePhoneNumber()) {
      return S.of(context).thePhoneNumberIsInAWrongFormat;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var _text;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 2,
          backgroundColor: Colors.teal,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book),
              label: S.of(context).schedule,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.admin_panel_settings),
              label: S.of(context).adminPanel,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_box),
              label: S.of(context).register,
            ),
          ],
          onTap: (option) {
            if (option == 0) {
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ScheduleAppointment(
                            user: user,
                          )));
            } else if (option == 1) {
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AdminPanel(user: user)));
            }
          },
          selectedItemColor: Colors.white,
        ),
        appBar: AppBar(
          title: Text(
            S.of(context).registerPatient,
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Center(
            child: Column(
          children: [
            const SizedBox(height: 90),
            Text(
              S.of(context).registerPatient,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 40),
            _buildTextField(S.of(context).name, _patientName),
            const SizedBox(height: 40),
            _buildTextField(S.of(context).surname, _patientSurname),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: 300,
              child: TextField(
                  controller: _phoneNumber,
                  onChanged: (text) => setState(() => _text),
                  decoration: InputDecoration(
                    errorText: _errorText,
                    contentPadding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    hintText: S.of(context).phoneNumber,
                  )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ListTile(
                    title: Text(S.of(context).male),
                    leading: Radio(
                        value: "M",
                        groupValue: gender,
                        onChanged: (value) => {
                              setState(() {
                                gender = value.toString();
                              })
                            }),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(S.of(context).female),
                    leading: Radio(
                      value: "F",
                      groupValue: gender,
                      onChanged: (value) => {
                        setState(() {
                          gender = value.toString();
                        })
                      },
                    ),
                  ),
                )
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  if (_patientName.text.isEmpty) {
                    _showMissingInputError(S.of(context).name, context);
                    return;
                  }
                  if (_patientSurname.text.isEmpty) {
                    _showMissingInputError(S.of(context).surname, context);
                    return;
                  }
                  if (_phoneNumber.text.isEmpty) {
                    _showMissingInputError(S.of(context).phoneNumber, context);
                    return;
                  }
                  if (!validatePhoneNumber()) {
                    return;
                  }
                  _registerPatient();
                },
                child: Text(
                  S.of(context).register,
                  style: TextStyle(fontSize: 20),
                ),
                style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(const Size(150, 60)),
                    backgroundColor: MaterialStateProperty.all(Colors.teal),
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
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            hintText: hintText,
          )),
    );
  }

  _showMissingInputError(String missingInput, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Text(
                  S.of(context).field +
                      missingInput +
                      S.of(context).isMissingPleaseFillIt,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              content: Padding(
                padding: const EdgeInsets.fromLTRB(80, 30, 80, 0),
                child: ElevatedButton(
                  style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(const Size(50, 40)),
                      backgroundColor: MaterialStateProperty.all(Colors.teal),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ))),
                  child: Text(S.of(context).ok),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ));
        });
  }
}
