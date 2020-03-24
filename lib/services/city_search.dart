import 'package:access_agent/services/database.dart';
import 'package:access_agent/shared/loading.dart';
import 'package:flutter/material.dart';

class CitySearch extends SearchDelegate<String> {

//  final recentCities = [
//    'Zvishavane',
//    'Mutare',
//    'Rusape',
//    'Marondera'
//  ];

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
    final cities = DatabaseService().getCities();
    return FutureBuilder (
      future: cities,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          final suggestionList = snapshot.data['cities'].where((p) => p.toString().toLowerCase().startsWith(query.toLowerCase())).toList();

          return ListView.builder(
            itemBuilder: (context, index) => ListTile(
              leading: Icon(Icons.location_city),
              title: RichText(
                  text: TextSpan(
                      text:suggestionList[index].substring(0, query.length),
                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                            text: suggestionList[index].substring(query.length),
                            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal)

                        )
                      ]
                  )
              ),
              onTap: () => close(context, suggestionList[index]),
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
