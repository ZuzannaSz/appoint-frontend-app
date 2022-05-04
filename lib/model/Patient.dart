class Patient {
  late String name;
  late String surname;
  late String pNumber;
  late DateTime dateOfRegister;

  Patient(this.name, this.surname) {
    dateOfRegister = DateTime.now();
  }
}
