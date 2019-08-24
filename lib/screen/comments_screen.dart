import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gunluk_burcun/providers/ThemeChangeProvider.dart';
import 'package:provider/provider.dart';

import '../widgets/card_item.dart';

class CommentsScreen extends StatelessWidget {

   static const String route = "/comments";

  static const Map<String,String> names = {
    "Koç": "koc",
    "Boğa": "boga",
    "İkizler": "ikizler",
    "Yengeç":"yengec",
    "Aslan":"aslan",
    "Başak":"basak",
    "Terazi":"terazi",
    "Akrep":"akrep",
    "Yay":"yay",
    "Oğlak":"oglak",
    "Kova":"kova",
    "Balık":"balik"
  };

  static const List<List<Color>> colors = [
    [Color(0xff51376a),Color(0xff6E226C)], // koç
    [Color(0xff533a6c),Color(0xff651A6E)], // boğa
    [Color(0xff663782),Color(0xff825E80)], // ikizler
    [Color(0xff6F3A8D),Color(0xff8D598B)], // yengeç
    [Color(0xff883A7A),Color(0xff885B84)], // aslan
    [Color(0xff942B63),Color(0xff945088)], // başak
    [Color(0xff9E2D69),Color(0xffa54480)], // terazi
    [Color(0xffAD3A81),Color(0xffA667A9)], // akrep
    [Color(0xffA63869),Color(0xffA471A4)], // yay
    [Color(0xffAD345E),Color(0xffC96780)], // oğlak
    [Color(0xffD2436A),Color(0xffD97A8D)], // kova
    [Color(0xffe36480),Color(0xffE3A3C9)], // balık
  ];


  @override
  Widget build(BuildContext context) {

    bool isDayTheme = Provider.of<ThemeChangeProvider>(context).isDayTheme;
    var index = 0;

    return Scaffold(
      body: Container(
        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 5,
              crossAxisCount: 2,
              childAspectRatio: 1.5),
          children: names.keys.toList().map((item) {
            return Container(
              margin: EdgeInsets.all(2),
              padding: EdgeInsets.all(3),
              child: CardItem(
                title: item,
                sef_title: names[item],
                color: isDayTheme ? [Colors.white,Colors.white] : colors[index++],
              ),
            );
          }).toList(),
        )
      ),
    );
  }
}
