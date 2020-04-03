import 'package:access_agent/models/dependent.dart';
import 'package:access_agent/models/policy.dart';
import 'package:access_agent/models/user.dart';
import 'package:access_agent/screens/add_policy/payment_view.dart';
import 'package:access_agent/services/database.dart';
import 'package:access_agent/shared/constants.dart';
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
                        Text('Premium summary', style: Theme.of(context).textTheme.headline6,),
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                           // padding: EdgeInsets.all(21),
                            child: Container(
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 15.0,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Row(
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(5),
                                          child: Icon(
                                            Icons.monetization_on,
                                            size: 35.0,
                                            color: Color(0xFF46737c),
                                          ),
                                        ),
                                        SizedBox(width: 15.0,),
                                        Text(
                                          'Premium due now',
                                          style: Theme.of(context).textTheme.headline5.copyWith(color: Color(0xFF46737c)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Basic premium',
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.grey[400],
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                            Text(
                                              widget.policy.basicPremium.toString(),
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                color: Colors.grey[400],
                                              ),
                                            )
                                          ],

                                        ),
                                        SizedBox(height: 10.0,),
                                        Row(
                                          children: <Widget>[
                                            Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Joining fee',
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.grey[400],
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                            Text(
                                              widget.policy.joiningFee.toString(),
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                color: Colors.grey[400],
                                              ),
                                            )
                                          ],

                                        ),
                                        SizedBox(height: 10.0,),
                                        Row(
                                          children: <Widget>[
                                            Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Chronic add-on',
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.grey[400],
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                            Text(
                                              widget.policy.chronicAddOn.toString(),
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                color: Colors.grey[400],
                                              ),
                                            )
                                          ],

                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10.0,),
                                  Container(
                                    padding:EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                                    color: Color(0xFF46737c),
                                    child: Row(
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Total premium',
                                            style: InputTextStyle.inputText1(context).copyWith(
                                              fontSize: 18.0,
                                              color: Colors.grey[300],
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        Text(
                                          '${(widget.policy.basicPremium + widget.policy.joiningFee + widget.policy.chronicAddOn).toString()}',
                                          style: InputTextStyle.inputText1(context),
                                        )
                                      ],

                                    ),
                                  )



                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 9.0, horizontal: 21.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            // padding: EdgeInsets.all(21),
                            child: Container(
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 15.0,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Row(
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(5),
                                          child: Icon(
                                            Icons.monetization_on,
                                            size: 35.0,
                                            color: Colors.grey[400],
                                          ),
                                        ),
                                        SizedBox(width: 15.0,),
                                        Text(
                                          'Monthly premium',
                                          style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.grey[400]),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Basic premium',
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.grey[400],
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                            Text(
                                              widget.policy.basicPremium.toString(),
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                color: Colors.grey[400],
                                              ),
                                            )
                                          ],

                                        ),
                                        SizedBox(height: 10.0,),
                                        Row(
                                          children: <Widget>[
                                            Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Chronic add-on',
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.grey[400],
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                            Text(
                                              widget.policy.chronicAddOn.toString(),
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                color: Colors.grey[400],
                                              ),
                                            )
                                          ],

                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 15.0,),
                                  Container(
                                    padding:EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                                    color: Colors.grey[400],
                                    child: Row(
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Total premium',
                                            style: InputTextStyle.inputText1(context).copyWith(
                                              fontSize: 18.0,
                                              color: Colors.grey[300],
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        Text(
                                          '${(widget.policy.basicPremium + widget.policy.chronicAddOn).toString()}',
                                          style: InputTextStyle.inputText1(context),
                                        )
                                      ],

                                    ),
                                  )



                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0,),
                        FlatButton(

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

                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 80.0),
                            child: Text(
                              'Save policy',
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
                        ),
                        SizedBox(height: 10.0,),
                        FlatButton(

                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>AddPolicyPaymentView(widget.policy) ));
                          },

                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 37.0),
                            child: Text(
                              'Proceed to payment',
                              style: TextStyle(
                                  fontSize: 25.0,
                                  color: Color(0xFF094451),
                                  fontWeight: FontWeight.w700
                              ),
                            ),
                          ),
                          color: Colors.grey[200],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                      ],
                    ),

                  ),
                ),
              ),
            ],
          ),

      ),
    );
  }
}





//        FlatButton.icon(
//            onPressed: () {
//
//              Policy _policy = widget.policy;
//
//              //Convert dependent objects into a list for saving to firebase
//              List _dependentList = [];
//
//              for (Dependent dependant in _policy.dependents ) {
//                _dependentList.add(dependant.toMap());
//              }
//
//              //save data to firebase
//              DatabaseService(uid: user.uid).addPolicy(
//                  title: _policy.title,
//                  firstName: _policy.firstName ,
//                  surname: _policy.surname,
//                  gender: _policy.gender,
//                  dob: _policy.dob,
//                  idNumber: _policy.idNumber,
//                  phone: _policy.phone,
//                  email: _policy.email,
//                  dependants: _dependentList,
//                  previousMedAid: widget.policy.previousMedAid.toMap(),
//                  doctor: _policy.doctor
//              );
//
//              Navigator.of(context).popUntil((route) => route.isFirst);
//
//            },
//            icon: Icon(Icons.done_outline),
//            label: Text('Save policy')
//        ),
