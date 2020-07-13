import 'package:access_agent/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:access_agent/screens/view_policy/policy_search.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160.0,
      child: Drawer(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: FlatButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                          Icons.arrow_back,
                          color: Color(0xFF094451),
                      ),
                      label: Text(
                        'Back',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16.0,color: Colors.black

                        ),
                      ),
//                    color: Colors.black,
                  ),
                ),
                buildMenuItem(
                  Icons.done_outline,
                  "ACTIVE POLICIES",
                  onTouch: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ViewPolicySearchView())
                  )
                ),
                Divider(),
                  buildMenuItem(Icons.edit, "QUOTATIONS"),
                Divider(),
                buildMenuItem(
                  Icons.attach_money,
                  "PAYMENTS",
                  onTouch: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ViewPolicySearchView())
                  )
                ),
                Divider(),
                buildMenuItem(
                  Icons.supervisor_account,
                  "AFFILIATES",
                  opacity: 0.2
                ),
                Divider(),
                buildMenuItem(Icons.receipt, "COMMISION STATEMENTS", opacity: 0.2, onTouch: () {print('ECO' + DateTime.now().millisecondsSinceEpoch.toString());}),
                Divider(),
                buildMenuItem(Icons.phone, "SUPPORT", opacity: 0.2),
                Divider(),
                buildMenuItem(
                    Icons.person_outline,
                    'LOG OUT',
                    onTouch: () => _auth.signOut()
                )

              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget buildMenuItem(IconData icon, String title,
      {double opacity = 0.8, VoidCallback onTouch,} ) {
    return InkWell(
      child: Opacity(
        opacity: opacity,
        child: Center(
          child: Column(children: <Widget>[
            SizedBox(height: 20.0,),
            Icon(
              icon,
              size: 50.0,
              color: Color(0xFF094451),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              title,
              style:TextStyle(
                fontWeight: FontWeight.w700, fontSize: 14.0, color: Color(0xFF094451)
              ) ,
            ),
            SizedBox( height: 10.0,)
          ],

          ),
        ),
      ),
      onTap: onTouch,
    );
  }

}
