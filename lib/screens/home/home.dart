import 'package:access_agent/screens/add_policy/policyholder_view.dart';
import 'package:access_agent/screens/home/agent_list.dart';
import 'package:access_agent/services/auth.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text('Access'),
        backgroundColor: Colors.blue,
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () async {
                await _auth.signOut();
              },
              icon: Icon(Icons.person),
              label: Text('Logout')
          ),
        ],
      ),
      body: AgentList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddPolicyPolicyholderView())
          );
        }, 
        child: Icon(Icons.add), 

      ),
    );
  }
}
