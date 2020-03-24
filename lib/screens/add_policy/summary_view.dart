import 'package:access_agent/models/dependent.dart';
import 'package:access_agent/models/policy.dart';
import 'package:access_agent/models/user.dart';
import 'package:access_agent/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddPolicySummaryView extends StatefulWidget {

  final Policy policy;
  AddPolicySummaryView({this.policy});

  @override
  _AddPolicySummaryViewState createState() => _AddPolicySummaryViewState();
}


class _AddPolicySummaryViewState extends State<AddPolicySummaryView> {

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    return Scaffold(
      body: Container(
        child: FlatButton.icon(
            onPressed: () {

              Policy _policy = widget.policy;

              //Convert dependent objects into a list for saving to firebase
              List _dependentList = [];

              for (Dependent dependant in _policy.dependents ) {
                _dependentList.add(dependant.toMap());
              }

              //save data to firebase
              DatabaseService(uid: user.uid).addPolicy(
                  title: _policy.title,
                  firstName: _policy.firstName ,
                  surname: _policy.surname,
                  gender: _policy.gender,
                  dob: _policy.dob,
                  idNumber: _policy.idNumber,
                  phone: _policy.phone,
                  email: _policy.email,
                  dependants: _dependentList,
                  previousMedAid: widget.policy.previousMedAid.toMap(),
                  doctor: _policy.doctor
              );

              Navigator.of(context).popUntil((route) => route.isFirst);

            },
            icon: Icon(Icons.done_outline),
            label: Text('Save policy')
        ),
      ),
    );
  }
}
