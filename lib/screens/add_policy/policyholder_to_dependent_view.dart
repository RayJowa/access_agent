import 'package:access_agent/models/dependent.dart';
import 'package:access_agent/models/policy.dart';
import 'package:access_agent/screens/add_policy/doctor_view.dart';
import 'package:access_agent/shared/constants.dart';
import 'package:flutter/material.dart';

class PolicyholderToDependantView extends StatefulWidget {

  final Policy policy;
  final Dependent dependent;

  PolicyholderToDependantView({this.policy, this.dependent});

  @override
  _PolicyholderToDependantViewState createState() => _PolicyholderToDependantViewState();
}

class _PolicyholderToDependantViewState extends State<PolicyholderToDependantView> {

  TextEditingController _doctorController = TextEditingController();
  int _selectedPackage = 0;
  List packages = ['Bronze', 'Gold', 'Diamond'];
  String docId;

  @override
  void initState() {
    super.initState();
    widget.dependent.package = 'Bronze';
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
                        Text('Select options', style: Theme.of(context).textTheme.headline6,),
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
                          margin: EdgeInsets.symmetric(vertical: 9.0, horizontal: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                          child: Form(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                        border: Border.all(
                                          color: Colors.grey[400],
                                        )
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text('  Select package',
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.normal,
                                              fontSize: 20.0
                                          ),),
                                        Theme(
                                          data: Theme.of(context).copyWith(canvasColor: Colors.transparent ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: List.generate(packages.length, (index) {
                                              return ChoiceChip(
                                                label: Text(
                                                  packages[index],
                                                  style: TextStyle(
                                                      fontSize: 20.0,
                                                      color: Colors.grey[600]
                                                  ),
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(color: Colors.grey[400]),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                backgroundColor: Colors.transparent,
                                                avatar: CircleAvatar(
                                                  backgroundColor: Colors.grey[400],
                                                  child: Text(packages[index][0]),
                                                ),
                                                selectedColor: Color(0xFF094451),
                                                selected: _selectedPackage == index,
                                                onSelected: (selected) {
                                                  if (selected) {
                                                    setState(() {
                                                      _selectedPackage = index;
                                                      widget.dependent.package = packages[index];
                                                    });
                                                  }
                                                },
                                              );
                                            }),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 20.0,),

                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                        border: Border.all(
                                          color: Colors.grey[900],
                                        )
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text('Additional options',
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.normal,
                                              fontSize: 20.0
                                          ),
                                        ),
                                        Theme(
                                          data: Theme.of(context).copyWith(canvasColor: Colors.transparent ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              InputChip(
                                                padding: EdgeInsets.all(6.0),
                                                avatar: CircleAvatar(
                                                  backgroundColor: Colors.grey[400],
                                                  child: Text('J'),
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(color: Colors.grey[400]),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                label: Text('Joining fee',
                                                  style: TextStyle(
                                                      fontSize: 20.0,
                                                      color: Colors.grey[600]
                                                  ),
                                                ),
                                                selected: widget.dependent.joiningFee,
                                                backgroundColor: Colors.transparent,
                                                selectedColor: Color(0xFF094451),
                                                onSelected: (bool selected) {
                                                  setState(() {
                                                    widget.dependent.joiningFee = selected;
                                                  });
                                                },
                                              ),
                                              InputChip(
                                                padding: EdgeInsets.all(6.0),
                                                avatar: CircleAvatar(
                                                  backgroundColor: Colors.grey[400],
                                                  child: Text('C'),
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(color: Colors.grey[400]),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                label: Text('Chronic add-on',
                                                  style: TextStyle(
                                                      fontSize: 20.0,
                                                      color: Colors.grey[600]
                                                  ),
                                                ),
                                                selected: widget.dependent.chronicAddOn,
                                                backgroundColor: Colors.transparent,
                                                selectedColor: Color(0xFF094451),
                                                onSelected: (bool selected) {
                                                  setState(() {
                                                    widget.dependent.chronicAddOn = selected;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 20.0,),

                                  TextFormField(
                                    controller: _doctorController,
                                    decoration: textInputDecorationLight.copyWith(
                                        labelText: 'Choose a doctor',
                                        hintText: 'Choose a doctor'
                                    ),
                                    style: InputTextStyle.inputText2(context),
                                    onTap:() async {
                                      dynamic result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddPolicyDoctorView()));

                                      setState(() {
                                        _doctorController.text = result['docName'];
                                        docId = result['docId'];
                                      });

                                    },
                                  ),



                                ],
                              )
                          ),
                        ),
                        SizedBox(height: 20.0),
                        FlatButton(
                          onPressed: () {

                            Map doctor = {
                              'name': _doctorController.text,
                              'docid': docId
                            };

                            widget.dependent.doctor = doctor;

                            Navigator.pop(context, widget.dependent);

                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 80.0),
                            child: Text(
                              'Save',
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
