class Patient {
  late int id;
  late String name;
  late String surname;
  late String telephoneNumber;
  late DateTime dateOfRegister;
  // late String pesel;

  Patient(this.name, this.surname, this.telephoneNumber) {
    dateOfRegister = DateTime.now();
  }
}
