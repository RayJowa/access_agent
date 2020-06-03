import 'package:access_agent/services/auth.dart';
import 'package:access_agent/shared/constants.dart';
import 'package:access_agent/shared/loading.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String name ='';
  String surname = '';
  String phone = '';
  String email = '';
  String password = '';
  String pass2 = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.grey[300],
//      appBar: AppBar(
//        backgroundColor: Colors.blue,
//        elevation: 0.0,
//        title: Text('Register as agent'),
//        actions: <Widget>[
//          FlatButton.icon(
//              onPressed: () {
//                widget.toggleView();
//              },
//              icon: Icon(Icons.person),
//              label: Text('Sign in')
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
              left: 0,
              right: 0,
              bottom: 0,
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
                              FlatButton(
                                onPressed: () => widget.toggleView(),
                                color: Color(0xFF094451),
                                child: SizedBox(
                                  width: 110,
                                  height: 35,
                                  child: Center(
                                    child: Text(
                                      'Sign in',
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'Register',
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 12.0,),
                          TextFormField(
                            decoration: textInputDecorationLight.copyWith(
                                labelText: 'Name',
                                hintText: 'Name'
                            ),
                            style: InputTextStyle.inputText2(context),
                            validator: (val) => val.isEmpty ? 'Enter your name' : null,
                            onChanged: (val) {
                              setState(() {
                                name = val;
                                error = "";
                              });
                            },
                          ),
                          SizedBox(height: 12.0,),
                          TextFormField(
                            decoration: textInputDecorationLight.copyWith(
                                labelText: 'Surname',
                                hintText: 'Surname'
                            ),
                            style: InputTextStyle.inputText2(context),
                            validator: (val) => val.isEmpty ? 'Enter your surname' : null,
                            onChanged: (val) {
                              setState(() {
                                surname = val;
                                error = "";
                              });
                            },
                          ),
                          SizedBox(height: 12.0,),
                          TextFormField(
                            decoration: textInputDecorationLight.copyWith(
                                labelText: 'Phone',
                                hintText: '0770 000 000'
                            ),
                            style: InputTextStyle.inputText2(context),
                            validator: (val) => val.isEmpty ? 'Enter your phone number' : null,
                            onChanged: (val) {
                              setState(() {
                                phone = val;
                                error = "";
                              });
                            },
                          ),
                          SizedBox(height: 12.0,),
                          TextFormField(
                            decoration: textInputDecorationLight.copyWith(
                              labelText: 'Email',
                              hintText: 'Email'
                            ),
                            style: InputTextStyle.inputText2(context),
                            validator: (val) => val.isEmpty ? 'Enter an email' : null,
                            onChanged: (val) {
                              setState(() {
                                email = val;
                                error = "";
                              });
                            },
                          ),
                          SizedBox(height: 12.0,),
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
                              });
                            },
                          ),
                          SizedBox(height: 12.0,),
                          TextFormField(
                            decoration: textInputDecorationLight.copyWith(
                                labelText: 'Confirm password',
                                hintText: 'Confirm password'
                            ),
                            style: InputTextStyle.inputText2(context),
                            validator: (val) {
                              if (val.length < 6) {
                                return 'Enter at least 6 characters';
                              }else if (val != password) {
                                return 'Passwords do not match';
                              }
                            },
                            obscureText: true,
                            onChanged: (val) {
                              setState(() {
                                pass2 = val;
                              });
                            },
                          ),
                          SizedBox(height: 12.0,),
                          RaisedButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() => loading = true);
                                dynamic result = await _auth.registerWithEmail(
                                  firstName: name,
                                  surname: surname,
                                  phone: phone,
                                  email: email,
                                  password: password
                                );
                                if (result == null) {
                                  setState(() {
                                    error = 'Agent register failed';
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
                                    'Register',
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
                          ),
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
