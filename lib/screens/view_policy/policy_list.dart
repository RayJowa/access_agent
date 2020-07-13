
import 'package:access_agent/models/user.dart';
import 'package:access_agent/screens/view_policy/policy_detail.dart';
import 'package:access_agent/services/database.dart';
import 'package:access_agent/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewPolicyListView extends StatefulWidget {

  final String surname;
  final String idNumber;
  final String agentID;

  ViewPolicyListView({this.surname, this.idNumber, this.agentID});


  @override
  _ViewPolicyListViewState createState() => _ViewPolicyListViewState();
}

class _ViewPolicyListViewState extends State<ViewPolicyListView> {

  List<DocumentSnapshot> policies = [];
  bool _loadingPolicies = true;
  int perPage = 12;
  DocumentSnapshot lastDocument;
  ScrollController _scrollController = ScrollController();
  bool _gettingMorePolicies = false;
  bool _morePoliciesAvailable = true;



  _getPolicies() async {

    setState(() {
      _loadingPolicies = true;
    });

//    final user = Provider.of<User>(context);

    QuerySnapshot query = await DatabaseService().getPolicies(
      perPage: perPage,
      surname: widget.surname,
      idNumber: widget.idNumber,
      agentID: widget.agentID
    );

    policies = query.documents;

    if (query.documents.length > 0) {
      lastDocument = query.documents[query.documents.length - 1];
    }

    setState(() {
      _loadingPolicies = false;
    });
  }


  _getMorePolicies() async {

//    final user = Provider.of<User>(context);

    if (_morePoliciesAvailable == false) {
      //no more policies are available in the query, therefore exit function
      return;
    }

    if (_gettingMorePolicies == true) {
      //Last function call is still going on
      return;
    }

    _gettingMorePolicies = true;
    QuerySnapshot query = await DatabaseService().getPolicies(
      perPage: perPage,
      startAfter: lastDocument,
      surname: widget.surname,
      idNumber: widget.idNumber,
      agentID: widget.agentID
    );

    if (query.documents.length < perPage) {
      _morePoliciesAvailable = false;
    }
    policies.addAll(query.documents);

    if (query.documents.length > 0) {
      lastDocument = query.documents[query.documents.length - 1];
    }

    setState(() {});

    _gettingMorePolicies = false;

  }

  @override
  void initState() {
    super.initState();

    _getPolicies();
    
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent ) {
        _getMorePolicies();
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body:_loadingPolicies == true ? Loading() : SafeArea(
          child: Stack(
            children: <Widget>[
              Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    height: 160,
                    padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 21.0),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/background.png'),
                            fit: BoxFit.cover
                        )
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        FittedBox(
                          child: Text(
                            'Policy search',
                            style: Theme.of(context).textTheme.headline4.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                            overflow: TextOverflow.fade,
                          ),
                        ),
                        Divider(height: 20,),
                        Text('Select policy', style: Theme.of(context).textTheme.headline6,),
                      ],
                    ),

                  )
              ),
              Positioned (
                top: 100,
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 9.0, horizontal: 21.0),
                        width: double.infinity,

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: EdgeInsets.all(10),
                        child: policies.length == 0 ? Center(
                          child: Text('Your search produced no policies'),
                        ):
                            ListView.separated(
                              controller: _scrollController,
                              itemCount: policies.length,
                              itemBuilder: (context, index) {
                                 return ListTile(
                                   title: RichText(
                                       text: TextSpan(
                                           text:policies[index].data['firstName'] + ' ',
                                           style: TextStyle(color: Colors.grey, ),
                                           children: [
                                             TextSpan(
                                                 text: policies[index].data['surname'],
                                                 style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold)
                                     )
                                   ]
                                 ),
                                     overflow: TextOverflow.fade,

                                ),

                                   leading: ClipRRect(
                                     borderRadius: BorderRadius.circular(5),
                                     child: Icon(
                                       Icons.account_circle,
                                       size: 40.0,
                                     ),
                                   ),
                                   trailing: Icon(
                                     Icons.navigate_next
                                   ),
                                   onTap: () {
                                     Navigator.push(
                                         context,
                                         MaterialPageRoute(builder: (BuildContext context) => PolicyDetailView(policy: policies[index],))
                                     );
                                   },

                                 );
                               },
                              separatorBuilder: (BuildContext context, int index) => Divider(height: 5,),

                            )
                      ),
                    ),
                    SizedBox(height: 12.0),
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },

                      child: SizedBox(
                        height: 50,
                        width: 200,
                        child: Center(
                          child: Text(
                            'Back',
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
                    SizedBox(height: 12.0),
                  ],
                ),
              ),
            ],
          )
      ),


    );
  }
}
