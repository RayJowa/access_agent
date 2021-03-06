
class Dependent {
  String firstName;
  String surname;
  String gender;
  String idNumber;
  DateTime dob;
  Map doctor;
  String package;
  bool joiningFee;
  double joiningFeeAmount;
  bool chronicAddOn;
  double chronicAddOnAmount;
  double monthlyPremium;

  Dependent ({
    this.firstName,
    this.surname,
    this.gender,
    this.idNumber,
    this.dob,
    this.doctor,
    this.package,
    this.joiningFee : false,
    this.joiningFeeAmount : 0,
    this.chronicAddOn : false,
    this.chronicAddOnAmount : 0,
    this.monthlyPremium : 0
  });

  Map toMap() {
    return {
      'firstName': this.firstName,
      'surname': this.surname,
      'gender': this.gender,
      'idNumber': this.idNumber,
      'dob': this.dob,
      'doctor': this.doctor,
      'package': this.package,
      'joiningFee': this.joiningFee,
      'joiningFeeAmount': this.joiningFeeAmount,
      'chronicAddOn': this.chronicAddOn,
      'chronicAddOnAmount': this.chronicAddOnAmount,
      'monthlyPremium': this.monthlyPremium
    };
  }
}

Dependent dependentFromFirebaseData(dependant) {
  return Dependent(
    firstName: dependant['firstName'],
    surname: dependant['surname'],
    gender: dependant['gender'],
    idNumber: dependant['idNumber'],
    dob: dependant['dob'].toDate(),
    doctor: dependant['doctor'],
    package: dependant['package'],
    joiningFee: dependant['joiningFee'],
    joiningFeeAmount: dependant['joiningFeeAmount'],
    chronicAddOn: dependant['chronicAddOn'],
    chronicAddOnAmount: dependant['chronicAddOnAmount'],
    monthlyPremium: dependant['monthlyPremium']
  );
}