import 'package:access_agent/services/database.dart';
import 'package:access_agent/shared/loading.dart';
import 'package:flutter/material.dart';

class DoctorSearch extends SearchDelegate<String> {


  final suburbId;
  DoctorSearch(this.suburbId);

  @override
  List<Widget> buildActions(BuildContext context) {
    // Action to perform
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //left icon on left of appbar
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        }
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    //show when searching

  }

  @override
  Widget buildSuggestions(BuildContext context) {

    //show when searching
    final suburb = DatabaseService().getSuburb(suburbId);

    return FutureBuilder (
      future: suburb,
      builder: (_, snapshot) {
        if (snapshot.hasData) {

          final suggestionList = snapshot.data['doctors'].where((p) => p['name'].toString().toLowerCase().startsWith(query.toLowerCase())).toList();

          return ListView.builder(
            itemBuilder: (context, index) => ListTile(
              leading: Icon(Icons.location_city),
              title: Text(
                  suggestionList[index]['name'],
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal)
              ),
              onTap: () => close(context, '${suggestionList[index]['docid']}?${suggestionList[index]['name']}'),
            ),
            itemCount: suggestionList.length,

          );
        } else {
          return Loading();
        }
      },

    );
  }

}
