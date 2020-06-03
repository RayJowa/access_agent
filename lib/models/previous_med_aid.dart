class PreviousMedAid {
  String name;
  String package;
  String number;
  DateTime joined;
  DateTime terminated;

  PreviousMedAid({
    this.name,
    this.package,
    this.number,
    this.joined,
    this.terminated
  });

  Map toMap() {
    return {
      'name': this.name,
      'package': this.package,
      'number': this.number,
      'joined': this.joined,
      'termination': this.terminated
    };
  }
}

PreviousMedAid previousMedAidFromFirebaseData(previousMedAid) {

  DateTime dateJoined;
  DateTime dateTerminated;

  try {
    dateJoined =  previousMedAid['joined'].toDate();
  } catch(e) {
    dateJoined = null;
  }

  try {
    dateTerminated =  previousMedAid['terminated'].toDate();
  } catch(e) {
    dateTerminated = null;
  }

  return PreviousMedAid(
    name: previousMedAid['name'],
    package: previousMedAid['package'],
    number: previousMedAid['number'],
    joined: dateJoined,
    terminated: dateTerminated
  );
}

