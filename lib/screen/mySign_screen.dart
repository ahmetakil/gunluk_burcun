import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import './details_screen.dart';

class MySignScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          var now = DateTime.now();
          String formattedDate = DateFormat('yyyy-MM-10').format(now);

          final sharedPreferences = snapshot.data;

          String sef_title = sharedPreferences.getString("burc");

          String url =
              'https://www.lab.bendivar.com/burc/api.php?burc_sef=$sef_title&tarih=$formattedDate';
          return FutureBuilder<Map<String, dynamic>>(
              future: DetailsScreen.makeRequest(url, sef_title, formattedDate),
              builder: (BuildContext ctx, snapshot) {
                return DetailsScreen.buildDetails(sef_title, snapshot);
              });
        });
  }
}
