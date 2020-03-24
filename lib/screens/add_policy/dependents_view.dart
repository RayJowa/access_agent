import 'dart:io';

import 'package:access_agent/models/dependent.dart';
import 'package:access_agent/models/policy.dart';
import 'package:access_agent/screens/add_policy/add_dependent_view.dart';
import 'package:access_agent/screens/add_policy/doctor_view.dart';
import 'package:access_agent/screens/add_policy/previous_medical_aid_view.dart';
import 'package:access_agent/services/database.dart';
import 'package:access_agent/shared/loading.dart';
import 'package:access_agent/shared/slide_left.dart';
import 'package:access_agent/shared/slide_right.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddPolicyDependentsView extends StatefulWidget {

  final Policy policy;

  AddPolicyDependentsView({this.policy});



  @override
  _AddPolicyDependentsViewState createState() => _AddPolicyDependentsViewState();
}

class _AddPolicyDependentsViewState extends State<AddPolicyDependentsView> {

  final dynamic packages = DatabaseService().getPackages();
  double policyTotal = 0;
  double realPolicyTotal = 0;
  double chronicAddOn = 0;
  double joiningFee = 0;


  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add dependants',
          style: TextStyle(
              color: Colors.grey[700],
              fontSize: 25,
              fontWeight: FontWeight.w500
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.grey[100],
        elevation: 0,
      ),
      body: FutureBuilder(

          future: packages,
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              if (widget.policy.dependents.length > 0) {
                //check if all dependants are on the same plan

                bool uniformPlan
                = widget.policy.dependents.length
                    == widget.policy.dependents
                        .where((dep) =>
                    dep.package == widget.policy.dependents[0].package)
                        .toList()
                        .length;

                //Set individual premiums for each dependant
                widget.policy.dependents.forEach((e) {

                  e.monthlyPremium = snapshot.data[e.package.toLowerCase()]['individual'].toDouble();

                  if (e.chronicAddOn) {
                    e.chronicAddOnAmount =
                        snapshot.data[e.package.toLowerCase()]['chronic']
                            .toDouble();
                  }

                  if (e.joiningFee) {
                    e.joiningFeeAmount = snapshot.data[e.package
                        .toLowerCase()]['joining_individual'].toDouble();
                  }

                });


                //Totals based in individual rating
                policyTotal = widget.policy.dependents.fold(
                    0, (p, c) => p + c.monthlyPremium);

                joiningFee = widget.policy.dependents.fold(0, (p, e) => p + e.joiningFeeAmount);

                chronicAddOn = widget.policy.dependents.fold(0, (p, e) => p + e.chronicAddOnAmount);



                if (uniformPlan) { //if dependants are on the same plan, 6 pack and 10pack may apply

                  double familyPrice = snapshot.data[
                    widget.policy.dependents[0].package.toLowerCase()
                  ]['family'].toDouble();

                  double familyJoining = snapshot.data[widget.policy.dependents[0].package.toLowerCase()]['joining_family'].toDouble();

                  if (widget.policy.dependents.length <= 6) { //if less that 6, possibly apply group 6 rate


                    if (policyTotal > familyPrice ) { //where total premium(charged individually) is less than group premium
                      widget.policy.dependents.forEach((e) {
                        e.monthlyPremium = (familyPrice / widget.policy.dependents.length).toDouble();
                      });
                    }

                    if (joiningFee > familyJoining) {
                      widget.policy.dependents.forEach((element) {
                        element.joiningFeeAmount = (familyJoining / widget.policy.dependents.length).toDouble();
                      });
                    }


                  }else{ //if more than 6, check if less than 10

                    if (widget.policy.dependents.length <= 10) { //if less that 10 check if corporate rate applicable
                      double corporatePrice = snapshot.data[
                          widget.policy.dependents[0].package.toLowerCase()
                          ]['corporate'].toDouble();

                      double corporateJoining = snapshot.data[
                        widget.policy.dependents[0].package.toLowerCase()
                      ]['joining_corporate'].toDouble();

                      if (policyTotal > corporatePrice ) {
                        widget.policy.dependents.forEach((e) {
                          e.monthlyPremium = (corporatePrice / widget.policy.dependents.length).toDouble();
                        });
                      }

                      if (joiningFee > corporateJoining) {
                        widget.policy.dependents.forEach((element) {
                          element.monthlyPremium = (corporateJoining / widget.policy.dependents.length).toDouble();
                        });
                      }
                    }
                  }

                }

                policyTotal = widget.policy.dependents.fold(
                    0, (p, c) => p + c.monthlyPremium);

                joiningFee = widget.policy.dependents.fold(0, (p, e) => p + e.joiningFeeAmount);

                chronicAddOn = widget.policy.dependents.fold(0, (p, e) => p + e.chronicAddOnAmount);
              }
              return Column(
                  children: <Widget>[
                    Flexible(
                      child: ListView.builder(
                          itemCount: widget.policy.dependents.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Dismissible(
                              key: Key(index.toString()),
                              child: InkWell(
                                onTap: () {
                                  showDialog(
                                    context:context,
                                    builder: (BuildContext context) {
                                      return SimpleDialog(
                                        title: Text('${widget.policy.dependents[index].firstName} ${widget.policy.dependents[index].surname}'),
                                        children: <Widget>[
                                          Text('Date of birth - ${DateFormat.yMMMMd("en_US").format(widget.policy.dependents[index].dob)}'),
                                          Text('ID Number - ${widget.policy.dependents[index].idNumber}'),
                                          Text('Gender - ${widget.policy.dependents[index].gender}'),
                                          Text('Doctor - ${widget.policy.dependents[index].doctor['name']}'),
                                          Text('Basic premium - ${widget.policy.dependents[index].monthlyPremium.toString()}')
                                        ],
                                      );
                                    }
                                  );
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0)
                                  ),
                                  elevation: 1,
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.amberAccent,
                                      backgroundImage: AssetImage('assets/images/${widget.policy.dependents[index].package.toLowerCase()}.png'),
                                    ),
                                    title: Text('${widget.policy.dependents[index]
                                        .firstName} ${widget.policy
                                        .dependents[index].surname}'),
                                    subtitle: Text(
                                        '${widget.policy.dependents[index]
                                            .idNumber}  DOB ${widget.policy
                                            .dependents[index].dob.toLocal()
                                            .toString()}'),
                                    trailing: Text(
                                        '\$${widget.policy.dependents[index]
                                            .monthlyPremium}'),
                                  ),
                                ),
                              ),
                              background: slideRightBackground(),
                              secondaryBackground: slideLeftBackground(),
                              confirmDismiss: (direction) async {
                                if (direction == DismissDirection.endToStart) {
                                  final bool res = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text('Are you sure you want to remove'),
                                            Text(
                                              '${widget.policy.dependents[index].firstName} ${widget.policy.dependents[index].surname}',
                                              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w700),
                                            )
                                          ],
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(color: Colors.grey[800]),
                                              ),
                                          ),
                                          FlatButton(
                                              onPressed: () {
                                                setState(() {
                                                  widget.policy.dependents.removeAt(index);
                                                });
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                'Delete',
                                                style: TextStyle(color: Colors.red),
                                              )
                                          )
                                        ],
                                      );

                                    }
                                  );
                                  return res;
                                }else{

                                  dynamic result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => AddPolicyAddDependentView(dep: widget.policy.dependents[index],))
                                  );

                                  if (result != null) {
                                    setState(() {
                                      widget.policy.dependents[index] = result;
                                    });
                                  }

                                  return null;
                                }
                              },
                            );
                          }
                      ),
                    ),
                    SizedBox(height: 20.0,),
                    Text('Net - ${policyTotal.toString()}, Join - ${joiningFee.toString()}, Chronic - ${chronicAddOn.toString()}'),

                    FlatButton.icon(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  AddPolicyPreviousMedicalAidView(policy: widget
                                      .policy,))
                          );
                        },
                        icon: Icon(Icons.navigate_next),
                        label: Text('Next')
                    )
                  ]
              );
            } else {
              return Loading();
            }
          }
      ) ,


      
      floatingActionButton: FloatingActionButton(
        onPressed: () async {

          dynamic result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddPolicyAddDependentView())
          );

          if (result != null) {
            setState(() {
              widget.policy.dependents.add(result);
            });
          }

        },
        child: Icon(Icons.add),

      ),
    );

  }

}
