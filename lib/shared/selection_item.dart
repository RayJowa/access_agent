import 'package:flutter/material.dart';

class SelectionItem extends StatelessWidget {

  final String title;
  final bool isForList;

  SelectionItem({this.title, this.isForList = true});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.0,
      child: isForList ?
      Padding(
        child: _buildItem(context),
        padding: EdgeInsets.all(10.0),
      ) : Card(
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        child: Stack(
          children: <Widget>[
            _buildItem(context),
            Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.arrow_drop_down),
            )
          ],
        ),

      )
    );
  }

  _buildItem(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: Text(title),
    );
  }

}


