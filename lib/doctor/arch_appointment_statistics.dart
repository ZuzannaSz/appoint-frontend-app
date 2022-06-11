import 'package:appoint_webapp/model/AppointmentInfo.dart';
import 'package:appoint_webapp/model/Medicine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/User.dart';
import 'appointment_archives.dart';
import 'list_of_appointments.dart';

class ArchAppointmentStatistics extends StatelessWidget {
  late ArchivedAppointment appointment;
  late User user;
  ArchAppointmentStatistics({Key? key, required this.appointment, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Medicine> medicineList = appointment.prescriptionMeds;
    appointment = ArchivedAppointment.withDetailedInfo(
      1,
        appointment.patientName,
        appointment.patientSurname,
        appointment.date,
       appointment.duration,
        appointment.necessary,
        appointment.patientRemarks,
        appointment.receiptGiven,
        appointment.tookPlace,
        appointment.visitRemarks,
        appointment.time,
        appointment.phoneNumber,
        medicineList);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
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
            padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
            children: _buildGeneralInformation(context)),
      )),
    );
  }

  List<Widget> _buildGeneralInformation(BuildContext context) {
    return [
      const SizedBox(
        height: 40,
      ),
      const Text(
        "General Information",
        style: TextStyle(
            color: Colors.teal,
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
        children: [
          const Text(
            "Visit duration: ",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Text(appointment.duration.toString(), style: TextStyle(fontSize: 17)),
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        children: [
          Text(
            "Took place?: ",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Text(appointment.tookPlace ? "Yes" : "No",
              style: TextStyle(fontSize: 17)),
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        children: [
          Text(
            "Was urgent?: ",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Text(appointment.necessary ? "Yes" : "No",
              style: TextStyle(fontSize: 17)),
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        children: [
          Text(
            "Was Receipt Given?: ",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Text(appointment.receiptGiven ? "Yes" : "No",
              style: TextStyle(fontSize: 17)),
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      _medicineTable(appointment.prescriptionMeds.length),
      const SizedBox(
        height: 20,
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 80, 0),
        child: Column(
          children: [
            const Text(
              "Remarks about visit: ",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(appointment.visitRemarks, style: TextStyle(fontSize: 17)),
          ],
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 80, 0),
        child: Column(
          children: [
            const Text(
              "Remarks about patient: ",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(appointment.patientRemarks, style: TextStyle(fontSize: 17)),
          ],
        ),
      ),
      const SizedBox(
        height: 20,
      ),
    ];
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
          ],
        ),
      ),
    ], rows: [
      for (var data in appointment.prescriptionMeds)
        DataRow(cells: [
          DataCell(Text(data.name)),
          DataCell(Text("${data.doses} ${data.unit} ${data.schedule}")),
        ]),
    ]);
  }
}
