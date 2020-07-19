import 'package:access_agent/models/dependent.dart';
import 'package:access_agent/models/policy.dart';
import 'package:access_agent/screens/add_policy/dependents_view.dart';
import 'package:access_agent/screens/add_policy/payment_view.dart';
import 'package:access_agent/screens/view_policy/view_card.dart';
import 'package:access_agent/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QuoteDetailView extends StatefulWidget {

  final policy;
  QuoteDetailView({this.policy,});

  @override
  _QuoteDetailViewState createState() => _QuoteDetailViewState();
}

class _QuoteDetailViewState extends State<QuoteDetailView> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: PolicySummary(
                  policy: widget.policy
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
                        itemCount: widget.policy.data['dependents'].length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: <Widget>[
                              DependantCard(
                                index: index,
                                dependent: dependentFromFirebaseData(widget.policy.data['dependents'][index]),

                              ),
                            ],
                          );
                        }
                    ),
                  ],
                ),
              ),
            ),





          ],
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>AddPolicyPaymentView(policyFromFirebaseData(widget.policy)) ));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.attach_money,
                      size: 25,
                      color: Colors.grey,
                    ),
                    Text(
                      'Make payment',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16
                      ),

                    )
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.edit,
                    size: 25,
                    color: Colors.grey,
                  ),
                  Text(
                    'Edit',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PolicySummary extends StatelessWidget {

  final DocumentSnapshot policy;
  PolicySummary({this.policy});

  @override
  Widget build(BuildContext context) {

    double monthlyPremium = policy.data['dependents'].fold(
      0, (p, c) => p + c['monthlyPremium'].toDouble()
    );

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
                  '${policy.data['firstName']} ${policy.data['surname']}',
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
                      Text('Monthly premium', style: Theme.of(context).textTheme.subtitle1,),
                      SizedBox(height: 6.0,),
                      Text('\$$monthlyPremium', style: Theme.of(context).textTheme.headline5,),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,

                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Inception date ',
                            style: InputTextStyle.smallLabels(context).copyWith(color: Colors.grey[400]),
                          ),
                          Text(
                            customDateFromTimestamp(policy.data['inceptionDate']),
                            style: InputTextStyle.labels2(context),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Next premium due ',
                            style: InputTextStyle.smallLabels(context).copyWith(color: Colors.grey[400]),
                          ),
                          Text(
                            customDateFromTimestamp(policy.data['nextDueDate']),
                            style: InputTextStyle.labels2(context),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Account balance ',
                            style: InputTextStyle.smallLabels(context).copyWith(color: Colors.grey[400]),
                          ),
                          Text(
                            NumberFormats().currencyFormat.format(
                              policy.data['accountBalance']
                            ) ?? '0',
                            style: InputTextStyle.labels2(context),
                          ),
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

String customDateFromTimestamp(date) {
  try{
    return DateFormat.yMMMd("en_US").format(date.toDate());
  }catch(e){
    return '-';
  }

}

