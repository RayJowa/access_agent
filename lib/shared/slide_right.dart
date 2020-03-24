import 'package:flutter/material.dart';

Widget slideRightBackground() {
  return Container(
    color: Colors.grey,
    child: Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(width: 20.0,),
          Icon(
            Icons.edit,
            color: Colors.grey[100],
          ),
          Text(
              'Edit',
            style: TextStyle(
              color: Colors.grey[100],
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    ),

  );
}