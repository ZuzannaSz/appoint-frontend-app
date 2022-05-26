import 'package:appoint_webapp/doctor/list_of_appointments.dart';
import 'package:appoint_webapp/model/AppointmentInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/Medicine.dart';
import '../model/User.dart';
import 'appointment_archives.dart';

class AppointmentForm extends StatefulWidget {
  late User user;
  late ArchivedAppointment appointment;

  @override
  _AppointmentFormState createState() => _AppointmentFormState();

  AppointmentForm({Key? key, required this.user, required this.appointment})
      : super(key: key);
}

class _AppointmentFormState extends State<AppointmentForm> {
  late List<Medicine> medicineList = [
    Medicine.withoutId(
        doses: 0,
        name: "lek",
        remarks: "remarks",
        prescriptionDate: "prescriptionDate",
        schedule: "",
        unit: ""),
    Medicine.withoutId(
        doses: 0,
        name: "lek2",
        remarks: "remarks",
        prescriptionDate: "prescriptionDate",
        schedule: "",
        unit: "")
  ];
  late List<Medicine> chosenMedicineList = [];
  late List<TextEditingController> dosageList = [];
  late List<String> unitList = [];
  late List<String> scheduleList = [];
  late User user;

  final TextEditingController _visitRemarksController = TextEditingController();

  final TextEditingController _patientRemarksController =
      TextEditingController();

  final TextEditingController _medicineNameController = TextEditingController();

  @override
  void initState() {
    user = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int itemsCount = medicineList.length > chosenMedicineList.length
        ? medicineList.length
        : chosenMedicineList.length;
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
                          builder: (context) =>
                              ListOfAppointments(user: user)));
                  break;
                case 1:
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AppointmentArchives(user: user)));
                  break;
              }
            },
            selectedItemColor: Colors.white),
        appBar: AppBar(
          backgroundColor: const Color(0xFF5DB075),
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
            border: Border.all(color: const Color(0xFF5DB075), width: 2.0),
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: ListView(
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
                  children: [
                    const Text(
                      "Name: ",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Text(widget.appointment.patientName)
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const Text(
                      "Surname: ",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Text(widget.appointment.patientSurname)
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const Text(
                      "Phone Number: ",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Text(widget.appointment.phoneNumber),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const Text(
                      "Appointment date: ",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Text(widget.appointment.date)
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const Text(
                      "Appointment time: ",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Text(widget.appointment.time)
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      "Was necessary?",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Checkbox(
                        value: widget.appointment.necessary,
                        onChanged: (bool? val) {
                          setState(() {
                            widget.appointment.necessary = val!;
                          });
                        })
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Was prescription issued?",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Checkbox(
                        value: widget.appointment.receiptGiven,
                        onChanged: (bool? val) {
                          setState(() {
                            widget.appointment.receiptGiven = val!;
                          });
                        })
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Prescribed medicine",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                _medicineTable(itemsCount),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Visit remarks",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 15,
                ),
                _buildCommentSection(_visitRemarksController),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Patient remarks",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 15,
                ),
                _buildCommentSection(_patientRemarksController),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 40, 20),
                  child: ElevatedButton(
                      onPressed: () {},
                      child: const Text(
                        "Send",
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ButtonStyle(
                          fixedSize:
                              MaterialStateProperty.all(const Size(100, 50)),
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xFF5DB075)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )))),
                ),
              ],
            ),
          ),
        )));
  }

  _medicineTable(int itemCount) {
    return DataTable(columns: <DataColumn>[
      const DataColumn(
        label: Text('Name'),
      ),
      DataColumn(
        label: Row(
          children: [
            Text('Doses'),
            SizedBox(
              width: 20,
            ),
            InkWell(
              onTap: () {
                showDialog(
                    builder: (BuildContext context) =>
                        _buildMedicineForm(itemCount),
                    context: context);
              },
              child: Icon(Icons.edit),
            )
          ],
        ),
      ),
    ], rows: [
      for (var data in chosenMedicineList)
        DataRow(cells: [
          DataCell(Text(data.name)),
          DataCell(Text("${data.doses} ${data.unit} ${data.schedule}")),
        ]),
    ]);
  }

  _buildCommentSection(TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
      child: TextField(
          maxLines: 5,
          controller: controller,
          decoration: InputDecoration(
            // isDense: true,                      // Added this
            // contentPadding: EdgeInsets.all(8),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          )),
    );
  }

  _buildMedicineForm(int itemCount) {
    return Material(
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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(17, 10, 20, 20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(310, 0, 0, 10),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.exit_to_app,
                      size: 35,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              right: BorderSide(
                                  color: Color(0xFF5DB075), width: 2.0))),
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(27, 8, 20, 8),
                        child: Text(
                          "Medicine List",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Chosen Medicine",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 440,
                  child: ListView.builder(
                      itemCount: itemCount + 1,
                      itemBuilder: (context, index) {
                        if (index < itemCount) {
                          return _buildRecord(index);
                        } else {
                          return _buildAddMedicine(context);
                          // return _buildAddMedicine(context, index);
                        }
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(180, 10, 0, 0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        fixedSize:
                            MaterialStateProperty.all(const Size(110, 60)),
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xFF5DB075)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ))),
                    child: Text(
                      "Next",
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      for (int i = 0; i < chosenMedicineList.length; i++) {
                        TextEditingController dosage = TextEditingController();
                        dosage.text = "0";
                        dosageList.add(dosage);
                        unitList.add("ml");
                        scheduleList.add("a day");
                      }
                      Navigator.of(context).pop();
                      showDialog(
                          context: context,
                          builder: (context) => _buildDosageForm());
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }

  _buildDosageForm() {
    return Material(
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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(17, 10, 20, 20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(310, 0, 0, 10),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.exit_to_app,
                      size: 35,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              right: BorderSide(
                                  color: Color(0xFF5DB075), width: 2.0))),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Medicine List",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Dosage",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 440,
                  child: ListView(children: [
                    for (int i = 0; i < chosenMedicineList.length; i++)
                      _buildDosageRecord(i)
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(180, 10, 0, 0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        fixedSize:
                            MaterialStateProperty.all(const Size(110, 60)),
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xFF5DB075)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ))),
                    child: const Text(
                      "Finish",
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      for (int i = 0; i < chosenMedicineList.length; i++) {
                        try {
                          chosenMedicineList[i].doses =
                              int.parse(dosageList[i].text);
                        } on Exception {
                          showDialog(
                              context: context,
                              builder: (context) => const AlertDialog(
                                  title: Text("Incorrect dosage input!"),
                                  content: Text(
                                      "Dosage inputs must be alphanumeric")));
                        }

                        chosenMedicineList[i].schedule = scheduleList[i];
                        chosenMedicineList[i].unit = unitList[i];
                      }
                      dosageList.clear();
                      unitList.clear();
                      scheduleList.clear();
                      setState(() {});
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }

  _buildRecord(int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Row(
        children: [
          Material(
            child: InkWell(
              onTap: () {
                if (medicineList.length > index) {
                  chosenMedicineList.add(medicineList.removeAt(index));
                  int itemCount =
                      medicineList.length > chosenMedicineList.length
                          ? medicineList.length
                          : chosenMedicineList.length;
                  print(itemCount);
                  setState(() {});
                  Navigator.of(context).pop();
                  showDialog(
                      builder: (BuildContext context) =>
                          _buildMedicineForm(itemCount),
                      context: context);
                }
              },
              child: Container(
                width: 150,
                height: 40,
                color: const Color(0x7B5DB075),
                child: Center(
                  child: medicineList.length > index
                      ? Text(medicineList[index].name,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black))
                      : Text(""),
                ),
              ),
            ),
          ),
          Material(
            child: InkWell(
              onTap: () {
                if (chosenMedicineList.length > index) {
                  medicineList.add(chosenMedicineList.removeAt(index));
                  int itemCount =
                      medicineList.length > chosenMedicineList.length
                          ? medicineList.length
                          : chosenMedicineList.length;
                  print(itemCount);
                  setState(() {});
                  Navigator.of(context).pop();
                  showDialog(
                      builder: (BuildContext context) =>
                          _buildMedicineForm(itemCount),
                      context: context);
                }
              },
              child: Container(
                width: 170,
                height: 40,
                color: const Color(0x7B8EC59A),
                child: Center(
                  child: chosenMedicineList.length > index
                      ? Text(chosenMedicineList[index].name,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black))
                      : Text(""),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildAddMedicine(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Material(
        child: InkWell(
          key: const Key("add medicine ink"),
          onTap: () {
            showDialog(
                context: context,
                builder: (context) => SimpleDialog(
                      title: Row(
                        children: [
                          SizedBox(width: 40),
                          Text("Add medicine"),
                          SizedBox(
                            width: 90,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Icon(
                              Icons.exit_to_app,
                              size: 30,
                            ),
                          )
                        ],
                      ),
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: Text(
                            "Add medicine name",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                          child: TextFormField(
                            controller: _medicineNameController,
                          ),
                        ),

                        const SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(90, 0, 90, 0),
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ButtonStyle(
                                  fixedSize: MaterialStateProperty.all(
                                      const Size(50, 50)),
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color(0xFF5DB075)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ))),
                              child: Text("Add",style: TextStyle(fontSize: 17),)),
                        )
                      ],
                    ));
          },
          child: Container(
            decoration: BoxDecoration(color: null),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(50, 15, 0, 15),
              child: Row(
                children: const [
                  Icon(Icons.add),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Add Medicine",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildDosageRecord(int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Row(
        children: [
          Container(
            width: 120,
            height: 30,
            color: const Color(0x7B5DB075),
            child: Center(
                child: Text(chosenMedicineList[index].name,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black))),
          ),
          Container(
            width: 50,
            height: 30,
            child: Center(
                child: TextFormField(
                    controller: dosageList[index],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.black))),
          ),
          SizedBox(width: 10),
          DropdownButton(
              value: unitList[index],
              items: const [
                DropdownMenuItem(child: Text("ml"), value: "ml"),
                DropdownMenuItem(child: Text("l"), value: "l"),
                DropdownMenuItem(child: Text("cm"), value: "cm"),
                DropdownMenuItem(child: Text("dm"), value: "dm"),
              ],
              onChanged: (value) {
                if (value is String) {
                  unitList[index] = value;
                  setState(() {});

                  Navigator.of(context).pop();
                  showDialog(
                      context: context,
                      builder: (context) => _buildDosageForm());
                }
              }),
          const SizedBox(width: 10),
          DropdownButton(
              value: scheduleList[index],
              items: const [
                DropdownMenuItem(child: Text("a day"), value: "a day"),
                DropdownMenuItem(child: Text("a week"), value: "a week"),
                DropdownMenuItem(child: Text("a month"), value: "a month"),
                DropdownMenuItem(child: Text("a year"), value: "a year"),
              ],
              onChanged: (value) {
                if (value is String) {
                  scheduleList[index] = value;
                  setState(() {});
                  Navigator.of(context).pop();
                  showDialog(
                      context: context,
                      builder: (context) => _buildDosageForm());
                }
              }),
        ],
      ),
    );
  }
}
