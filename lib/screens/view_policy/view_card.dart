import 'package:access_agent/models/dependent.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DisplayCardView extends StatefulWidget {

  final String policyID;
  final Dependent dependent;
  DisplayCardView({this.dependent, this.policyID});

  @override
  _DisplayCardViewState createState() => _DisplayCardViewState();
}

class _DisplayCardViewState extends State<DisplayCardView> {

  static GlobalKey screen = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFCAEDFC),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RepaintBoundary(
              key: screen,

              child: SizedBox(
                width: 380,
                height: 600,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.png'),
                          fit: BoxFit.cover
                      )
                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                          top: 0,
                          right: 0,
                          left: 0,
                          child: Container(
                            height: 180,
                            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 21.0),
                            decoration: BoxDecoration(

                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical:12.0),
                                      child: Image(
                                          image: AssetImage('assets/images/logo.png'),
                                        width: 200,

                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),

                          )
                      ),
                      Positioned (
                        top: 236,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                height: 320,
                                margin: EdgeInsets.symmetric(vertical: 9.0, horizontal: 21.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(22.0),
                                ),
                                padding: EdgeInsets.all(21),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(height: 60,),
                                    Text(
                                      widget.dependent.surname.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      widget.dependent.firstName,
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    Divider(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          'ID Number: ',

                                        ),
                                        Text(
                                          widget.dependent.idNumber,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700
                                          ),
                                        )
                                      ],
                                    ),
                                    Divider(),
                                    Row(
                                      children: <Widget>[
                                        QrImage(
                                          data: widget.policyID,
                                          size: 110 ,
                                        ),
                                        VerticalDivider(),
                                        Expanded(
                                          child: Column(


                                            children: <Widget> [
                                              Text(
                                                'Doctor ',

                                              ),
                                              Text(
                                                widget.dependent.doctor['name'],
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w700
                                                ),
                                              ),
                                              SizedBox(height: 16,),
                                              Text(
                                                'Package',

                                              ),
                                              Text(
                                                widget.dependent.package ?? 'TBA',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w700
                                                ),
                                              )


                                            ]
                                          ),
                                        )
                                      ],

                                    )


                                  ],
                                ),
                              ),
                              ],
                          ),

                        ),
                      ),
                      Positioned (
                        top: 170,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Container(

                                width: double.infinity,
                                height: 140,
                                margin: EdgeInsets.symmetric(vertical: 9.0, horizontal: 110.0),
                                decoration: BoxDecoration(
                                  border: Border.all(width: 5,
                                  color: Colors.white),
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(18.0),
                                  boxShadow:[ BoxShadow(
                                    offset: Offset(3, 3),
                                    blurRadius: 3.0,
                                    spreadRadius: 3.0,
                                    color: Color(0x30444444),
                                  )]
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.person,
                                    size: 120,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),

                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF46737c),
        foregroundColor: Colors.white,
        child: Icon(Icons.share),
        onPressed: screenshot,
      ),
    );
  }

  screenshot () async {
    RenderRepaintBoundary boundary = screen.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage(pixelRatio: 5);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    await Share.file('card', 'card.png', byteData.buffer.asUint8List(), 'image/png');

  }
}
