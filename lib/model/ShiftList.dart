import 'dart:ffi';

class ShiftList {
  Map shiftMap = {
    "Monday": [
      {
        "id": 16,
        "doctorName":"Bob",
        "doctorSurname":"Skalpel",
        "specialization":"Oncology",
        "room":"2",
        "shiftStart":"7:00",
        "shiftEnd":"14:00"
      }
    ],
    "Tuesday": [

    ],
    "Wednesday": [

    ],
    "Thursday": [

    ],
    "Friday": [

    ],
    "Saturday": [

    ]
  };
  List getDays(){
    return shiftMap.keys.toList();
  }
  List getMonday(){
    return shiftMap["Monday"];
  }
  List getTuesday(){
    return shiftMap["Tuesday"];
  }
  List getWednesday(){
    return shiftMap["Wednesday"];
  }
  List getThursday(){
    return shiftMap["Thursday"];
  }
  List getFriday(){
    return shiftMap["Friday"];
  }
  List getSaturday(){
    return shiftMap["Saturday"];
  }

  int length(){
    return shiftMap.length;
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
