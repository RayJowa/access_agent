import 'package:access_agent/models/user.dart';
import 'package:access_agent/screens/authenticate/authenticate.dart';
import 'package:access_agent/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    final user = Provider.of<User>(context);

    //return home or authenticate widget
    if (user == null) {
      return Authenticate();
    }else {
      return Home();
    }
  }
}
