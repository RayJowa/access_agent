import 'package:access_agent/models/user.dart';
import 'package:access_agent/screens/authenticate/authenticate.dart';
import 'package:access_agent/screens/wrapper.dart';
import 'package:access_agent/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        title: 'Acces Agent',
        theme: ThemeData(
          fontFamily: 'Quicksand',
          buttonColor: Color(0xff68d69d),
          primaryColor: Color(0xFF094451),
          accentColor: Color(0xffcdd2de),
          textTheme: TextTheme(
            headline5: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            subtitle1: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w200,
              color: Color(0xff8c92a5),
            ),
            headline6: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w100,
              color: Colors.white,
              letterSpacing: 1.3,
            )

          ),
        ),

        home: Wrapper(),
      ),
    );
  }
}
