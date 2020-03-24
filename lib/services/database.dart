import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({this.uid});

  //collection references
  final agentCollection = Firestore.instance.collection('agent');
  final policyCollection = Firestore.instance.collection('policy');
  final citiesCollection = Firestore.instance.collection('cities');
  final doctorsCollection = Firestore.instance.collection('doctor');
  final suburbsCollection = Firestore.instance.collection('suburbs');


  //update or create agent data
  Future updateAgentData(
      String firstName,
      String surname,
      String city,
      String phone
      ) async {
    return await agentCollection.document(uid).setData({
      'firstName': firstName,
      'surname': surname,
      'city': city,
      'phone': phone
    });
  }

  //get agents
   Future getAgents() async{
    QuerySnapshot agents =  await agentCollection.getDocuments();

    return agents.documents;
  }

  //get cities
  Future getCities() async {
        return await citiesCollection.document('cities').get();
  }


  //get suburbs
  Future getSuburbs(city) {
    var document = citiesCollection.document(city).get();
//
//    Future<List> suburbs = document.get().then((document) {
//      List list = document.data['suburbs'];
//      return list;
//    });
//
    return document;
  }

  //get single suburb
  Future getSuburb(suburbID) {
    try {
      return suburbsCollection.document(suburbID).get();
    }catch(e) {
      return null;
    }
  }


  //get doctors
  Future getDoctors({city, suburb}) {
    return doctorsCollection.where('suburb', isEqualTo: suburb).getDocuments();
  }

  //get packages and prices
  Future getPackages() async {
    return await Firestore.instance.document('/pricing/pricing').get();
  }


  //create new policy
  Future addPolicy({
    String title,
    String firstName,
    String surname,
    String gender,
    String idNumber,
    String phone,
    DateTime dob,
    String email,
    Map <String, String> address,
    List dependants,
    String doctor,
    Map previousMedAid,
  }) async {
    DocumentSnapshot agent = await agentCollection.document(uid).get();
    return await policyCollection.add({
      'title' : title,
      'firstName' : firstName,
      'surname' : surname,
      'gender' : gender,
      'idNumber' : idNumber,
      'phone' : phone,
      'dob': dob,
      'email': email,
      'address' : address,
      'dependents': dependants,
      'doctor': doctor,
      'previous med aid': previousMedAid,
      'dateCreated': DateTime.now(),
      'agentID': uid,
      'Agent Name': '${agent.data['firstName']} ${agent.data['surname']}'
    });
  }


}