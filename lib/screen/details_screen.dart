import 'package:flutter/material.dart';
import 'package:gunluk_burcun/providers/ThemeChangeProvider.dart';
import 'package:gunluk_burcun/screen/comments_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../widgets/details_card.dart';
import '../main.dart';

import '../styles/FontStyles.dart';

class DetailsScreen extends StatefulWidget {
  static const String route = "/details";

  final String sefTitle;

  DetailsScreen(this.sefTitle);

  static String getNameFromSefTitle(String sefTitle) {
    List<String> titles = CommentsScreen.names.keys.toList();
    List<String> sef = CommentsScreen.names.values.toList();

    for (int i = 0; i < titles.length; i++) {
      if (sef[i] == sefTitle) {
        return titles[i];
      }
    }
    return "";
  }

  static Future<Map<String, dynamic>> makeRequest(
      String url, String sef_title, String date) async {
    var response = await http.post(Uri.encodeFull(url), headers: {
      "Accept": "application/json"
    }, body: {
      "sef_title": sef_title,
      "tarih": date,
    });

    Map<String, dynamic> extractData = convert.jsonDecode(response.body)[0];

    return extractData;
  }

  static Widget buildDetails(String sef_title, snapshot) {
    if (!snapshot.hasData) {
      return Center(
        child: Card(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Text(
              "Hey Selam, Bugün Erkencisin. Günlük yorumun için seni biraz daha bekleticez",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(color: Color(0xf5f5f5)),
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              child: Image.network(
                "https://www.lab.bendivar.com/burc/assets/img/burclar/256x256/$sef_title.png",
                fit: BoxFit.scaleDown,
                width: 100,
                height: 100,
              ),
            ),
            ExpandableBox("Yorum", snapshot.data["yorum"], true),
            ExpandableBox("Kadın Genel Özelllikleri",
                snapshot.data["bo_kadingenelozellik"], false),
            ExpandableBox("Erkek Genel Özelllikleri",
                snapshot.data["bo_erkekgenelozellik"], false),
            ExpandableBox("Hediye Seçimi", snapshot.data["h_aciklama"], false),
            ExpandableBox(
                "Olumlu Yanları", snapshot.data["bo_olumluyani"], false),
            ExpandableBox(
                "Olumsuz Yanı", snapshot.data["bo_olumsuzyani"], false),
          ],
        ),
      );
    }
  }

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    String sef_title = widget.sefTitle;
    //   String sef_title = CommentsScreen.names[_title];

    String url =
        'https://www.lab.bendivar.com/burc/api.php?burc_sef=$sef_title&tarih=$formattedDate';

    return FutureBuilder<Map<String, dynamic>>(
      future: DetailsScreen.makeRequest(url, sef_title, formattedDate),
      builder: (BuildContext ctx, snapshot) =>
          DetailsScreen.buildDetails(sef_title, snapshot),
    );
  }
}
