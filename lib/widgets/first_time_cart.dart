import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screen/details_screen.dart';
import '../main.dart';

class FirstTimeCart extends StatelessWidget {
  final String title;
  final String sef_title;
  final String url;
  final List<Color> color;

  FirstTimeCart({this.title, this.url = "", this.sef_title, this.color});

  void onClick(BuildContext context,String selectedBurc) {
      if(selectedBurc != null){
        Future<SharedPreferences> futurePref =  SharedPreferences.getInstance();
        futurePref.then( (SharedPreferences pref) {
          pref.setString("burc", selectedBurc); // Selected burc as a sefTitle
          Navigator.of(context).pushReplacementNamed(HomePage.route,arguments: selectedBurc);
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onClick(context,sef_title),
      child: Card(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 3,
        margin: EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                tileMode: TileMode.mirror,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color[0],
                  color[1],
                ],
              )),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                children: <Widget>[
                  Image.network(
                      "https://www.lab.bendivar.com/burc/assets/img/burclar/$sef_title.png"),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    title,
                    style: Theme.of(context).primaryTextTheme.body1,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
