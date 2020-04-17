import 'dart:math';

import 'package:access_agent/models/policy.dart';
import 'package:access_agent/services/database.dart';
import 'package:access_agent/shared/constants.dart';
import 'package:access_agent/shared/dialogues.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddPolicySSBPaymentView extends StatefulWidget {

  final Policy policy;
  AddPolicySSBPaymentView({this.policy});

  @override
  _AddPolicySSBPaymentViewState createState() => _AddPolicySSBPaymentViewState();
}

class _AddPolicySSBPaymentViewState extends State<AddPolicySSBPaymentView> {

  TextEditingController _amountController = TextEditingController();
  TextEditingController _numberController = TextEditingController();

  String error = '';
  bool transactionSuccessful = false;

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
                    height: 220,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text('Premium due', style: Theme.of(context).textTheme.subtitle1,),
                                SizedBox(height: 6.0,),
                                Text('\$${(widget.policy.basicPremium + widget.policy.joiningFee + widget.policy.chronicAddOn).toString()}', style: Theme.of(context).textTheme.headline5,),
                              ],
                            ),
                          ],
                        ),
                        Divider(height: 20,),
                        Text('SSB payment', style: Theme.of(context).textTheme.headline6,),
                      ],
                    ),

                  )
              ),
              Positioned (
                top: 170,
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
                          child: PageContent(transactionSuccessful)
                        ),

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

  Widget PageContent(bool transactionSuccessful) {
    if (transactionSuccessful) {
      return Successful();
    }else {
      return CaptureDetails();
    }
  }
  
  
  Widget CaptureDetails() {
    return Form(
        child: Column(
          children: <Widget>[
            Text(
              error,
              style: TextStyle(color: Colors.redAccent, fontSize: 14),
            ),
            SizedBox(height: 10,),
            TextFormField(
              controller: _amountController,
              decoration: textInputDecorationLight.copyWith(
                labelText: 'Amount',
                hintText: 'Enter amount',
              ),
              style: InputTextStyle.inputText2(context),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.right,
            ),
            SizedBox(height: 20,),
            TextFormField(
              controller: _numberController,
              decoration: textInputDecorationLight.copyWith(
                labelText: 'Phone number',
                hintText: 'Phone number',
              ),
              style: InputTextStyle.inputText2(context),
              keyboardType: TextInputType.phone,
              textAlign: TextAlign.right,
            ),
            SizedBox(height: 20.0),
            FlatButton(
              onPressed: () async {
                Dialogs().paymentProcessing(context: context);
                await Future.delayed(Duration(seconds: 3));
                Navigator.pop(context);
                final random = Random();

                if (random.nextBool()) {
                  
                  String code = 'ECO' + (random.nextInt(900000) + 100000).toString();

                  await DatabaseService().addReceipt(
                    receiptID: code,
                    policyID: widget.policy.policyID,
                    paymentMethod: 'SSB',
                    amount: double.parse(_amountController.text),
                    datePaid: DateTime.now(),
                    dateRecorded: DateTime.now(),
                    unmatchedAmount: double.parse(_amountController.text),
                  );

                  setState(() {
                    transactionSuccessful = true;
                  });

                }else {
                  setState(() {
                    error = 'Transaction failed';
                  });
                }
              },

              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 80.0),
                child: Text(
                  'Pay',
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
        )
    );
  }

  Widget Successful() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.check_circle_outline,
                color: Color(0xFF094451),
                size: 80,
              ),
              SizedBox(height: 20,),
              Text(
                'Transaction successful',
                style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFF094451),
                ),
              ),
              SizedBox(height: 40.0),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 80.0),
                  child: Text(
                    'Done',
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
              SizedBox(height: 20.0),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                  child: Text(
                    'Another payment',
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
            ],
          ),
        ],
      );
  }
}

