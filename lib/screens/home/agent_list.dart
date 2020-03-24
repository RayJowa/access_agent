import 'package:access_agent/services/database.dart';
import 'package:access_agent/shared/loading.dart';
import 'package:flutter/material.dart';

class AgentList extends StatefulWidget {
  @override
  _AgentListState createState() => _AgentListState();
}

class _AgentListState extends State<AgentList> {
  @override
  Widget build(BuildContext context) {

    final Future agents = DatabaseService().getAgents();

    return Container(
      child: FutureBuilder(
        future: agents,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (_, index) {
                return ListTile(
                  title: Text(snapshot.data[index].data['firstName']),
                );
              }
            );

          }else {
            return Loading();
          }
        },
      ),
    );
  }
}
