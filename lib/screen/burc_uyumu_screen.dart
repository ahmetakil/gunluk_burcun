import 'package:flutter/material.dart';
import 'package:gunluk_burcun/providers/ThemeChangeProvider.dart';
import 'package:gunluk_burcun/screen/comments_screen.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert' as convert;

import 'details_screen.dart';

class BurcUyumuScreen extends StatefulWidget {
  @override
  _BurcUyumuScreenState createState() => _BurcUyumuScreenState();
}

class _BurcUyumuScreenState extends State<BurcUyumuScreen> {
  String sef_title1;
  String sef_title2;

  String yorum;
  int oran;

  static const Map<String, String> names = {
    "Koç": "koc",
    "Boğa": "boga",
    "İkizler": "ikizler",
    "Yengeç": "yengec",
    "Aslan": "aslan",
    "Başak": "basak",
    "Terazi": "terazi",
    "Akrep": "akrep",
    "Yay": "yay",
    "Oğlak": "oglak",
    "Kova": "kova",
    "Balık": "balik"
  };

  Widget placeholder() {
    if (yorum == null || oran == null) {
      return Text("");
    } else {
      return SingleChildScrollView(
          child: Text(
        yorum,
        style: TextStyle(fontSize: 18),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDayTheme = Provider.of<ThemeChangeProvider>(context).isDayTheme;

    return ListView(
      children: <Widget>[
        placeholder(),
        SizedBox(height: 50),
        Text(
          "Hangi burçla uyumlusun ?",
          style: TextStyle(fontSize: 22),
        ),
        SizedBox(height: 5),
        Text("Merak etmiyor musun"),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: DropdownButton<String>(
                value: sef_title1,
                style: TextStyle(
                    fontSize: 20,
                    color: isDayTheme ? Colors.black : Colors.white),
                hint: Text("Senin Burcun"),
                onChanged: (String seninBurcun) {
                  setState(() {
                    sef_title1 = seninBurcun;
                  });
                },
                items: names.keys.map((String title) {
                  return DropdownMenuItem(
                    child: Text(title),
                    value: names[title],
                  );
                }).toList(),
              ),
            ),
            Container(
                padding: EdgeInsets.all(5),
                child: DropdownButton<String>(
                  style: TextStyle(
                      fontSize: 20,
                      color: isDayTheme ? Colors.black : Colors.white),
                  value: sef_title2,
                  hint: Text("Onun Burcu"),
                  onChanged: (String onunBurcu) {
                    setState(() {
                      sef_title2 = onunBurcu;
                    });
                  },
                  items: names.keys.map((String title) {
                    return DropdownMenuItem(
                      child: Text(title),
                      value: names[title],
                    );
                  }).toList(),
                ))
          ],
        ),
        SizedBox(height: 20),
        RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: Text(
              "GÖSTER",
              style: TextStyle(fontSize: 18, letterSpacing: 0.8),
            ),
          ),
          color: Theme.of(context).accentColor,
          onPressed: handlePress,
        )
      ],
    );
  }

  void handlePress() {
    if (sef_title2 == null || sef_title2 == null) {
      return;
    }

    String url =
        "https://www.lab.bendivar.com/burc/uyumapi.php?sen=$sef_title1&o=$sef_title2";

    Future<List<dynamic>> response =
        makeRequest(url, sef_title1, sef_title2);
    response.then((List<dynamic> apiResponse) {
      setState(() {
        yorum = apiResponse[1];
        oran = int.parse(apiResponse[0]);
      });
    });
  }

  static Future<List<dynamic>> makeRequest(
      String url, String sef1, String sef2) async {
    var response = await http.post(Uri.encodeFull(url), headers: {
      "Accept": "application/json"
    }, body: {
      "sen": sef1,
      "o": sef2,
    });
    List<dynamic> extractData = convert.jsonDecode(response.body);
    return extractData;
  }
}
