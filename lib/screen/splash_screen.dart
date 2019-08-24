import 'package:flutter/material.dart';
import 'package:gunluk_burcun/main.dart';
import 'package:gunluk_burcun/screen/comments_screen.dart';
import 'package:gunluk_burcun/screen/details_screen.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import './first_time_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<Timer> loadData() async {
    return Timer(Duration(seconds: 3), onDoneLoading);
  }

  onDoneLoading() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _burc = prefs.getString("burc") ?? "";
    if (_burc != "") {
      Navigator.of(context).pushReplacementNamed(HomePage.route,
          arguments: _burc );
    } else {
     // Navigator.of(context).pushReplacementNamed(FirstTime.route);
      Navigator.of(context).pushReplacementNamed(FirstTime.route);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(
            "Günlük Burç",
            style: TextStyle(
              fontSize: 40,
            ),
          ),
        ),
      ),
    );
  }
}
