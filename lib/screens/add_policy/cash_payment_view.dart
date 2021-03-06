import 'package:access_agent/models/policy.dart';
import 'package:access_agent/models/user.dart';
import 'package:access_agent/services/database.dart';
import 'package:access_agent/services/sms.dart';
import 'package:access_agent/shared/constants.dart';
import 'package:access_agent/shared/dialogues.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddPolicyCashPaymentView extends StatefulWidget {

  final Policy policy;
  AddPolicyCashPaymentView({this.policy});

  @override
  _AddPolicyCashPaymentViewState createState() => _AddPolicyCashPaymentViewState();
}

class _AddPolicyCashPaymentViewState extends State<AddPolicyCashPaymentView> {

  TextEditingController _amountController = TextEditingController();

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
                        Text('Cash payment', style: Theme.of(context).textTheme.headline6,),
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
                          child: Form(
                              child: Column(
                                children: <Widget>[
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

                              ],
                              )
                          ),
                        ),
                        SizedBox(height: 20.0),
                        FlatButton(
                          onPressed: () async {

                            Dialogs().paymentProcessing(context: context);
                            String transactionCode = "CA" + DateTime
                                .now()
                                .millisecondsSinceEpoch
                                .toString();
                            
                            DatabaseService(uid: user.uid).createFirstDebit(widget.policy);

                            DocumentReference rec = await DatabaseService().addReceipt(
                              receiptID: transactionCode,
                              externalID: 'cash',
                              policyID: widget.policy.policyID,
                              paymentMethod: 'cash',
                              amount: double.parse(_amountController.text),
                              datePaid: DateTime.now(),
                              dateRecorded: DateTime.now(),
                              unmatchedAmount: double.parse(_amountController.text)
                            );

                            Sms(
                              number: widget.policy.phone,
                              message: "Premium received. \nYour receipt number is $transactionCode, \nAmount ${_amountController.text}"
                            ).sendSms();

                            DatabaseService(uid: user.uid).match(policyID: widget.policy.policyID, receiptID: rec.documentID);

                            Navigator.pop(context);
                          },
 
                          child: SizedBox(
                            height: 50,
                            width: 200,
                            child: Center(
                              child: Text(
                                'Pay',
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
