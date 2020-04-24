import 'package:access_agent/models/policy.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({this.uid});

  //collection references
  final agentCollection = Firestore.instance.collection('agent');
  final citiesCollection = Firestore.instance.collection('cities');
  final debitsCollection = Firestore.instance.collection('debits');
  final doctorsCollection = Firestore.instance.collection('doctor');
  final policyCollection = Firestore.instance.collection('policy');
  final receiptsCollection = Firestore.instance.collection('receipts');
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

  Future<DocumentSnapshot> getAgentData() {
    return  agentCollection.document(uid).get();
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
    //TODO: consider getting user once and passing details between views
    DocumentSnapshot agent = await agentCollection.document(uid).get();

    agentCollection.document(uid).updateData({
      'totalPolicies': FieldValue.increment(1)
    });



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


  getPolicies({int perPage, DocumentSnapshot startAfter, String surname, String idNumber}) async {

    Query q;
    String endSurname = surname + 'z';
    String endID = idNumber + 'z';

    if (startAfter == null) {
      q = policyCollection
          .where('surname', isGreaterThanOrEqualTo: surname)
          .where('surname', isLessThanOrEqualTo: endSurname)
          .where('idNumber', isGreaterThanOrEqualTo: idNumber)
          .where('idNumber', isLessThanOrEqualTo: endID)
          .orderBy('surname')
          .limit(perPage);
    }else{
      q = policyCollection
          .where('surname', isGreaterThanOrEqualTo: surname)
          .where('surname', isLessThanOrEqualTo: endSurname)
          .where('idNumber', isGreaterThanOrEqualTo: idNumber)
          .where('idNumber', isLessThanOrEqualTo: endID)
          .orderBy('surname')
          .startAfterDocument(startAfter)
          .limit(perPage);
    }

    QuerySnapshot query = await q.getDocuments();
    return query;

  }

  Future getPolicy(policyID)async {
    return await Firestore.instance.document('/policy/$policyID').get();
  }

  Future addReceipt ({
    String receiptID,
    String policyID,
    String paymentMethod,
    double amount,
    DateTime datePaid,
    DateTime dateRecorded,
    List match,
    double unmatchedAmount
  }) async {

    return receiptsCollection.add({
      'receiptID': receiptID,
      'policyID': policyID,
      'paymentMethod': paymentMethod,
      'amount': amount,
      'datePaid': datePaid,
      'dateRecorded': dateRecorded,
      'match': match,
      'unmatchedAmount': unmatchedAmount
    });
  }



  Future createFirstDebit(Policy policy) async {
    //Check if policy has any existing debit and create one if not.
    var debit = await debitsCollection.where('policyID', isEqualTo: policy.policyID).limit(1).getDocuments();

    if (debit.documents.length == 0) {
      debitsCollection.add({
        'debitDate': DateTime.now(),
        'amount': policy.basicPremium + policy.joiningFee + policy.chronicAddOn,
        'policyID': policy.policyID,
        'balance': policy.basicPremium + policy.joiningFee + policy.chronicAddOn,
        'notes': 'Policy inception',
        'match': null
      });

      agentCollection.document(uid).updateData({
        'activePolicies': FieldValue.increment(1)
      });
    }
  }

  void match({String policyID, String receiptID}) async {

//    try {
      QuerySnapshot debitsList = await debitsCollection
          .where('policyID', isEqualTo: policyID)
          .where('balance', isGreaterThan: 0)
          .getDocuments();

      debitsList.documents.sort((a,b) {
        var adate = a.data['debitDate'];
        var bdate = b.data['debitDate'];
        return bdate.compareTo(adate);
      });
      
      DocumentSnapshot rates = await Firestore.instance.document('/apportionment/rates').get();


      for (DocumentSnapshot debit in debitsList.documents) {

        DocumentSnapshot receipt = await receiptsCollection.document(receiptID)
            .get();

        if (debit.data['balance'] <= receipt.data['unmatchedAmount']) {
          
          // debit amount is smaller than available credit, therefore, debit should be fully paid
          double matchAmount = debit.data['balance'].toDouble();
          double agentCommission = (rates.data['agent'] * debit.data['amount']).toDouble();

          //record match entry in debit
          Map debitMatch = {
            'receiptID': receipt.documentID,
            'amount': matchAmount,
            'matchDate': DateTime.now()
          };
    
          //record match entry in receipt 
          Map receiptMatch = {
            'debitID': debit.documentID,
            'amount': matchAmount,
            'matchDate': DateTime.now()
          };

          //calculate new unmatched balance after matching
          double newReceiptUnmatched = receipt.data['unmatchedAmount'].toDouble() - matchAmount;

          //update transaction to receipt database
          receiptsCollection.document(receipt.documentID).updateData({
            'match': FieldValue.arrayUnion([receiptMatch]),
            'unmatchedAmount': newReceiptUnmatched
          });

          //update transaction to debit in database 
          debitsCollection.document(debit.documentID).updateData({
            'match': FieldValue.arrayUnion([debitMatch]),
            'balance': 0
          });
          
          //debit is now fully paid, therefor update agent commission due
          agentCollection.document(uid).updateData({
            'commissionDue': FieldValue.increment(agentCommission),
            'monthCommission': FieldValue.increment(agentCommission),
          });

          //get current commission
          

        }else{
          double matchAmount = receipt.data['unmatchedAmount'];

          double newBalance = debit.data['balance'] - matchAmount;

          Map debitMatch = {
            'receiptID': receipt.documentID,
            'amount': matchAmount,
            'matchDate': DateTime.now()
          };

          Map receiptMatch = {
            'debitID': debit.documentID,
            'amount': matchAmount,
            'matchDate': DateTime.now()
          };

          receiptsCollection.document(receipt.documentID).updateData({
            'match': FieldValue.arrayUnion([receiptMatch]),
            'unmatchedAmount': 0
          });

          debitsCollection.document(debit.documentID).updateData({
            'match': FieldValue.arrayUnion([debitMatch]),
            'balance': newBalance
          });


          break;
        }
      }
//    }catch(e) {
//      print('=======================================');
//      print(e.toString());
//      print('========================================');
//
//    }
  }

  void test() async {

  }
}

