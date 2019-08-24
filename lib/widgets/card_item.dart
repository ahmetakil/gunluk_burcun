import 'package:flutter/material.dart';
import 'package:gunluk_burcun/screen/details_screen.dart';

import '../styles/FontStyles.dart';

class CardItem extends StatelessWidget {
  final String title;
  final String sef_title;
  final String url;
  final List<Color> color;

  CardItem({this.title, this.url = "", this.sef_title, this.color});

  void showDetails(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(DetailsScreen.route, arguments:
      sef_title,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showDetails(context),
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