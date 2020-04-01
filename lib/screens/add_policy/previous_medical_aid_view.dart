import 'package:access_agent/models/policy.dart';
import 'package:access_agent/screens/add_policy/doctor_view.dart';
import 'package:access_agent/screens/add_policy/summary_view.dart';
import 'package:access_agent/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      backgroundColor: Theme.of(context).accentColor,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                height: 160,
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 21.0),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/background.png'),
                        fit: BoxFit.cover
                    )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FittedBox(
                      child: Text(
                        '${widget.policy.firstName} ${widget.policy.surname}',
                        style: Theme.of(context).textTheme.headline4.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    Divider(height: 20,),
                    Text('Previous medical aid', style: Theme.of(context).textTheme.headline6,),
                  ],
                ),

              )
            ),
            Positioned (
              top: 100,
              bottom: 0,
              left: 0,
              right: 0,
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 9.0, horizontal: 21.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: EdgeInsets.all(21),
                        child: Form(
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  controller: _medAidNameController,
                                  decoration: textInputDecorationLight.copyWith(
                                    labelText: 'Name',
                                    hintText: 'Name',
                                  ),
                                  style: InputTextStyle.inputText2(context),
                                ),
                                SizedBox(height: 20.0,),
                                TextFormField(
                                  controller: _medAidPackageController,
                                  decoration: textInputDecorationLight.copyWith(
                                    labelText: 'Package/Scheme',
                                    hintText: 'Package/Scheme',
                                  ),
                                  style: InputTextStyle.inputText2(context),
                                ),
                                SizedBox(height: 20.0,),
                                TextFormField(
                                  controller: _medAidNumberController,
                                  decoration: textInputDecorationLight.copyWith(
                                    labelText: 'Membership number',
                                    hintText: 'Membership number',
                                  ),
                                  style: InputTextStyle.inputText2(context),
                                ),
                                SizedBox(height: 20.0,),
                                TextFormField(
                                  controller: _medAidJoinedController,
                                  decoration: textInputDecorationLight.copyWith(
                                    labelText: 'Date joined',
                                    hintText: 'Date joined',
                                  ),
                                  style: InputTextStyle.inputText2(context),
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
                                        _medAidJoinedController.text = DateFormat.yMMMMd('en_US').format(date);
                                      });
                                    }
                                    );
                                  },
                                ),
                                SizedBox(height: 20.0,),
                                TextFormField(
                                  controller: _medAidTerminatedController,
                                  decoration: textInputDecorationLight.copyWith(
                                    labelText: 'Date of termination',
                                    hintText: 'Date of termination',
                                  ),
                                  style: InputTextStyle.inputText2(context),
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
                                        _medAidTerminatedController.text = DateFormat.yMMMMd('en_US').format(date);
                                      });
                                    }
                                    );
                                  },
                                ),
                                SizedBox(height: 20.0,),

                              ],
                            )
                        ),
                      ),
                      SizedBox(height: 20.0),
                      FlatButton(
                          onPressed: () {

                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AddPolicySummaryView(policy: widget.policy,))

                            );
                          },

                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 80.0),
                            child: Text(
                              'Next',
                              style: TextStyle(
                                  fontSize: 25.0,
                                  color: Colors.grey[200],
                                  fontWeight: FontWeight.w700
                              ),
                            ),
                          ),
                        color: Color(0xFF094451),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                      )
                    ],
                  ),

                ),
              ),
            ),
          ],
        )
      ),


    );
  }
}
