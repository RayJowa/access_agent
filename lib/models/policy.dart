
import 'package:access_agent/models/dependent.dart';
import 'package:access_agent/models/previous_med_aid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Policy {

  String policyID;
  String title;
  String firstName;
  String surname;
  String gender;
  String idNumber;
  String phone;
  DateTime dob;
  String email;
  Map <String, String> address;
  String doctor;
  List<Dependent> dependents;
  PreviousMedAid previousMedAid;
  double basicPremium;
  double joiningFee;
  double chronicAddOn;

  Policy ({
    this.policyID,
    this.title,
    this.firstName,
    this.surname,
    this.gender,
    this.idNumber,
    this.phone,
    this.email,
    this.dob ,
    this.address,
    this.doctor,
    this.dependents,
    this.previousMedAid,
    this.basicPremium : 0.0,
    this.joiningFee : 0.0,
    this.chronicAddOn : 0.0
  });

}

Policy policyFromFirebaseData(DocumentSnapshot policy) {

  List <Dependent> dependentList = [];
  for (var dependent in policy.data['dependents']) {
    dependentList.add(dependentFromFirebaseData(dependent));
  }

  return Policy(
    policyID: policy.reference.documentID,
    title: policy.data['title'],
    firstName: policy.data['firstName'],
    surname: policy.data['surname'],
    gender: policy.data['gender'],
    idNumber: policy.data['idNumber'],
    phone: policy.data['phone'],
    email: policy.data['email'],
    dob: policy.data['dob'].toDate(),
    address: policy.data['address'],
    doctor: policy.data['doctor'],
    dependents: dependentList,
    previousMedAid: previousMedAidFromFirebaseData(policy.data['previous med aid']),
    basicPremium: policy.data['basicPremium'],
    joiningFee: policy.data['joiningFee'],
    chronicAddOn: policy.data['chronicAddOn']
  );
}