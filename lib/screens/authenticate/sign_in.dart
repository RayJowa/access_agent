import 'package:access_agent/services/auth.dart';
import 'package:access_agent/shared/loading.dart';
import 'package:access_agent/shared/constants.dart';
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
      backgroundColor: Colors.grey[300],
//      appBar: AppBar(
//        backgroundColor: Colors.blue,
//        elevation: 0.0,
//        title: Text('Sign in'),
//        actions: <Widget>[
//          FlatButton.icon(
//              onPressed: () {
//                widget.toggleView();
//              },
//              icon: Icon(Icons.person),
//              label: Text('Register')
//          )
//        ],
//      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                height: 280,
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 21.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/background.png'),
                    fit: BoxFit.cover
                  )
                ),
                child: Container(
                  margin: EdgeInsets.only(bottom: 54),
                  child: Image(
                    image: AssetImage('assets/images/access_logo.png'),
                    height: 180,
                    fit: BoxFit.contain,

                  ),
                ),
                
              )
            ),
            Positioned(
            top: 200,
            bottom: 0,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 9.0, horizontal: 21.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0)
                ),
                padding: EdgeInsets.all(21),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Center(
                              child: Text(
                                'Sign in',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          FlatButton(
                            onPressed: () => widget.toggleView(),
                            color: Color(0xFF094451),
                            child: SizedBox(
                              width: 110,
                              height: 35,
                              child: Center(
                                child: Text(
                                  'Register',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),

                      SizedBox(height: 20.0,),
                      TextFormField(
                        decoration: textInputDecorationLight.copyWith(
                          labelText: 'Email',
                          hintText: 'Email'
                        ),
                        style: InputTextStyle.inputText2(context),
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
                        decoration: textInputDecorationLight.copyWith(
                          labelText: 'Password',
                          hintText: 'Password'
                        ),
                        style: InputTextStyle.inputText2(context),
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
                        child: SizedBox(
                          width: 200,
                          height: 40,
                          child: Center(
                            child: Text(
                              'Sign in',
                              style: TextStyle(
                                  fontSize: 25.0,
                                  color: Colors.grey[200],
                                  fontWeight: FontWeight.w700
                              ),
                            ),
                          ),
                        ),
                        color: Color(0xFF094451),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
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
            ),
          ),
          ]
        ),
      ),
    );
  }
}
