import 'package:access_agent/models/policy.dart';
import 'package:access_agent/screens/add_policy/doctor_view.dart';
import 'package:access_agent/screens/add_policy/summary_view.dart';
import 'package:flutter/material.dart';

class AddPolicyPreviousMedicalAidView extends StatefulWidget {

  final Policy policy;
  AddPolicyPreviousMedicalAidView({Key key, this.policy});

  @override
  _AddPolicyPreviousMedicalAidViewState createState() => _AddPolicyPreviousMedicalAidViewState();
}

class _AddPolicyPreviousMedicalAidViewState extends State<AddPolicyPreviousMedicalAidView> {

  TextEditingController _medAidNameController = TextEditingController();
  TextEditingController _medAidPackageController = TextEditingController();
  TextEditingController _medAidNumberController = TextEditingController();
  TextEditingController _medAidJoinedController = TextEditingController();
  TextEditingController _medAidTerminatedController = TextEditingController();

  @override
  void dispose() {
    _medAidNameController.dispose();
    _medAidPackageController.dispose();
    _medAidNumberController.dispose();
    _medAidJoinedController.dispose();
    _medAidTerminatedController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _medAidNameController.addListener(() => widget.policy.previousMedAid.name = _medAidNameController.text);
    _medAidNumberController.addListener(() => widget.policy.previousMedAid.package = _medAidPackageController.text);
    _medAidNumberController.addListener(() => widget.policy.previousMedAid.number= _medAidNumberController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
            'Previous medical aid',
          style: TextStyle(color: Colors.grey[600], fontSize: 25.0),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Form(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _medAidNameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  TextFormField(
                    controller: _medAidPackageController,
                    decoration: InputDecoration(
                      labelText: 'Package/Scheme',
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  TextFormField(
                    controller: _medAidNumberController,
                    decoration: InputDecoration(
                      labelText: 'Membership Number',
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  TextFormField(
                    controller: _medAidJoinedController,
                    decoration: InputDecoration(
                      labelText: 'Date joined',
                    ),
                    readOnly: true,
                    onTap: () {
                      showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(DateTime.now().year - 20),
                          lastDate: DateTime.now()
                      ).then((date) {
                        setState(() {
                          widget.policy.previousMedAid.joined = date;
                          _medAidJoinedController.text = date.toString();
                        });
                      }
                      );
                    },
                  ),
                  SizedBox(height: 20.0,),
                  TextFormField(
                    controller: _medAidTerminatedController,
                    decoration: InputDecoration(
                      labelText: 'Date of termination',
                    ),
                    readOnly: true,
                    onTap: () {
                      showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(DateTime.now().year - 20),
                          lastDate: DateTime.now()
                      ).then((date) {
                        setState(() {
                          widget.policy.previousMedAid.terminated = date;
                          _medAidTerminatedController.text = date.toString();
                        });
                      }
                      );
                    },
                  ),
                  SizedBox(height: 20.0,),
                  FlatButton.icon(
                    onPressed: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddPolicySummaryView(policy: widget.policy,))

                      );
                    },
                    icon: Icon(Icons.navigate_next),
                    label: Text('Next')
                  )
                ],
              )
          ),

        ),
      ),
    );
  }
}
