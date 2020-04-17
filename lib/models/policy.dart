
import 'package:access_agent/models/dependent.dart';
import 'package:access_agent/models/previous_med_aid.dart';

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
    this.basicPremium,
    this.joiningFee,
    this.chronicAddOn
  });

}