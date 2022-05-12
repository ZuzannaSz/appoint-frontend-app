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
      },
      {
        "Name": "Bobby",
        "Surname": "Burger",
        "Age": "25",
        "Phone Number": "743 123 382",
        "Date": "2022-10-31T01:30:00.000-05:00"
      },
      {
        "Name": "Bat",
        "Surname": "Man",
        "Age": "999",
        "Phone Number": "743 123 382",
        "Date": "2022-10-31T01:30:00.000-05:00"
      }
    ],
    "Tuesday": [
      {
        "Name": "Bob",
        "Surname": "Marley",
        "Age": "20",
        "Phone Number": "783 123 382",
        "Date": "2022-10-31T02:30:00.000-05:00"
      },
      {
        "Name": "Indiana",
        "Surname": "Jones",
        "Age": "20",
        "Phone Number": "783 123 382",
        "Date": "2022-10-31T02:30:00.000-05:00"
      }
    ],
    "Wednesday": [
      {
        "Name": "Angelina",
        "Surname": "Joline",
        "Age": "20",
        "Phone Number": "783 123 382",
        "Date": "2022-10-31T03:30:00.000-05:00"
      }
    ],
    "Thursday": [
      {
        "Name": "Jan",
        "Surname": "Kowalski",
        "Age": "20",
        "Phone Number": "783 123 382",
        "Date": "2022-10-31T04:30:00.000-05:00"
      },
      {
        "Name": "Dobry",
        "Surname": "Ziomek",
        "Age": "20",
        "Phone Number": "783 123 382",
        "Date": "2022-10-31T04:30:00.000-05:00"
      }
    ],
    "Friday": [
      {
        "Name": "Jan",
        "Surname": "Kowalski",
        "Age": "20",
        "Phone Number": "783 123 382",
        "Date": "2022-10-31T05:30:00.000-05:00"
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

  List getDay(int weekday) {
    switch(weekday){
      case 0:
        return getMonday();
      case 1:
        return getTuesday();
      case 2:
        return getWednesday();
      case 3:
        return getThursday();
      case 4:
        return getFriday();
      default:
        return getMonday();
    }

  }
}
