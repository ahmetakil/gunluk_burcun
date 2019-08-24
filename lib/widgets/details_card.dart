import 'package:flutter/material.dart';

class ExpandableBox extends StatefulWidget {
  final String title;
  final String description;
  final bool isFirst;

  ExpandableBox(this.title, this.description, this.isFirst);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ExpandableBoxState();
  }
}

class _ExpandableBoxState extends State<ExpandableBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ExpansionTile(
                  title: Text(widget.title,
                  style: TextStyle(
                    fontSize: 20
                  ),),
                  initiallyExpanded: widget.isFirst,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(15),
                      child: Text(widget.description,
                      style: TextStyle(fontSize: 16),),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
