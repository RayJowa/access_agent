import 'package:access_agent/models/user.dart';
import 'package:access_agent/screens/add_policy/policyholder_view.dart';
import 'package:access_agent/services/auth.dart';
import 'package:access_agent/services/database.dart';
import 'package:access_agent/shared/app_drawer.dart';
import 'package:access_agent/shared/custom_button.dart';
import 'package:access_agent/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();



  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    final GlobalKey<ScaffoldState> _scafoldKey = GlobalKey<ScaffoldState>();

//     DocumentSnapshot userData = await DatabaseService(uid: user.uid).getAgentData();

    return Scaffold(
      key: _scafoldKey,
      backgroundColor: Colors.grey[200],
//      appBar: AppBar(
//        title: Text('Access'),
//        backgroundColor: Colors.blue,
//        elevation: 0.0,
//        actions: <Widget>[
//          FlatButton.icon(
//              onPressed: () async {
//                await _auth.signOut();
//              },
//              icon: Icon(Icons.person),
//              label: Text('Logout')
//          ),
//
//        ],
//      ),
      drawer: AppDrawer(),
      body:FutureBuilder(
        future: DatabaseService(uid: user.uid).getAgentData(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return SafeArea(
                child: Stack(
                  children: <Widget>[
                    Positioned(
                        top: 0,
                        right: 0,
                        left: 0,
                        child: Container(
                          height: 180,
                          padding: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 21.0),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/background.png'),
                                  fit: BoxFit.cover
                              )
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.menu),
                                    onPressed: () =>
                                        _scafoldKey.currentState.openDrawer(),
                                    color: Colors.grey[400],
                                  ),
                                  CustomButton(
                                    icon: Icons.add,
                                    text: ' Add policy  ',
                                    customOnPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddPolicyPolicyholderView())
                                      ).then((value) {
                                        setState(() {});
                                      });
                                    },

                                  )
                                ],
                              ),
                              SizedBox(height: 5.0,),
                              Row(

                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Icon(
                                      Icons.account_circle,
                                      size: 55.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 10.0,),
                                  FittedBox(
                                    child: Text(
                                      '${snapshot.data['firstName'] ??
                                          ''} ${snapshot.data['surname'] ??
                                          ''}',
                                      style: TextStyle(
                                          fontSize: 25.0,
                                          color: Colors.white
                                      ),
                                      overflow: TextOverflow.fade,
                                    ),
                                  ),
                                  Spacer(),
                                  IconButton(
                                    icon: Icon(Icons.refresh),
                                    iconSize: 35.0,
                                    color: Colors.white,
                                    onPressed: () => setState(() {}),
                                  ),
                                ],
                              ),
                            ],
                          ),

                        )
                    ),
                    Positioned(
                      top: 125,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 9.0, horizontal: 21.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    children: <Widget>[
                                      Center(
                                        child: Text(
                                          'Commission due',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF094451),
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          '${snapshot.data['commissionDue']
                                              .toString()}' ?? '0',
                                          style: TextStyle(
                                            fontSize: 45,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF094451),
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          //TODO: Reset monthly counter every month
                                          '\$${snapshot
                                              .data['monthCommission'] != null
                                              ? snapshot.data['monthCommission']
                                              .toString()
                                              : '0' }',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.grey[400],
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          'This month',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey[400],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )

                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 2.0, horizontal: 14.0),

                              child: Row(
//                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  SmallBox('Policies',
                                      '${snapshot.data['activePolicies'] != null
                                          ? snapshot.data['activePolicies']
                                          .toString()
                                          : '0'}'
                                          '/${snapshot.data['totalPolicies'] !=
                                          null ? snapshot.data['totalPolicies']
                                          .toString() : '0'}'),
                                  SmallBox('New this month', '12'),
                                  SmallBox('Paid-up', '12/220')
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 9.0, horizontal: 21.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    color: Colors.white,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: <Widget>[
                                        Container(
                                          color: Colors.grey[100],
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center,
                                            children: <Widget>[
                                              SizedBox(width: 15,),
                                              Text(
                                                'Notifications',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22,
                                                  color: Color(0xFF46737c),
                                                ),
                                              ),
                                              Spacer(),
                                              FlatButton(
                                                  onPressed: () {},
                                                  child: Text(
                                                    'See all',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.grey[400]
                                                    ),
                                                  )
                                              )
                                            ],

                                          ),
                                        ),
                                        Expanded(
//                                  height: 200,
                                            child: Container(
                                              child: ListView.builder(
                                                  itemCount: 8,
                                                  itemBuilder: (
                                                      BuildContext context,
                                                      int index) {
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 2.0),
                                                      child: ListTile(
                                                        leading: Container(
                                                          padding: EdgeInsets
                                                              .all(6),
                                                          margin: EdgeInsets
                                                              .all(10),
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .circular(5),
                                                              color: index < 2
                                                                  ? Color(
                                                                  0xFF46737c)
                                                                  : Colors
                                                                  .grey[300]
                                                          ),
                                                          child: Icon(
                                                            Icons.mail_outline,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        title: Text(
                                                          'Welcome to access',
                                                          style: TextStyle(
                                                              fontWeight: FontWeight
                                                                  .w700,
                                                              color: index < 2
                                                                  ? Color(
                                                                  0xFF46737c)
                                                                  : Colors
                                                                  .grey[400]
                                                          ),

                                                        ),
                                                        subtitle: Text(
                                                            "Lorem ipsum dolor sit amet consectetur adipisicing elit. Natus, enim hic."
                                                        ),
                                                        onTap: () {
                                                          showDialog(
                                                              context: context,
                                                              builder: (
                                                                  BuildContext context) {
                                                                return Dialog(

                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius
                                                                          .circular(
                                                                          12.0)
                                                                  ),
                                                                  child: InkWell(
                                                                    onTap: () =>
                                                                        Navigator
                                                                            .pop(
                                                                            context),
                                                                    child: Container(
                                                                      decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius
                                                                            .circular(
                                                                            13.0),
                                                                      ),
                                                                      width: 320.0,
                                                                      height: 320,
                                                                      child: Column(
                                                                        children: <
                                                                            Widget>[
                                                                          Container(
                                                                            width: double
                                                                                .infinity,
                                                                            height: 50,
                                                                            alignment: Alignment
                                                                                .bottomCenter,
                                                                            decoration: BoxDecoration(
                                                                              color: Color(
                                                                                  0xFF094451),
                                                                              borderRadius: BorderRadius
                                                                                  .only(
                                                                                  topLeft: Radius
                                                                                      .circular(
                                                                                      12),
                                                                                  topRight: Radius
                                                                                      .circular(
                                                                                      12)
                                                                              ),
                                                                            ),
                                                                            child: Align(
                                                                              alignment: Alignment
                                                                                  .center,
                                                                              child: Text(
                                                                                'Welcome to access medical fund' ??
                                                                                    '',
                                                                                overflow: TextOverflow
                                                                                    .fade,
                                                                                style: TextStyle(
                                                                                    color: Colors
                                                                                        .white,
                                                                                    fontSize: 22,
                                                                                    fontWeight: FontWeight
                                                                                        .bold
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            padding: EdgeInsets
                                                                                .symmetric(
                                                                                horizontal: 10.0,
                                                                                vertical: 5.0),
                                                                            child: Row(
                                                                              children: <
                                                                                  Widget>[
                                                                                Flexible(
                                                                                  child: Text(
                                                                                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. In iaculis nunc sed augue lacus viverra.  ',
                                                                                    style: TextStyle(
                                                                                        height: 2,
                                                                                        fontSize: 20
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),

                                                                );
                                                              }
                                                          );
                                                        },

                                                      ),
                                                    );
                                                  }
                                              ),
                                            )
                                        )


                                      ],
                                    ),
                                  ),
                                ),
                              ),

                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
            );
          } else {
            return Loading();
          }
        },

      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF46737c),
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddPolicyPolicyholderView())
          ).then((value) {
            setState(() {});
          });
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              title: Text('Profile')
          ),

        ]
      ),

    );
  }
}

class SmallBox extends StatefulWidget {

  final String text;
  final String value;
  SmallBox(this.text, this.value);

  @override
  _SmallBoxState createState() => _SmallBoxState();
}

class _SmallBoxState extends State<SmallBox> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 18),
        margin: EdgeInsets.symmetric(vertical: 2, horizontal: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.white
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],

              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.value,
              style: TextStyle(
                fontSize: 25,
                color: Colors.grey[600],
                fontWeight: FontWeight.w700
              ),
            )
          ],
        ),
      ),
    );
  }
}

