import 'package:flutter/material.dart';
import 'package:gunluk_burcun/screen/first_time_screen.dart';
import 'package:gunluk_burcun/widgets/burc_uyumu.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import './providers/ThemeChangeProvider.dart';
import './screen/comments_screen.dart';
import './screen/details_screen.dart';
import './screen/splash_screen.dart';
import 'screen/learn_screen.dart';

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
        accentColor: Colors.amber,
        backgroundColor: Colors.white,
        cardColor: Colors.white,
        primaryTextTheme: TextTheme(
            body1: TextStyle(
                color: Colors.black,
                fontFamily: "Calibre-Semibold",
                fontSize: 20)));

    return ChangeNotifierProvider(
      builder: (_) => ThemeChangeProvider(false), // This boolean determines opening theme
      child: Consumer<ThemeChangeProvider>(builder: (context, themeCp, widget) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeCp.isDayTheme ? dayTheme : nightTheme,
          title: "Günlük Burcun",
          routes: {
            "/": (ctx) => SplashScreen(),
            HomePage.route: (ctx) => HomePage(0),
            CommentsScreen.route: (ctx) => CommentsScreen(),
            DetailsScreen.route: (ctx) => DetailsScreen(),
            FirstTime.route: (ctx) => FirstTime(),
          },
        );
      }),
    );
  }
}

class HomePage extends StatefulWidget {
  static const String route = "/home";

  int firstPage = 0;

  HomePage(this.firstPage);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectIndex;

  @override
  void initState() {
    _selectIndex = widget.firstPage;
    super.initState();
  }

  void onNavigationClick(int index) {
    setState(() {
      _selectIndex = index;
    });
  }
  /*
  List<Widget> pages = [
    MySignScreen(),
    CommentScreen(),
    LearnSignScreen(),
    BurcUyumuScreen(),
  ];
   */


  Widget mainContent() {
    if (_selectIndex == 0) {
      return FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context,snapshot) {
          if(!snapshot.hasData){
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
              }
          );
        }
      );

    } else if (_selectIndex == 1) {
      return Container(
        color: Theme.of(context).backgroundColor,
        child: CommentsScreen(),
        // margin: EdgeInsets.only(top: 10),
      );
    } else if (_selectIndex == 2) {
      return Container(
        child: LearnItem(),
      );
    } else if (_selectIndex == 3) {
      return Container(
        child: BurcUyumu(),
      );
    } else {
      return Text("Something went wrong");
    }
  }

  @override
  Widget build(BuildContext context) {

    ThemeChangeProvider themeChangeProvider =
        Provider.of<ThemeChangeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Text(
            "Günlük Burç",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
          ),
        ),
          leading:IconButton(
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
                icon: Icon(Icons.settings,color: Colors.white,),
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
      body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xf5f5f5),
          ),
          child: mainContent()),
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
