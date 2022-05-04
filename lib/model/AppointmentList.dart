import 'dart:ffi';

class AppointmentList {
  Map appointmentMap = {
    "Monday": [
      {
        "Name": "Jan",
        "Surname": "Kowalski",
        "Age": "20",
        "Phone Number": "783 123 382",
        "Date": "2022-10-31T01:30:00.000-05:00"
      },
      {
        "Name": "Joanna",
        "Surname": "Kowalskia",
        "Age": "24",
        "Phone Number": "743 123 382",
        "Date": "2022-10-31T01:30:00.000-05:00"
      }
    ],
    "Tuesday": [
      {
        "Name": "Jan",
        "Surname": "Kowalski",
        "Age": "20",
        "Phone Number": "783 123 382",
        "Date": "2022-10-31T01:30:00.000-05:00"
      }
    ],
    "Wednesday": [
      {
        "Name": "Jan",
        "Surname": "Kowalski",
        "Age": "20",
        "Phone Number": "783 123 382",
        "Date": "2022-10-31T01:30:00.000-05:00"
      }
    ],
    "Thursday": [
      {
        "Name": "Jan",
        "Surname": "Kowalski",
        "Age": "20",
        "Phone Number": "783 123 382",
        "Date": "2022-10-31T01:30:00.000-05:00"
      }
    ],
    "Friday": [
      {
        "Name": "Jan",
        "Surname": "Kowalski",
        "Age": "20",
        "Phone Number": "783 123 382",
        "Date": "2022-10-31T01:30:00.000-05:00"
      }
    ]
  };
  List getDays(){
    return appointmentMap.keys.toList();
  }
  List getMonday(){
    return appointmentMap["Monday"];
  }
  List getTuesday(){
    return appointmentMap["Tuesday"];
  }
  List getWednesday(){
    return appointmentMap["Wednesday"];
  }
  List getThursday(){
    return appointmentMap["Thursday"];
  }
  List getFriday(){
    return appointmentMap["Friday"];
  }
  setAppointmentMap(map){
    assert(map != null);
    appointmentMap = map;
  }
  int length(){
    return appointmentMap.length;
  }
}
