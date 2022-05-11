import 'package:appoint_webapp/doctor/list_of_appointments.dart';
import 'package:flutter/material.dart';


import '../model/User.dart';
import 'appointment_archives.dart';

class AppointmentForm extends StatefulWidget {
  late User user;
  @override
  _AppointmentFormState createState() => _AppointmentFormState();
  AppointmentForm({Key? key, required this.user}) : super(key: key);
}

class _AppointmentFormState extends State<AppointmentForm> {
  late User user;
  String _dropValue = "success";

  @override
  void initState() {
    user = widget.user;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: const Color(0xFF5DB075),
            currentIndex: 1,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book),
                label: 'App. List',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.article),
                label: 'App. form',
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
          backgroundColor: Color(0xFF5DB075),
          title: const Text(
            "Appointment Form",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Center(
            child: Container(
          width: 300.0,
          height: MediaQuery.of(context).size.height * 0.7,
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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 60, 0),
                  child: Text(
                    "Appointment Form",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: const [
                    Text(
                      "Name: ",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text("")
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: const [
                    Text(
                      "Surname: ",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text("")
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: const [
                    Text(
                      "Phone Number: ",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text("")
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: const [
                    Text(
                      "Appointment date: ",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text("")
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: const [
                    Text(
                      "Appointment time: ",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text("")
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: const [
                    Text(
                      "Finished at: ",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text("")
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 190, 0),
                  child: Text(
                    "Status: ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 150, 0),
                  child: DropdownButton(
                      value: _dropValue,
                      items: const [
                        DropdownMenuItem(
                          child: Text("success"),
                          value: "success",
                        ),
                        DropdownMenuItem(child: Text("fail"), value: "fail"),
                        DropdownMenuItem(child: Text("death"), value: "death"),
                      ],
                      onChanged: (value) {
                        if (value is String) {
                          setState(() {
                            _dropValue = value;
                          });
                        }
                      }),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
                  child: ElevatedButton(
                      onPressed: () {},
                      child: const Text(
                        "Send",
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all(const Size(100, 40)),
                          backgroundColor:
                          MaterialStateProperty.all(const Color(0xFF5DB075)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              )))),
                )
              ],
            ),
          ),
        )));
  }
}
