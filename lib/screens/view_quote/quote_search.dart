import 'package:access_agent/models/user.dart';
import 'package:access_agent/screens/view_policy/policy_detail.dart';
import 'package:access_agent/screens/view_policy/policy_list.dart';
import 'package:access_agent/screens/view_quote/quote_list.dart';
import 'package:access_agent/services/database.dart';
import 'package:access_agent/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class ViewQuoteSearchView extends StatefulWidget {
  @override
  _ViewQuoteSearchViewState createState() => _ViewQuoteSearchViewState();
}

class _ViewQuoteSearchViewState extends State<ViewQuoteSearchView> {

//  TextEditingController _policyNumberController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _IDController = TextEditingController();

  String errorText = '';

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

//    String barcode = '';
    Future scanBarcode() async {
      String barcode = await scanner.scan();
      return barcode;
    }

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
                            'Search Quotation',
                            style: Theme.of(context).textTheme.headline4.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                            overflow: TextOverflow.fade,
                          ),
                        ),
                        Divider(height: 20,),
                        Text('Enter quotation details', style: Theme.of(context).textTheme.headline6,),
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
//                                  TextFormField(
//                                    controller: _policyNumberController,
//                                    decoration: textInputDecorationLight.copyWith(
//                                      labelText: 'Policy number',
//                                      hintText: 'Policy number',
//                                    ),
//                                    style: InputTextStyle.inputText2(context),
//                                  ),
//                                  SizedBox(height: 20.0,),
                                  TextFormField(
                                    controller: _surnameController,
                                    textCapitalization: TextCapitalization.characters,
                                    decoration: textInputDecorationLight.copyWith(
                                      labelText: 'Surname',
                                      hintText: 'Surname',
                                    ),
                                    style: InputTextStyle.inputText2(context),
                                  ),
                                  SizedBox(height: 20.0,),
                                  TextFormField(
                                    controller: _IDController,
                                    textCapitalization: TextCapitalization.characters,
                                    decoration: textInputDecorationLight.copyWith(
                                      labelText: 'ID Number',
                                      hintText: 'ID Number',
                                    ),
                                    style: InputTextStyle.inputText2(context),
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
                                MaterialPageRoute(builder: (BuildContext context) => ViewQuoteListView(
                                  surname: _surnameController.text.toUpperCase() ?? '',
                                  idNumber: _IDController.text.toUpperCase() ?? '',
                                  agentID: user.uid,
                                ))
                            );
                          },

                          child: SizedBox(
                            width: 200,
                            height: 60,
                            child: Center(
                              child: Text(
                                'Search',
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
                        SizedBox(height: 20,),
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
