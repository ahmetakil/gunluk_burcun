import 'package:flutter/material.dart';
import 'package:gunluk_burcun/widgets/first_time_cart.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/card_item.dart';
import './comments_screen.dart';
import '../providers/ThemeChangeProvider.dart';

class FirstTime extends StatefulWidget {
  static const route = "/first";

  static const Map<String, String> names = {
    "Koç": "koc", // Title : SefTitle
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

  String selectedBurc; // Sef title olarak

  @override
  _FirstTimeState createState() => _FirstTimeState();
}

class _FirstTimeState extends State<FirstTime> {
  @override
  Widget build(BuildContext context) {
    ThemeChangeProvider themeChangeProvider =
        Provider.of<ThemeChangeProvider>(context);
    bool isDayTheme = themeChangeProvider.isDayTheme;
    var index = 0;

    return Scaffold(
        appBar: AppBar(
          title: Center(child:Text("Burcunuzu Seçin"),),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                themeChangeProvider.toggleDayNightView();
              },
              icon: Icon(themeChangeProvider.isDayTheme
                  ? Icons.brightness_3
                  : Icons.brightness_7),
            )
          ],
        ),
        body: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 5, crossAxisCount: 2, childAspectRatio: 1.5),
          children: CommentsScreen.names.keys.toList().map((item) {
            return Container(
              margin: EdgeInsets.all(2),
              padding: EdgeInsets.all(3),
              child: FirstTimeCart(
                title: item,
                sef_title: CommentsScreen.names[item],
                color: isDayTheme
                    ? [Colors.white, Colors.white]
                    : CommentsScreen.colors[index++],
              ),
            );
          }).toList(),
        ));
  }
}
