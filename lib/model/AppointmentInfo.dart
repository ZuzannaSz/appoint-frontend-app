class ArchivedAppointment{
  late String patient;
  late String date;
  late String status;

  ArchivedAppointment(this.patient, this.date, this.status);
}
class NewAppointment{
  late String patientName;
  late String patientSurname;
  late String phoneNumber;
  late String date;
  late String time;
  late String status;

  NewAppointment({required this.patientName,required this.patientSurname, required this.phoneNumber, required this.date, required this.time});

  setStatus(String status){
    this.status = status;
  }
}