import 'package:flutter/material.dart';

var textInputDecoration = InputDecoration(
  fillColor: Colors.transparent,

  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(
      color: Color(0xFF085762)
    ),
      ),

  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(
      color: Colors.white
    )
  ),

  hintStyle: TextStyle(
    color: Colors.grey[600],
    fontWeight: FontWeight.normal
  ),

  labelStyle: TextStyle(
    color: Colors.grey[600],
    fontWeight: FontWeight.normal,
    fontSize: 20.0
  ),
);


var textInputDecorationLight = textInputDecoration.copyWith(
  focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
          color: Color(0xFF094451)
      )
  ),

);


class InputTextStyle {

  static TextStyle inputText1(BuildContext context) {
    return Theme.of(context).textTheme.headline5;
  }

  static TextStyle inputText2(BuildContext context) {
    return Theme.of(context).textTheme.headline5.copyWith(color: Colors.grey[600]);
  }
}

