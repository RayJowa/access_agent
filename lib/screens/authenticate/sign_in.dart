import 'package:access_agent/services/auth.dart';
import 'package:access_agent/shared/loading.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.lightBlue[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0.0,
        title: Text('Sign in'),
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () {
                widget.toggleView();
              },
              icon: Icon(Icons.person), 
              label: Text('Register')
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0,),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                validator: (val) => val.length < 6 ? 'Enter at least 6 characters' : null,
                onChanged: (val) {
                  setState(() {
                    email = val;
                    error = '';
                  });
                },
              ),
              SizedBox(height: 20.0,),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password'
                ),
                validator: (val) => val.length < 6 ? 'Enter at least 6 characters' : null,
                obscureText: true,
                onChanged: (val) {
                  setState(() {
                    password = val;
                    error = '';
                  });
                },
              ),
              SizedBox(height: 20.0,),
              RaisedButton(
                color: Colors.green,
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    setState(() => loading = true);
                    dynamic result = await _auth.signInWithEmail(email, password);
                    if (result == null) {
                      setState(() {
                        error = 'Sign in failed';
                        loading = false;
                      });
                    }
                  }
                },
                child: Text(
                  'Sign in',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 12.0,),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              )
            ],
          ),
        )
      ),
    );
  }
}
