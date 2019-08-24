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

  int _selectIndex = 1;

  void onNavigationClick(int index) {
    setState(() {
      _selectIndex = index;
    });

    if(_selectIndex == 0){
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => HomePage(0),
      ));
    }else if(_selectIndex == 1){
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => HomePage(1),
      ));
    }else if(_selectIndex == 2){
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => HomePage(2),
      ));
    }else if(_selectIndex == 3){
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => HomePage(3),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final sef_title = ModalRoute.of(context).settings.arguments.toString();

    var now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    //   String sef_title = CommentsScreen.names[_title];

    String url =
        'https://www.lab.bendivar.com/burc/api.php?burc_sef=$sef_title&tarih=$formattedDate';

    final themeChangeProvider = Provider.of<ThemeChangeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${DetailsScreen.getNameFromSefTitle(sef_title)} Burcu",
        ),
          leading: IconButton(
            onPressed: () {
              themeChangeProvider.toggleDayNightView();
            },
            icon: Icon(themeChangeProvider.isDayTheme
                ? Icons.brightness_7
                : Icons.brightness_3),
          )
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: DetailsScreen.makeRequest(url, sef_title, formattedDate),
        builder: (BuildContext ctx, snapshot) =>
            DetailsScreen.buildDetails(sef_title, snapshot),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark), title: Text("Burcum")),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat), title: Text("Yorumlar")),
          BottomNavigationBarItem(
              icon: Icon(Icons.help), title: Text("Burç Öğren")),
          BottomNavigationBarItem(
              icon: Icon(Icons.people), title: Text("Burç Uyumu")),
        ],
        currentIndex: _selectIndex,
        selectedItemColor: Colors.lightBlue[300],
        onTap: onNavigationClick,
      ),
    );
  }
}
