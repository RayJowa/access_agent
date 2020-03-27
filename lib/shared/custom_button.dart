import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {

  final IconData icon;
  final String text;
  VoidCallback customOnPressed;
  CustomButton({this.icon, this.text, this.customOnPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: customOnPressed,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Row(
            children: <Widget>[
              Icon(icon, color: Colors.white,),
              Text(text, style: TextStyle(color: Colors.white),)
            ],
          ),
        ),
      ),
    );
  }
}
