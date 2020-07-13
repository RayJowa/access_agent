import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:access_agent/models/policy.dart';
import 'package:access_agent/models/user.dart';
import 'package:access_agent/services/database.dart';
import 'package:access_agent/shared/constants.dart';
import 'package:access_agent/shared/dialogues.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class AddPolicyEcocashPaymentView extends StatefulWidget {

  final Policy policy;
  AddPolicyEcocashPaymentView({this.policy});

  @override
  _AddPolicyEcocashPaymentViewState createState() => _AddPolicyEcocashPaymentViewState();
}

class _AddPolicyEcocashPaymentViewState extends State<AddPolicyEcocashPaymentView> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController _amountController = TextEditingController();
  TextEditingController _numberController = TextEditingController();

  String error = '';
  bool transactionSuccessful = false;
  bool confirmationPending = false;
  dynamic pollURL;

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
                        Text('Ecocash payment', style: Theme.of(context).textTheme.headline6,),
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
                          child: PageContent(transactionSuccessful, user.uid)
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

  Widget PageContent(bool transactionSuccessful, String uid) {
    if (transactionSuccessful) {
      return Successful();
    }else {
      if (confirmationPending) {
        return retryTransaction(uid: uid);
      }else {
        return CaptureDetails(uid: uid);
      }
    }
  }
  
  
  Widget CaptureDetails({String uid}) {
    return Form(
      key: _formKey,
        child: Column(
          children: <Widget>[
            Text(
              error,
              style: TextStyle(color: Colors.redAccent, fontSize: 18),
            ),
            SizedBox(height: 20,),
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
                hintText: '07XXXXXXXX',
              ),
              style: InputTextStyle.inputText2(context),
              keyboardType: TextInputType.phone,
              textAlign: TextAlign.right,
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
//                WhitelistingTextInputFormatter(RegExp(r'^07(7|8)\d{7}$'))
                WhitelistingTextInputFormatter.digitsOnly
              ],
              validator: (phone) {
                String pattern = r'^07(7|8)\d{7}$';
                RegExp regExp = RegExp(pattern);

                if (phone.length != 10) {
                  return 'Invalid phone number';
                } else if (!regExp.hasMatch(phone)) {
                  return 'Please enter a valid Ecocash number';
                } else {
                  return null;
                }
              },
            ),
            SizedBox(height: 20.0),
            FlatButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  Dialogs().paymentProcessing(context: context);

                  String transactionCode = "EC" + DateTime
                      .now()
                      .millisecondsSinceEpoch
                      .toString();
                  var url = 'http://rayzimnat.pythonanywhere.com/payment/';

                  Response response = await post(url, body: {
                    "payment_id": transactionCode,
                    "amount": _amountController.text,
                    "customer_number": _numberController.text,
                    "customer_email": "rayzimnat@gmail.com",
                    "description": "Test from flutter"
                  });

                  Map data = jsonDecode(response.body);
                  print(
                      "JASON DATA : O==O==O==O==O==O==O==O==O==O==O==O==O==O==O");
                  print(data);
                  print(data["status"]);

                  if (data['status'] == 'paid') {
                    recordReceipt(
                        uid: uid,
                        transactionCode: transactionCode,
                        externalID: data['paynow_reference']
                    );

                    setState(() {
                      transactionSuccessful = true;
                    });
                  } else if (data['status'] == 'sent') {
                    //TODO create ui with cancel and check status and cancel buttons
                    setState(() {
                      confirmationPending = true;
                      pollURL = data['url'];
                    });
                  } else {
                    setState(() {
                      error = data['status'];
                    });
                  }
                  Navigator.pop(context);
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
  
  Widget retryTransaction({String uid}) {
    return Column(
      children: <Widget>[
        Icon(
          Icons.sentiment_neutral,
          color: Color(0xFF094451),
          size: 80,
        ),
        SizedBox(height: 20,),
        Center(
          child: Text(
            'Transaction awaiting confirmation',
            style: TextStyle(
              fontSize: 24,
              color: Color(0xFF094451),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 25,),
        FlatButton(
          onPressed: () async {

            Dialogs().paymentProcessing(context: context);

            Response resp = await post(
                'http://rayzimnat.pythonanywhere.com/status/',
              body: {
                  "url":pollURL
              }
            );
            Map data = jsonDecode(resp.body);
            print("JASON DATA : mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
            print(data);

            Navigator.pop(context);

            if(data['status'] == 'paid') {
              recordReceipt(
                  uid: uid,
                  transactionCode: data['reference'],
                  externalID: data['paynow_reference']
              );

              setState(() {
                transactionSuccessful = true;
                confirmationPending = false;
              });
            } else if (data['status'] == 'sent') {

            } else {
              setState(() {
                confirmationPending = false;
                error = data['status'];
              });
            }
          },
          child: SizedBox(
            height: 50,
            width: 200,
            child: Center(
              child: Text(
                'Check again',
                style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.grey[200],
                    fontWeight: FontWeight.w700
                ),
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

          },
          child: SizedBox(
            height: 50,
            width: 200,
            child: Center(
              child: Text(
                'Cancel',
                style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.grey[200],
                    fontWeight: FontWeight.w700
                ),
              ),
            ),
          ),
          color: Colors.redAccent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          ),
        ),
        SizedBox(height: 20.0),
      ],
    );
  }

  void recordReceipt({
    String uid,
    String transactionCode,
    String externalID
  }) async {
    DatabaseService(uid: uid).createFirstDebit(widget.policy);

    DocumentReference rec = await DatabaseService().addReceipt(
      receiptID: transactionCode,
      externalID: externalID,
      policyID: widget.policy.policyID,
      paymentMethod: 'ecocash',
      amount: double.parse(_amountController.text),
      datePaid: DateTime.now(),
      dateRecorded: DateTime.now(),
      unmatchedAmount: double.parse(_amountController.text),
    );

    DatabaseService(uid: uid).match(policyID: widget.policy.policyID, receiptID: rec.documentID);

  }
}

