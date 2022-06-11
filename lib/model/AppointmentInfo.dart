import 'Medicine.dart';

class ArchivedAppointment {
  late String patientName;
  late String patientSurname;
  late String date;
  late int id;
  late String time;
  late String phoneNumber;
  late bool tookPlace;
  late int duration;
  late bool necessary = false;
  late String patientRemarks;
  late String visitRemarks;
  late bool receiptGiven = false;
  late List<Medicine> prescriptionMeds;


  ArchivedAppointment(
      this.patientName, this.patientSurname, this.date, this.time);

  ArchivedAppointment.withDetailedInfo(
      this.id,
      this.patientName,
      this.patientSurname,
      this.date,
      this.duration,
      this.necessary,
      this.patientRemarks,
      this.receiptGiven,
      this.tookPlace,
      this.visitRemarks,
      this.time,
      this.phoneNumber,
      this.prescriptionMeds);

  ArchivedAppointment.fromNewAppointment(NewAppointment newAppointment) {
    id = newAppointment.id;
    patientName = newAppointment.patientName;
    patientSurname = newAppointment.patientSurname;
    date = newAppointment.date;
    phoneNumber = newAppointment.phoneNumber;
    time = newAppointment.time;
  }
}

class NewAppointment {
  late int id;
  late String patientName;
  late String patientSurname;
  late String phoneNumber;
  late String date;
  late String time;
  late String roomNumber;
  late String roomSpecialization;
  late int length;

  NewAppointment(
      {required this.id,
      required this.patientName,
      required this.patientSurname,
      required this.phoneNumber,
      required this.date,
      required this.time,
      required this.length,
      required this.roomNumber,
      required this.roomSpecialization});
}
