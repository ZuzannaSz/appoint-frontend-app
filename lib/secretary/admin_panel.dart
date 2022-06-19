import 'dart:convert';
import 'dart:io';

import 'package:appoint_webapp/model/ShiftList.dart';
import 'package:appoint_webapp/secretary/register_patient.dart';
import 'package:appoint_webapp/secretary/schedule_appointment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../generated/l10n.dart';
import '../model/Doctor.dart';
import '../model/Office.dart';
import '../model/User.dart';

class AdminPanel extends StatefulWidget {
  late User user;

  @override
  _AdminPanel createState() => _AdminPanel();

  AdminPanel({Key? key, required this.user}) : super(key: key);
}

class _AdminPanel extends State<AdminPanel> {
  final String SERVER_IP = 'https://pz-backend2022.herokuapp.com/api';
  late ShiftList _shiftList = ShiftList();
  late List _dayOfShifts;
  late int shiftDayInt = 0;
  late List<Doctor> doctorList = [];
  late Doctor currentDoctor;
  late List<Office> officeList = [];
  late Office currentOffice;
  late List _displayDayOfShifts = [];
  final List<String> _columnList = [
    "doctorName",
    "doctorSurname",
    "specialization",
    "room",
    "shiftStart",
    "shiftEnd"
  ];
  final dayOfWeekDictPL={"Monday":"Poniedziałek",
"Tuesday":"Wtorek","Wednesday":"Środa",
  "Thursday":"Czwartek","Friday":"Piątek","Saturday":"Sobota"};
  String translate(String orgVal){
    if (locale.toString() == "pl" &&
        dayOfWeekDictPL.containsKey(orgVal)) {
      return dayOfWeekDictPL[orgVal].toString();
    }
    return orgVal;
  }
  late User user;
  late Locale locale;
  @override
  void didChangeDependencies() {
    locale = Localizations.localeOf(context);
    super.didChangeDependencies();
  }
  TextEditingController officeNumController = TextEditingController();
  TextEditingController specializationController = TextEditingController();
  TextEditingController shiftFromController = TextEditingController();
  TextEditingController shiftToController = TextEditingController();

  late List<String> dayList = [
    S.of(context).monday,
    S.of(context).tuesday,
    S.of(context).wednesday,
    S.of(context).thursday,
    S.of(context).friday,
    S.of(context).saturday,
  ];
  int indexOfDayList = 0;

  List<ScrollController> scrollControllerList = [
    ScrollController(),
    ScrollController(),
    ScrollController(),
    ScrollController(),
    ScrollController(),
    ScrollController()
  ];

  @override
  void initState() {
    user = widget.user;
    initShiftList();
    initOfficeList();
    initDoctorList();

    for (int i = 0; i < scrollControllerList.length; i++) {
      for (int j = 0; j < scrollControllerList.length; j++) {
        if (i != j) {
          scrollControllerList[i].addListener(() {
            scrollControllerList[j].animateTo(scrollControllerList[i].offset,
                duration: Duration(milliseconds: 10), curve: Curves.linear);
          });
        }
      }
    }

    super.initState();
  }

  initDoctorList() async {
    var res = await http.get(Uri.parse("$SERVER_IP/Doctor/GetAll"),
        headers: {HttpHeaders.authorizationHeader: "Bearer " + user.token});
    print("getting doctor list");
    if (res.statusCode != 200) {
      print("Error");
    } else {
      var jsonResponse = json.decode(res.body);
      print(jsonResponse);
      for (var record in jsonResponse) {
        doctorList.add(Doctor(record["id"], record["name"], record["surname"],
            record["specialization"]));
      }
      currentDoctor = doctorList[0];
      setState(() {});
    }
  }

  initOfficeList() async {
    var res = await http.get(Uri.parse("$SERVER_IP/Room/GetAll"),
        headers: {HttpHeaders.authorizationHeader: "Bearer " + user.token});
    print("getting office list");
    if (res.statusCode != 200) {
      print("Error");
    } else {
      var jsonResponse = json.decode(res.body);
      print(jsonResponse);
      for (var record in jsonResponse) {
        officeList.add(Office(record["id"], record["number"]));
      }
      currentOffice = officeList[0];
      setState(() {});
    }
  }

  _getShiftList() async {
    var res = await http.get(Uri.parse("$SERVER_IP/AvailableHours/GetAll"),
        headers: {HttpHeaders.authorizationHeader: "Bearer " + user.token});
    print("getting shift list");
    if (res.statusCode != 200) {
      print("Error");
    } else {
      var jsonResponse = json.decode(res.body);
      print(jsonResponse);
      _shiftList.shiftMap = jsonResponse;
      setState(() {});
    }
  }

  initShiftList() async {
    _shiftList = await _getShiftList();
    _dayOfShifts = _shiftList.getDay(DateTime.now().weekday);
    _displayDayOfShifts = _dayOfShifts;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
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
          } else if (option == 2) {
            Navigator.of(context).pop();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RegisterPatient(
                          user: user,
                        )));
          }
        },
        selectedItemColor: Colors.white,
      ),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          S.of(context).adminPanel,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            _buildList(context),
            SizedBox(
              height: 20,
            ),
            _buildButton(context)
          ],
        ),
      ),
    );
  }

  ElevatedButton _buildButton(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => _buildAddItemDialog(context));
        },
        child: Text(
          S.of(context).addItem,
          style: TextStyle(fontSize: 18),
        ),
        style: ButtonStyle(
            fixedSize: MaterialStateProperty.all(const Size(150, 60)),
            backgroundColor: MaterialStateProperty.all(Colors.teal),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ))));
  }

  ElevatedButton _buildAddOfficeButton(BuildContext context, bool inForm) {
    return ElevatedButton(
        onPressed: () {
          if (inForm) {
            _officePostRequest();
            Navigator.of(context).pop();
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) => _buildAddOfficeForm());
          }
        },
        child: Text(
          S.of(context).addOffice,
          style: TextStyle(fontSize: 16),
        ),
        style: ButtonStyle(
            fixedSize: MaterialStateProperty.all(const Size(150, 60)),
            backgroundColor: MaterialStateProperty.all(Colors.teal),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ))));
  }

  Widget _buildAddShiftButton(BuildContext context, bool inForm) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
      child: ElevatedButton(
          onPressed: () {
            if (inForm) {
              _shiftPostRequest();
              Navigator.of(context).pop();
            } else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => _buildAddShiftForm());
            }
          },
          child: Text(
            S.of(context).addShift,
            style: TextStyle(fontSize: 16),
          ),
          style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(const Size(150, 60)),
              backgroundColor: MaterialStateProperty.all(Colors.teal),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              )))),
    );
  }

  ElevatedButton _buildAddSpecButton(BuildContext context, bool inForm) {
    return ElevatedButton(
        onPressed: () {
          if (inForm) {
            _specPostRequest();
            Navigator.of(context).pop();
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) => _buildAddSpecForm());
          }
        },
        child: Text(
          S.of(context).addnspecialization,
          style: TextStyle(fontSize: 16),
        ),
        style: ButtonStyle(
            fixedSize: MaterialStateProperty.all(const Size(140, 60)),
            backgroundColor: MaterialStateProperty.all(Colors.teal),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ))));
  }

  _buildAddItemDialog(BuildContext context) {
    return Dialog(
      child: Container(
        width: 200,
        height: 370,
        child: Center(
          child: Column(
            children: [
              _buildExitAppButton(),
              _buildAddOfficeButton(context, false),
              SizedBox(
                height: 20,
              ),
              _buildAddShiftButton(context, false),
              SizedBox(
                height: 20,
              ),
              _buildAddSpecButton(context, false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 50,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
          child: SizedBox(
            width: 200,
            child: TextField(
                onChanged: (input) {
                  if(input.isNotEmpty) {
                    _displayDayOfShifts = _dayOfShifts
                        .where((value) =>
                    value["doctorName"].toString().contains(input) ||
                        value["doctorSurname"].toString().contains(input))
                        .toList();
                  }
                  else{
                    _displayDayOfShifts.clear();
                    _displayDayOfShifts = _dayOfShifts;
                  }
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  hintText: S.of(context).namesurname,
                )),
          ),
        ),
        const SizedBox(height: 30),
        Center(
          child: Container(
            width: 300,
            height: 37,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.teal, width: 2.0),
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.white,
            ),
            child: ListView.builder(
              itemCount: _shiftList.length(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  color: index % 2 == 1
                      ? const Color.fromARGB(119, 126, 219, 192)
                      : null,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          switch (index) {
                            case 0:
                              _dayOfShifts = _shiftList.getMonday();
                              _displayDayOfShifts = _dayOfShifts;
                              shiftDayInt = 0;
                              setState(() {});
                              break;
                            case 1:
                              _dayOfShifts = _shiftList.getTuesday();
                              _displayDayOfShifts = _dayOfShifts;
                              shiftDayInt = 1;
                              setState(() {});
                              break;
                            case 2:
                              _dayOfShifts = _shiftList.getWednesday();
                              _displayDayOfShifts = _dayOfShifts;
                              shiftDayInt = 2;
                              setState(() {});
                              break;
                            case 3:
                              _dayOfShifts = _shiftList.getThursday();
                              _displayDayOfShifts = _dayOfShifts;
                              shiftDayInt = 3;
                              setState(() {});
                              break;
                            case 4:
                              _dayOfShifts = _shiftList.getFriday();
                              _displayDayOfShifts = _dayOfShifts;
                              shiftDayInt = 4;
                              setState(() {});
                              break;
                            case 5:
                              _dayOfShifts = _shiftList.getSaturday();
                              _displayDayOfShifts = _dayOfShifts;
                              shiftDayInt = 5;
                              setState(() {});
                              break;
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            // _shiftList.getDays()[index],
                            dayList[index],
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        Center(
          child: Container(
              width: 300.0,
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                      blurRadius: 8,
                      offset: Offset(5, 5),
                      color: Color.fromRGBO(127, 140, 141, 0.5),
                      spreadRadius: 1)
                ],
                border: Border.all(color: Colors.teal, width: 2.0),
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
              ),
              margin: const EdgeInsets.all(16.0),
              child: ListView.builder(
                  itemCount: _columnList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index1) {
                    return Container(
                      color: index1 % 2 == 1
                          ? const Color.fromARGB(119, 126, 219, 192)
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SizedBox(
                          width: 100.0,
                          height: 200.0,
                          child: ListView.builder(
                              shrinkWrap: true,
                              controller: scrollControllerList[index1],
                              itemCount: _displayDayOfShifts.length + 1,
                              itemBuilder: (context, index2) {
                                if (index2 == 0) {
                                  if (index1 == 0) {
                                    return Center(
                                      child: SizedBox(
                                          height: 50,
                                          child: Text(
                                            S.of(context).name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                    );
                                  } else if (index1 == 1) {
                                    return Center(
                                      child: SizedBox(
                                          height: 50,
                                          child: Text(S.of(context).surname,
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    );
                                  } else if (index1 == 2) {
                                    return Center(
                                      child: SizedBox(
                                          height: 50,
                                          child: Text(
                                              S.of(context).specialization,
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    );
                                  } else if (index1 == 3) {
                                    return Center(
                                      child: SizedBox(
                                          height: 50,
                                          child: Text(S.of(context).office,
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    );
                                  } else if (index1 == 4) {
                                    return Center(
                                      child: SizedBox(
                                          height: 50,
                                          child: Text(S.of(context).shiftStart,
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    );
                                  } else {
                                    return Center(
                                      child: SizedBox(
                                          height: 50,
                                          child: Text(S.of(context).shiftEnd,
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    );
                                  }
                                } else if (index1 == 0) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 20, 0),
                                        child: InkWell(
                                          child: Icon(Icons.delete_forever),
                                          onTap: () {
                                            DateTime shiftStart =
                                                DateTime.parse(
                                                    _displayDayOfShifts[index2 -
                                                        1][_columnList[4]]);
                                            DateTime shiftEnd = DateTime.parse(
                                                _displayDayOfShifts[index2 - 1]
                                                    [_columnList[5]]);
                                            String shiftStartMinutes = "00";
                                            String shiftEndMinutes = "00";
                                            if (shiftStart.minute > 9) {
                                              shiftStartMinutes =
                                                  shiftStart.minute.toString();
                                            } else {
                                              shiftStartMinutes =
                                                  "0${shiftStart.minute}";
                                            }
                                            if (shiftEnd.minute > 9) {
                                              shiftEndMinutes =
                                                  shiftStart.minute.toString();
                                            } else {
                                              shiftEndMinutes =
                                                  "0${shiftEnd.minute}";
                                            }
                                            String doctor =
                                                "${_displayDayOfShifts[index2 - 1][_columnList[0]]} ${_displayDayOfShifts[index2 - 1][_columnList[1]]}";
                                            String shift =
                                                "${shiftStart.hour}:$shiftStartMinutes:00 and ${shiftEnd.hour}:$shiftEndMinutes:00";
                                            String day = _shiftList
                                                .getDays()[index2 - 1];
                                            int shiftId =
                                                _displayDayOfShifts[index2 - 1]
                                                    ["id"];
                                            showDeleteConfirmation(context,
                                                doctor, shift, day, shiftId);
                                          },
                                        ),
                                      ),
                                      Center(
                                        child: SizedBox(
                                            height: 35,
                                            child: Text(
                                                _displayDayOfShifts[index2 - 1]
                                                    [_columnList[index1]])),
                                      ),
                                    ],
                                  );
                                } else if (index1 == 4 || index1 == 5) {
                                  DateTime shiftStart = DateTime.parse(
                                      _displayDayOfShifts[index2 - 1]
                                          [_columnList[4]]);
                                  DateTime shiftEnd = DateTime.parse(
                                      _displayDayOfShifts[index2 - 1]
                                          [_columnList[5]]);
                                  String shiftStartMinutes = "00";
                                  String shiftEndMinutes = "00";
                                  if (shiftStart.minute > 9) {
                                    shiftStartMinutes =
                                        shiftStart.minute.toString();
                                  } else {
                                    shiftStartMinutes = "0${shiftStart.minute}";
                                  }
                                  if (shiftEnd.minute > 9) {
                                    shiftEndMinutes =
                                        shiftStart.minute.toString();
                                  } else {
                                    shiftEndMinutes = "0${shiftEnd.minute}";
                                  }

                                  return Center(
                                      child: SizedBox(
                                    height: 35,
                                    child: Text(index1 == 4
                                        ? "${shiftStart.hour}:$shiftStartMinutes:00"
                                        : "${shiftEnd.hour}:$shiftEndMinutes:00"),
                                  ));
                                } else {
                                  return Center(
                                    child: SizedBox(
                                        height: 35,
                                        child: Text(
                                            _displayDayOfShifts[index2 - 1]
                                                [_columnList[index1]])),
                                  );
                                }
                              }),
                        ),
                      ),
                    );
                  })),
        ),
      ],
    );
  }

  _buildAddOfficeForm() {
    return Dialog(
      child: Container(
        width: 200,
        height: 370,
        child: Center(
            child: Form(
          child: Column(
            children: [
              _buildExitAppButton(),
              Text(S.of(context).addOffice,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                child: Row(
                  children: [
                    Text(S.of(context).officeNumber,
                        style: TextStyle(fontSize: 17)),
                    SizedBox(
                        width: 60,
                        height: 30,
                        child: FormField(
                            builder: (context) => TextField(
                                controller: officeNumController,
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                )))),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(S.of(context).specialization2,
                  style: TextStyle(fontSize: 17)),
              SizedBox(height: 20),
              SizedBox(
                  width: 200,
                  height: 30,
                  child: FormField(
                      builder: (context) => TextField(
                          controller: specializationController,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.fromLTRB(20, 0, 0, 0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                          )))),
              SizedBox(
                height: 40,
              ),
              _buildAddOfficeButton(context, true)
            ],
          ),
        )),
      ),
    );
  }

  _buildAddShiftForm() {
    return Dialog(
      child: Container(
        width: 200,
        height: 370,
        child: ListView(
          shrinkWrap: true,
          children: [
            _buildExitAppButton(),
            Center(
                child: Text(
              S.of(context).addShift,
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            )),
            const SizedBox(
              height: 40,
            ),
            Center(
                child: Text(S.of(context).chooseDoctor,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: DropdownButton(
                  value: currentDoctor,
                  items: [
                    for (Doctor doc in doctorList)
                      DropdownMenuItem(
                          child: Text("Dr. ${doc.name} ${doc.surname}"),
                          value: doc)
                  ],
                  onChanged: (value) {
                    if (value is Doctor) {
                      currentDoctor = value;
                      setState(() {});
                      Navigator.of(context).pop();
                      showDialog(
                          context: context,
                          builder: (context) => _buildAddShiftForm());
                    }
                  }),
            ),
            SizedBox(
              height: 30,
            ),
            Center(
                child: Text(S.of(context).chooseOfficeRoom,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            SizedBox(
              height: 10,
            ),
            Center(
              child: DropdownButton(
                  value: currentOffice,
                  items: [
                    for (Office office in officeList)
                      DropdownMenuItem(
                          child: Text("${office.officeNum}"), value: office)
                  ],
                  onChanged: (value) {
                    if (value is Office) {
                      currentOffice = value;
                      setState(() {});
                      Navigator.of(context).pop();
                      showDialog(
                          context: context,
                          builder: (context) => _buildAddShiftForm());
                    }
                  }),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
                child: Text(S.of(context).inputShift,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(S.of(context).dayOfShift),
                DropdownButton(
                    value: indexOfDayList,
                    items: [
                      for (String day in dayList)
                        DropdownMenuItem(
                            child: Text(day), value: dayList.indexOf(day))
                    ],
                    onChanged: (index) {
                      if (index is int) {
                        indexOfDayList = index;
                        setState(() {});
                        Navigator.of(context).pop();
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _buildAddShiftForm());
                      }
                    }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(S.of(context).startOfShift),
                SizedBox(
                    width: 80,
                    height: 30,
                    child: FormField(
                        builder: (context) => TextField(
                              decoration: InputDecoration(hintText: "hh:mm:ss"),
                              controller: shiftFromController,
                            ))),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(S.of(context).endOfShift),
                SizedBox(
                    width: 80,
                    height: 30,
                    child: FormField(
                        builder: (context) => TextField(
                              decoration: InputDecoration(hintText: "hh:mm:ss"),
                              controller: shiftToController,
                            ))),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            _buildAddShiftButton(context, true)
          ],
        ),
      ),
    );
  }

  _buildAddSpecForm() {
    return Dialog(
      child: Container(
        width: 200,
        height: 270,
        child: Center(
            child: Form(
          child: Column(
            children: [
              _buildExitAppButton(),
              Text(S.of(context).addSpecialization,
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(S.of(context).specializationName),
                  SizedBox(
                      width: 70,
                      height: 30,
                      child: FormField(
                          builder: (context) => TextField(
                                controller: specializationController,
                              ))),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              _buildAddSpecButton(context, true)
            ],
          ),
        )),
      ),
    );
  }

  Widget _buildExitAppButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(240, 10, 0, 20),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: const Icon(
          Icons.exit_to_app,
          size: 25,
        ),
      ),
    );
  }

  showDeleteConfirmation(BuildContext context, String doctor, String shift,
      String day, int shiftId) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text(S.of(context).cancel),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text(S.of(context).confirm),
      onPressed: () {
        _deleteShift(shiftId);
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(S.of(context).deleteConfirmation),
      content: Text(S.of(context).wouldYouLikeToDeleteShiftForDr +
          doctor +
          S.of(context).on +
          translate(day) +
          S.of(context).between +
          shift +
          "?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _deleteShift(int id) {
    var response = http.delete(
      Uri.parse("$SERVER_IP/AvailableHours/Delete/$id"),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json; charset=utf-8",
        HttpHeaders.authorizationHeader: "Bearer ${user.token}",
      },
    );
    print(response.then((value) => print(value.statusCode)));
    print(response.then((value) => print(value.reasonPhrase)));
    initShiftList();
    setState(() {});
  }

  _officePostRequest() async {
    var response = http.post(Uri.parse('$SERVER_IP/Room/Register'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json; charset=utf-8",
          HttpHeaders.authorizationHeader: "Bearer ${user.token}"
        },
        body: jsonEncode({
          "number": officeNumController.text,
          "specialization": specializationController.text
        }));
    print(response.then((value) => print(value.statusCode)));
    print(response.then((value) => print(value.reasonPhrase)));
    officeNumController.clear();
    specializationController.clear();
    _getShiftList();
  }

  _specPostRequest() async {
    var response = http.post(Uri.parse('$SERVER_IP/Specialization/Register'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json; charset=utf-8",
          HttpHeaders.authorizationHeader: "Bearer ${user.token}"
        },
        body: jsonEncode({
          "name": specializationController.text,
        }));
    print(response.then((value) => print(value.statusCode)));
    print(response.then((value) => print(value.reasonPhrase)));
    specializationController.clear();
    _getShiftList();
    setState(() {});
  }

  _shiftPostRequest() async {
    DateTime today = DateTime.now();

    while (today.weekday != indexOfDayList + 1) {
      today = today.add(const Duration(days: 1));
    }

    String shiftStart =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}T${shiftFromController.text.padLeft(8, '0')}.000Z";
    String shiftEnd =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}T${shiftToController.text.padLeft(8, '0')}.000Z";
    var response = http.post(Uri.parse('$SERVER_IP/AvailableHours/Register'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json; charset=utf-8",
          HttpHeaders.authorizationHeader: "Bearer ${user.token}"
        },
        body: jsonEncode({
          "doctorId": currentDoctor.id,
          "roomId": currentOffice.id,
          "start": shiftStart,
          "end": shiftEnd
        }));
    print(jsonEncode({
      "doctorId": 14,
      "roomId": currentOffice.id,
      "start": shiftStart,
      "end": shiftEnd
    }));
    print(response.then((value) => print(value.statusCode)));
    print(response.then((value) => print(value.reasonPhrase)));
    shiftToController.clear();
    shiftFromController.clear();
    initShiftList();
    setState(() {});
  }
}
