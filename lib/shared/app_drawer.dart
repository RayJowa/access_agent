import 'package:flutter/material.dart';
import 'package:access_agent/screens/view_policy/policy_search.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
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
                      onPressed: null,
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
                    color: Colors.black,
                  ),
                ),
                buildMenuItem(
                  Icons.people_outline,
                  "VIEW POLICY",
                  onTouch: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ViewPolicySearchView())
                  )
                    
                ),
                Divider(),
                buildMenuItem(Icons.compare_arrows, "TRANSFER"),
                Divider(),
                buildMenuItem(Icons.receipt, "STATEMENTS"),
                Divider(),
                buildMenuItem(Icons.attach_money, "PAYMENTS"),
                Divider(),
                buildMenuItem(Icons.sentiment_satisfied, "INVESTMENTS"),
                Divider(),
                buildMenuItem(Icons.phone, "SUPPORT"),
                Divider()

              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget buildMenuItem(IconData icon, String title,
      {double opacity = 0.9, VoidCallback onTouch,} ) {
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
