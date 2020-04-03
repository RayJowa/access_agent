
import 'package:access_agent/models/dependent.dart';
import 'package:access_agent/models/policy.dart';
import 'package:access_agent/screens/add_policy/add_dependent_view.dart';
import 'package:access_agent/screens/add_policy/doctor_view.dart';
import 'package:access_agent/screens/add_policy/previous_medical_aid_view.dart';
import 'package:access_agent/services/database.dart';
import 'package:access_agent/shared/constants.dart';
import 'package:access_agent/shared/custom_button.dart';
import 'package:access_agent/shared/loading.dart';
import 'package:access_agent/shared/slide_left.dart';
import 'package:access_agent/shared/slide_right.dart';
import 'package:flutter/cupertino.dart';
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
      backgroundColor: Theme.of(context).accentColor,

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
                widget.policy.basicPremium = policyTotal;

                joiningFee = widget.policy.dependents.fold(0, (p, e) => p + e.joiningFeeAmount);
                widget.policy.joiningFee = joiningFee;

                chronicAddOn = widget.policy.dependents.fold(0, (p, e) => p + e.chronicAddOnAmount);
                widget.policy.chronicAddOn = chronicAddOn;


              }
              return SafeArea(
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 0,
                      right: 0,
                      left: 0,
                      child: DependentViewSummary(
                        policy: widget.policy,
                        netTotal: policyTotal,
                        joiningFee: joiningFee,
                        chronicAddOn: chronicAddOn,
                        customOnPressed: () async {

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
                      ),
                    ),
                    Positioned(
                      top: 165,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: SingleChildScrollView(
                          physics: ScrollPhysics(),
                          child: Column(
                            children: <Widget>[
                              ListView.builder(
                                        itemCount: widget.policy.dependents.length,
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (BuildContext context, int index) {
                                          return Dismissible(
                                            key: Key(index.toString()),
                                            child: DependantCard(
                                              index: index,
                                              dependent: widget.policy.dependents[index],
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
                                                              style: TextStyle(color: Color(0xFF094451), fontWeight: FontWeight.w700),
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
                              InkWell (
                                onTap: () async {

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
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 21.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  padding: EdgeInsets.all(12),
                                  child: Row(
                                    children: <Widget>[
                                      Material(
                                        color: Colors.white,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            shape: BoxShape.circle,
                                          ),
                                          child: IconButton(
                                            icon: Icon(Icons.add),
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
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 21,
                                      ),
                                      Text(
                                        "Add dependent",
                                        style: Theme.of(context).textTheme.subtitle1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Divider(),
                              FlatButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>
                                          AddPolicyPreviousMedicalAidView(policy: widget
                                              .policy,))
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




//                    Column(
//                      children: <Widget>[
//

//                      ]
//                  ),
                  ],
                ),
              );
            } else {
              return Loading();
            }
          }
      ) ,

    );

  }

}


class DependentViewSummary extends StatefulWidget {
  Policy policy;
  double netTotal;
  double joiningFee;
  double chronicAddOn;
  VoidCallback customOnPressed;

  DependentViewSummary({
    this.policy,
    this.netTotal,
    this.joiningFee,
    this.chronicAddOn,
    this.customOnPressed
  });

  @override
  _DependentViewSummaryState createState() => _DependentViewSummaryState();
}

class _DependentViewSummaryState extends State<DependentViewSummary> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      //color: Theme.of(context).primaryColor,
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
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${widget.policy.firstName} ${widget.policy.surname}',
                  style: Theme.of(context).textTheme.headline4.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Divider(),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text('Net premium', style: Theme.of(context).textTheme.subtitle1,),
                      SizedBox(height: 6.0,),
                      Text('\$${widget.netTotal}', style: Theme.of(context).textTheme.headline5,),
                    ],
                  ),
                  Column(

                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Joining fee -', style: TextStyle(color: Colors.white,),),
                          Text(' \$${widget.joiningFee.toString()}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),)
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Chronic add-on -', style: TextStyle(color: Colors.white,),),
                          Text(
                            ' \$${widget.chronicAddOn.toString()}',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                          )
                        ],
                      )
                    ],
                  )

                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Dependents', style: Theme.of(context).textTheme.headline6,),
                  CustomButton(
                    text: 'Add',
                    icon: Icons.add,
                    customOnPressed: widget.customOnPressed,

                  ),

                ],
              ),
            ],
          ),
          SizedBox(height: 30,)
        ],
      ),
    );
  }
}


class DependantCard extends StatefulWidget {
  final int index;
  final Dependent dependent;

  DependantCard({
    this.index,
    this.dependent
  });


  @override
  _DependantCardState createState() => _DependantCardState();
}

class _DependantCardState extends State<DependantCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          showDialog(
              context:context,
              builder: (BuildContext context) {
                return Dialog(

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)
                  ),
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13.0),
                      ),
                      height: 300.0,
                      width: 300.0,
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            height: 50,
                            alignment: Alignment.bottomCenter,
                            decoration: BoxDecoration(
                              color: Color(0xFF094451),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12)
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                '${widget.dependent.firstName} ${widget.dependent.surname}' ?? '',
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding:EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                            child: Row(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Date of birth',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  DateFormat.yMMMMd("en_US").format(widget.dependent.dob) ?? '',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700]
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding:EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                            color: Colors.grey[100],
                            child: Row(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'ID Number',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  widget.dependent.idNumber ?? '',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700]
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding:EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                            child: Row(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Gender',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  widget.dependent.gender ?? '',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700]
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding:EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                            color: Colors.grey[100],
                            child: Row(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Doctor',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  widget.dependent.doctor['name'] ?? '',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700]
                                  ),
                                  overflow: TextOverflow.fade,
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding:EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                            child: Row(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Basic premium',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  widget.dependent.monthlyPremium.toString() ?? '',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700]
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding:EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                            color: Colors.grey[100],
                            child: Row(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Chronic add-on',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  widget.dependent.chronicAddOnAmount.toString() ?? '0.00',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700]
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding:EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                            child: Row(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Joining fee',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  widget.dependent.joiningFeeAmount.toString() ?? '0.00',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700]
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ) ,

                );
              }
          );
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 9.0, horizontal: 21.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: EdgeInsets.all(21),
          child: Container(
            width: double.infinity,
            child: Row(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Image.asset('assets/images/${widget.dependent.package.toLowerCase()}.png'),
                ),
                SizedBox(width: 10,),
                Flexible(
                  flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${widget.dependent.firstName} ${widget.dependent.surname}',
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          '${widget.dependent.idNumber} | ${DateFormat.yMMMd("en_US").format(widget.dependent.dob)}',
                          style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 14.0),
                        ),
                      ],
                    ),
                ),
                SizedBox(width: 10,),
                Flexible(
                  flex: 2,
                  child: Column(
                    children: <Widget>[
                      Text(
                        '\$${widget.dependent.monthlyPremium}',
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: TextStyle(fontSize: 18.0, ),
                      ),
                      Text(
                        'J:\$${widget.dependent.joiningFeeAmount} | C:\$${widget.dependent.chronicAddOnAmount}',
                        style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 14.0),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,

                      ),
                    ],
                  ),

                ),
              ],
            ),
          ),
        ),

      );
  }
}


