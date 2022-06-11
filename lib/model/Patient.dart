class Patient extends Object{
  late int id;
  late String name;
  late String surname;
  late String telephoneNumber;
  late String dateOfRegister;
  // late String pesel;

  Patient(this.name, this.surname, this.telephoneNumber) {
    dateOfRegister = DateTime.now().toString();
  }
  Patient.withId(this.id,this.name,this.surname,this.telephoneNumber);
}
