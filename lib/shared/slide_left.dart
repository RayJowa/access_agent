import 'package:flutter/material.dart';

Widget slideLeftBackground() {
  return Container(
    color: Colors.redAccent,
    child: Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Icon(
            Icons.delete_outline,
            color: Colors.grey[100],
          ),
          Text(
            'Delete',
            style: TextStyle(
              color: Colors.grey[100],
              fontWeight: FontWeight.w700
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(width: 20.0,)
        ],
      ),
    ),
  );
}