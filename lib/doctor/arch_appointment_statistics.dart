import 'package:appoint_webapp/model/AppointmentInfo.dart';
import 'package:appoint_webapp/model/Medicine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../generated/l10n.dart';
import '../model/User.dart';

class ArchAppointmentStatistics extends StatelessWidget {
  late ArchivedAppointment appointment;
  late User user;
  late Locale locale;

  ArchAppointmentStatistics(
      {Key? key,
      required this.appointment,
      required this.user,
      required this.locale})
      : super(key: key);

  final dosageDict = {
    "a day": "dziennie",
    "a week": "tygodniowo",
    "a month": "na miesiąc",
    "a year": "na rok"
  };

  String translateDosage(String dbValue) {
    if (locale.toString() == "pl" && dosageDict.containsKey(dbValue)) {
      return dosageDict[dbValue].toString();
    }
    return dbValue;
  }

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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          S.of(context).patientStatistics,
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
      Text(
        S.of(context).generalInformation,
        style: TextStyle(
            color: Colors.teal, fontSize: 24, fontWeight: FontWeight.bold),
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        children: [
          Text(
            S.of(context).name2,
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
          Text(
            S.of(context).surname2,
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
          Text(
            S.of(context).phoneNumber2,
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
          Text(
            S.of(context).visitDate,
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
          Text(
            S.of(context).visitTime2,
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
          Text(
            S.of(context).visitDuration2,
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
            S.of(context).tookPlace,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Text(appointment.tookPlace ? S.of(context).yes : S.of(context).no,
              style: TextStyle(fontSize: 17)),
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        children: [
          Text(
            S.of(context).wasUrgent2,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Text(appointment.necessary ? S.of(context).yes : S.of(context).no,
              style: TextStyle(fontSize: 17)),
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        children: [
          Text(
            S.of(context).wasReceiptGiven2,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Text(appointment.receiptGiven ? S.of(context).yes : S.of(context).no,
              style: TextStyle(fontSize: 17)),
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      _medicineTable(appointment.prescriptionMeds.length, context),
      const SizedBox(
        height: 20,
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 80, 0),
        child: Column(
          children: [
            Text(
              S.of(context).remarksAboutVisit,
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
            Text(
              S.of(context).remarksAboutPatient,
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

  _medicineTable(int itemCount, dynamic context) {
    return DataTable(columns: <DataColumn>[
      DataColumn(
        label: Text(S.of(context).nameDrug),
      ),
      DataColumn(
        label: Row(
          children: [
            Text(S.of(context).doses),
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
          DataCell(Text(
              "${data.doses} ${data.unit} ${translateDosage(data.schedule)}")),
        ]),
    ]);
  }
}
