import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:http/http.dart' as http;
import 'package:treni/model/palette.dart';
import 'package:treni/model/solutions.dart';

import 'solution_list.dart';
import 'model/station.dart';

Station _from;
Station _to;
DateTime _time;
DateTime _date;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Treni',
      theme: ThemeData(primarySwatch: Palette.materialRed, fontFamily: 'Rubik'),
      home: MyHomePage(title: 'Treni'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  List<Soluzione> solutions = List();
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(55),
          child: Container(
            color: Colors.transparent,
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  TabBar(
                    controller: _tabController,
                    indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(color: Palette.red, width: 4.0),
                        insets: EdgeInsets.symmetric(horizontal: 40.0)),
                    indicatorWeight: 15,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      letterSpacing: 1.3,
                      fontWeight: FontWeight.w500,
                    ),
                    unselectedLabelColor: Palette.lightblue,
                    labelColor: Palette.blue,
                    tabs: <Widget>[
                      Tab(
                          text: "TROVA TRENO",
                          icon: Icon(
                            Icons.search,
                            size: 40,
                          )),
                      Tab(
                          text: "ORARI",
                          icon: Icon(
                            Icons.access_time,
                            size: 40,
                          )),
                      Tab(
                          text: "MENU",
                          icon: Icon(
                            Icons.menu,
                            size: 40,
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: SingleChildScrollView(
              child: SolutionForm(),
              scrollDirection: Axis.vertical,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _searchSolutions,
        label: Text("CERCA"),
        icon: Icon(Icons.search),
        backgroundColor: Palette.red,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _searchSolutions() async {
    if (_date != null && _time != null && _from != null && _to != null) {
      await Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                SolutionListPage(
              from: _from,
              to: _to,
              date: _date,
              time: _time,
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return child;
            },
          ));
    }
  }
}

class SolutionForm extends StatefulWidget {
  @override
  _SolutionFormState createState() => _SolutionFormState();
}

class _SolutionFormState extends State<SolutionForm> {
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();

  void _fromPage(BuildContext context) async {
    var from = await Navigator.push(context, _fromPageRoute());
    if (from != null) {
      setState(() {
        _from = from;
        fromController.text = _from.nomeBreve;
      });
    }
  }

  void _toPage(BuildContext context) async {
    var to = await Navigator.push(context, _toPageRoute());
    if (to != null) {
      setState(() {
        _to = to;
        toController.text = _to.nomeBreve;
      });
    }
  }

  Route _fromPageRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          FromStationPage(station: _from),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }

  Route _toPageRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ToStationPage(
        station: _to,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }

  @override
  void initState() {
    _date = DateTime.now();
    _time = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
          child: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Align(
                    child: Text(
                      "TRENO DA",
                      style: TextStyle(
                          color: Palette.red, fontWeight: FontWeight.w700),
                    ),
                    alignment: Alignment.bottomLeft,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _fromPage(context);
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: IgnorePointer(
                      child: Hero(
                        tag: 'from',
                        child: Material(
                            child: TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(128.0),
                                  borderSide: BorderSide(
                                      width: 0.8, color: Palette.black)),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 24.0),
                              filled: false,
                              hintText: "Stazione di partenza"),
                          controller: fromController,
                        )),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
          child: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Align(
                    child: Text(
                      "TRENO PER",
                      style: TextStyle(
                          color: Palette.red, fontWeight: FontWeight.w700),
                    ),
                    alignment: Alignment.bottomLeft,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _toPage(context);
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: IgnorePointer(
                      child: Hero(
                        tag: 'to',
                        child: Material(
                            child: TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(128.0),
                                  borderSide: BorderSide(
                                      width: 0.8, color: Palette.black)),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 24.0),
                              filled: false,
                              hintText: "Stazione di arrivo"),
                          controller: toController,
                        )),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
          child: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Align(
                    child: Text(
                      "TRENO ALLE",
                      style: TextStyle(
                          color: Palette.red, fontWeight: FontWeight.w700),
                    ),
                    alignment: Alignment.bottomLeft,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    TimePickerSpinner(
                      time: DateTime.now(),
                      is24HourMode: true,
                      normalTextStyle:
                          TextStyle(fontSize: 18, color: Colors.black26),
                      highlightedTextStyle:
                          TextStyle(fontSize: 18, color: Palette.red),
                      spacing: 10,
                      itemHeight: 40,
                      isForce2Digits: true,
                      itemWidth: 30,
                      onTimeChange: (time) {
                        setState(() {
                          _time = time;
                        });
                      },
                    ),
                    FlatButton.icon(
                      label: Text(
                        "Oggi",
                        style: TextStyle(color: Palette.red),
                      ),
                      icon: Icon(Icons.calendar_today),
                      onPressed: _pickDate,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _pickDate() async {
    _date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(seconds: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
  }
}

class ToStationPage extends StatefulWidget {
  final Station station;

  const ToStationPage({Key key, this.station}) : super(key: key);

  @override
  _ToStationPageState createState() => _ToStationPageState();
}

class _ToStationPageState extends State<ToStationPage> {
  final TextEditingController controller = TextEditingController();
  List<Station> stations = List();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(_autocomplete);
    if (widget.station != null) {
      controller.text = widget.station.nomeBreve;
    }
  }

  void _autocomplete() async {
    final res = await http.get(
        "http://www.viaggiatreno.it/viaggiatrenonew/resteasy/viaggiatreno/cercaStazione/${controller.text}");
    setState(() {
      stations = stationFromJson(res.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: 'to',
          child: Material(
              child: TextField(
            autofocus: true,
            controller: controller,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.transparent,
                hintText: "Stazione di arrivo"),
          )),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              controller.clear();
            },
          )
        ],
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(stations[index].nomeBreve),
            onTap: () {
              Navigator.pop(context, stations[index]);
            },
          );
        },
        itemCount: stations.length,
      ),
    );
  }
}

class FromStationPage extends StatefulWidget {
  final Station station;

  const FromStationPage({Key key, this.station}) : super(key: key);

  @override
  _FromStationPageState createState() => _FromStationPageState();
}

class _FromStationPageState extends State<FromStationPage> {
  final TextEditingController controller = TextEditingController();
  List<Station> stations = List();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(_autocomplete);
    if (widget.station != null) {
      controller.text = widget.station.nomeBreve;
    }
  }

  void _autocomplete() async {
    final res = await http.get(
        "http://www.viaggiatreno.it/viaggiatrenonew/resteasy/viaggiatreno/cercaStazione/${controller.text}");
    setState(() {
      stations = stationFromJson(res.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: 'from',
          child: Material(
              child: TextField(
            autofocus: true,
            controller: controller,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.transparent,
                hintText: "Stazione di partenza"),
          )),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              controller.clear();
            },
          )
        ],
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(stations[index].nomeBreve),
            onTap: () {
              Navigator.pop(context, stations[index]);
            },
          );
        },
        itemCount: stations.length,
      ),
    );
  }
}
