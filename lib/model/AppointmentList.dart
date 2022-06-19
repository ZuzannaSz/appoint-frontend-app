class AppointmentList {
  Map appointmentMap = {
    "Monday": [],
    "Tuesday": [],
    "Wednesday": [],
    "Thursday": [],
    "Friday": []
  };

  List getDays() {
    return appointmentMap.keys.toList();
  }

  List getMonday() {
    return appointmentMap["Monday"];
  }

  List getTuesday() {
    return appointmentMap["Tuesday"];
  }

  List getWednesday() {
    return appointmentMap["Wednesday"];
  }

  List getThursday() {
    return appointmentMap["Thursday"];
  }

  List getFriday() {
    return appointmentMap["Friday"];
  }

  List getSaturday() {
    return appointmentMap["Saturday"];
  }

  List getSunday() {
    return appointmentMap["Sunday"];
  }

  setAppointmentMap(map) {
    assert(map != null);
    appointmentMap = map;
  }

  int length() {
    return appointmentMap.length;
  }

  List getDay(int weekday) {
    switch (weekday) {
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
