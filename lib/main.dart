import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import './providers/ThemeChangeProvider.dart';

import './screen/mySign_screen.dart';
import './screen/comments_screen.dart';
import './screen/learn_screen.dart';
import './screen/burc_uyumu_screen.dart';

import './screen/splash_screen.dart';
import './screen/details_screen.dart';
import './screen/first_time_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData nightTheme = ThemeData(
        backgroundColor: Color.fromRGBO(65, 42, 88, 1),
        brightness: Brightness.dark,
        cardColor: Color.fromRGBO(81, 55, 106, 1),
        primarySwatch: Colors.purple,
        accentColor: Colors.blue,
        appBarTheme: AppBarTheme(
          color: Color.fromRGBO(75, 48, 101, 1),
        ),
        primaryTextTheme: TextTheme(
            body1: TextStyle(
                color: Colors.white,
                fontFamily: "Calibre-Semibold",
                fontSize: 20)));

    ThemeData dayTheme = ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        accentColor: Colors.amber[800],
        backgroundColor: Colors.white,
        cardColor: Colors.white,
        primaryTextTheme: TextTheme(
            body1: TextStyle(
                color: Colors.black,
                fontFamily: "Calibre-Semibold",
                fontSize: 20)));

    return ChangeNotifierProvider(
      builder: (_) => ThemeChangeProvider(false),
      // This boolean determines opening theme
      child: Consumer<ThemeChangeProvider>(builder: (context, themeCp, widget) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeCp.isDayTheme ? dayTheme : nightTheme,
          title: "Günlük Burcun",
          routes: {
            "/": (ctx) => SplashScreen(),
            HomePage.route: (ctx) => HomePage(),
            CommentsScreen.route: (ctx) => CommentsScreen(),
            FirstTime.route: (ctx) => FirstTime(),
          },
        );
      }),
    );
  }
}

class HomePage extends StatefulWidget {
  static const String route = "/home";



  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  List<Widget> pages = [
    MySignScreen(),
    CommentsScreen(),
    LearnSignScreen(),
    BurcUyumuScreen(),
  ];




  @override
  Widget build(BuildContext context) {
    ThemeChangeProvider themeChangeProvider =
    Provider.of<ThemeChangeProvider>(context);

    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Container(
            child: Text(
              "Günlük Burç",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
            ),
          ),
          leading: IconButton(
            onPressed: () {
              themeChangeProvider.toggleDayNightView();
            },
            icon: Icon(themeChangeProvider.isDayTheme
                ? Icons.brightness_7
                : Icons.brightness_3),
          ),
          actions: <Widget>[
            Container(
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  onChanged: (_) {},
                  icon: Icon(Icons.settings, color: Colors.white,),
                  items: [
                    DropdownMenuItem(
                      child: Text("Ayarlar"),
                      value: 0,
                    ),
                    DropdownMenuItem(
                      child: Text("Hakkımızda"),
                      value: 1,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        body: TabBarView(
          children: pages,
        ),
        bottomNavigationBar: TabBar(
          tabs: const [
            Tab(
              text: "Burcum",
              icon: Icon(Icons.bookmark,size: 24,),
            ),
            Tab(
              child: Text("Yorumlar"),
              icon: Icon(Icons.chat),),
            Tab(
              child: Text("Burç Öğren"),
              icon: Icon(Icons.help),),
            Tab(
              child: Text("Burç Uyumu"),
              icon: Icon(Icons.people),),
          ],
          onTap: (int index) {
            if(index == 1){
              print("You clicked yorumlar");
            }
          },
          labelColor: Theme
              .of(context)
              .accentColor,
        ),
      ),
    );
  }
}
