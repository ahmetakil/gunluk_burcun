import 'package:flutter/material.dart';
import 'package:gunluk_burcun/providers/ThemeChangeProvider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'details_screen.dart';

class LearnSignScreen extends StatefulWidget {
  @override
  _LearnSignScreenState createState() => _LearnSignScreenState();
}

class _LearnSignScreenState extends State<LearnSignScreen> {
  int selectedDay;
  int selectedMonth;
  String selectedMonthText;
  String sef_title;

  static const months = [
    "Ocak",
    "Şubat",
    "Mart",
    "Nisan",
    "Mayıs",
    "Haziran",
    "Temmuz",
    "Ağustos",
    "Eylül",
    "Ekim",
    "Kasım",
    "Aralık"
  ];

  Widget placeholder() {
    if (sef_title == null) {
      return Text("");
    } else {
      return Column(
        children: <Widget>[
          SizedBox(height:40),
          Image.network(
            "https://www.lab.bendivar.com/burc/assets/img/burclar/256x256/$sef_title.png",
            fit: BoxFit.scaleDown,
            width: 100,
            height: 100,
          ),
          SizedBox(height: 20,),
          Text(DetailsScreen.getNameFromSefTitle(sef_title),style: TextStyle(
            fontSize: 28
          ),)
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDayTheme = Provider.of<ThemeChangeProvider>(context).isDayTheme;

    return Column(
      children: <Widget>[
        placeholder(),
        SizedBox(height:50),
        Text(
          "Burcunuzu Öğrenmek İster misiniz ?",
          style: TextStyle(fontSize: 22),
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: DropdownButton<int>(
                  value: selectedDay,
                  style: TextStyle(
                      fontSize: 20,
                      color: isDayTheme ? Colors.black : Colors.white),
                  hint: Text("Gün Seçin"),
                  onChanged: (int day) {
                    setState(() {
                      selectedDay = day;
                    });
                  },
                  items: List.generate(31, (int index) {
                    return DropdownMenuItem(
                      child: Text((index + 1).toString()),
                      value: index + 1,
                    );
                  })),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: DropdownButton<String>(
                  style: TextStyle(
                      fontSize: 20,
                      color: isDayTheme ? Colors.black : Colors.white),
                  value: selectedMonthText,
                  hint: Text("Ay Seçin"),
                  onChanged: (String month) {
                    setState(() {
                      selectedMonthText = month;
                    });
                  },
                  items: months.map((String month) {
                    return DropdownMenuItem(
                      child: Text(month),
                      value: month,
                    );
                  }).toList()),
            )
          ],
        ),
        SizedBox(height: 20),
        RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40)
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 25,vertical:15),
            child: Text("GÖSTER",style: TextStyle(
              fontSize: 18,
              letterSpacing: 0.8
            ),),
          ),
          color: Theme.of(context).accentColor,
          onPressed: () => datePicker(context),
        )
      ],
    );
  }

  static Future<String> makeRequest(String url, int day, int month) async {
    var response = await http.post(Uri.encodeFull(url), body: {
      "gun": day.toString(),
      "ay": month.toString(),
      "platform": "2",
    });

    return response.body;
  }

  void datePicker(BuildContext context) {
    if (selectedDay == null || selectedMonthText == null) {
      return;
    }

    selectedMonth = months.indexOf(selectedMonthText) + 1;

    Future<String> response = makeRequest(
        "https://www.lab.bendivar.com/burc/ajax/burcOgren.php",
        selectedDay,
        selectedMonth);
    response.then((String apiResponse) {
      setState(() {
        sef_title = apiResponse;
      });
    });
  }
}
