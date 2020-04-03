import 'package:access_agent/models/policy.dart';
import 'package:access_agent/screens/add_policy/cash_payment_view.dart';
import 'package:flutter/material.dart';

class AddPolicyPaymentView extends StatefulWidget {

  final Policy policy;
  AddPolicyPaymentView(this.policy);
  @override
  _AddPolicyPaymentViewState createState() => _AddPolicyPaymentViewState();
}

class _AddPolicyPaymentViewState extends State<AddPolicyPaymentView> {

  List<Map> paymentMethods = [
    {
      'name': 'EcoCash',
      'image_url': ''
    },
    {
      'name': 'Cash',
      'image_url': ''
    },
    {
      'name': 'RTGS/Zipit',
      'image_url': ''
    },
    {
      'name': 'EcoCash1',
      'image_url': ''
    },
  ];

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
                      Text('Select payment method', style: Theme.of(context).textTheme.headline6,),
                    ],
                  ),

                )
            ),
            Positioned (
              top: 100,
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      physics: ScrollPhysics(),
                      child: Column(
                        children: <Widget>[
                          GridView.count(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            children:  <Widget>[
                              InkWell(
                                child: PaymentMethodCube(
                                  name: 'Cash',
                                  url: 'assets/images/bond.png',
                                ),
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddPolicyCashPaymentView(policy: widget.policy,)));
                                },
                              ),
                              InkWell(
                                child: PaymentMethodCube(
                                  name: 'Ecocash',
                                  url: 'assets/images/ecocash.png',
                                ),
                                onTap: () {
//                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddPolicyCashPaymentView(policy: widget.policy,)));
                                },
                              ),
                              InkWell(
                                child: PaymentMethodCube(
                                  name: 'SSB',
                                  url: 'assets/images/ssb.jpg',
                                ),
                                onTap: () {
//                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddPolicyCashPaymentView(policy: widget.policy,)));
                                },
                              ),
                              InkWell(
                                child: PaymentMethodCube(
                                  name: 'Other employer',
                                  url: 'assets/images/employer.png',
                                ),
                                onTap: () {
//                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddPolicyCashPaymentView(policy: widget.policy,)));
                                },
                              ),
                              InkWell(
                                child: PaymentMethodCube(
                                  name: 'Paynow',
                                  url: 'assets/images/paynow.png',
                                ),
                                onTap: () {
//                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddPolicyCashPaymentView(policy: widget.policy,)));
                                },
                              ),

                            ],

                          ),



                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0,),
                  FlatButton(

                    onPressed: () {
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
                  SizedBox(height: 10.0,),
                ],
              ),
            ),
          ],
        ),
      ),

    );
  }
}

class PaymentMethodCube extends StatelessWidget {

  final String url;
  final String name;
  PaymentMethodCube({this.name, this.url});


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7.0),
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Image.asset(
                    url,
                  ),
                ),
              ),

              Container(
                  color: Colors.grey[200],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          name,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}

