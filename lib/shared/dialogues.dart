
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Dialogs {
  paymentProcessing({BuildContext context}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)
          ),
          child: Container(
            height: 150,
            width: 280,
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
                      'Processing payment',
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
                  padding: EdgeInsets.only(top: 10.0),
                  child: Center(
                    child: SpinKitRipple(
                      color: Color(0xFF094451),
                      size: 80.0,
                    ),
                  ),

                )
              ],
            ),
          ),

        );
      }

    );

}
}