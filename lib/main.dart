import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:treni/model/palette.dart';
import 'package:treni/model/trains/search_result.dart';
import 'package:treni/model/trenitalia/ti_solutions.dart';
import 'package:treni/recent_page.dart';
import 'package:treni/search_page.dart';
import 'package:google_fonts/google_fonts.dart';

import 'announcements_page.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Treni',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Palette.blue,
        primaryColorLight: Palette.lightblue,
        accentColor: Palette.red,
        fontFamily: 'Rubik',
        buttonTheme: ButtonThemeData(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)))),
        textTheme: TextTheme(
            title: GoogleFonts.rubik(),
            body1: GoogleFonts.rubik(fontSize: 16),
            body2: GoogleFonts.rubik(fontSize: 16),
            button: GoogleFonts.rubik(),
            headline: GoogleFonts.rubik(),
            subtitle: GoogleFonts.rubik(),
            subhead: GoogleFonts.rubik(),
            caption: GoogleFonts.rubik(),
            display1: GoogleFonts.rubik(),
            display2: GoogleFonts.rubik(),
            display3: GoogleFonts.rubik(),
            display4: GoogleFonts.rubik(),
            overline: GoogleFonts.rubik()),
      ),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          backgroundColor: Palette.darkGrey,
          primaryColor: Palette.blue,
          primaryColorLight: Palette.lightblue,
          accentColor: Palette.red,
          fontFamily: 'Rubik'),
      home: HomePage(title: 'Treni'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  static int _selectedIndex = 0;

  final List<Widget> pages = [
    RecentPage(key: PageStorageKey('RecentPage'), navIndex: _selectedIndex),
    SearchPage(
      key: PageStorageKey('SearchPage'),
    ),
    AnnouncementsPage(
      key: PageStorageKey('AnnouncementsPage'),
    )
  ];
  final List<String> titles = [
    "Recenti e preferite",
    "Cerca tratta",
    "Annunci e scioperi"
  ];
  final List<IconData> icons = [
    Icons.access_time,
    Icons.search,
    Icons.announcement
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(icons[_selectedIndex]),
            ),
            Text(
              titles[_selectedIndex],
              //style: Theme.of(context).textTheme.body1,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              title: Text("Tratte"), icon: Icon(Icons.train)),
          BottomNavigationBarItem(
              title: Text("Cerca"), icon: Icon(Icons.search)),
          BottomNavigationBarItem(
              title: Text("Annunci"), icon: Icon(Icons.announcement))
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        currentIndex: _selectedIndex,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
    );
  }
}
