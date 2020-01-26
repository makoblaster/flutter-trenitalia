import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'model/trenitalia/ti_station.dart';
import 'navigator_utils.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  DateTime _date;
  DateTime _time;
  TIStation _from;
  TIStation _to;

  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();

  Future<TIStation> _goToStationSearch(BuildContext context, String animationTag, TIStation station) async {
    TIStation result = await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              StationAutocompleteSearch(
                station: station,
                animationTag: animationTag,
              ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child;
          },
        ));
    print("${result.nomeBreve} a");
    return result;
  }

  Future<void> _fromSearch() async{
    TIStation from = await _goToStationSearch(context, 'from', _from);
    print("${from.nomeBreve} a");
    setState(() {
      fromController.text = from.nomeBreve;
      _from = from;
    });

  }

  Future<void> _toSearch() async{
    TIStation to = await _goToStationSearch(context, 'to', _to);
    print("${to.nomeBreve} a");
    setState(() {
      toController.text = to.nomeBreve;
      _to = to;
    });
  }

  @override
  void initState() {
    _date = DateTime.now();
    _time = DateTime.now();
    fromController.text = _from?.nomeBreve ?? "";
    toController.text = _to?.nomeBreve ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.bottomRight, children: <Widget>[
      OrientationBuilder(
        builder: (context, orientation) => GridView.count(
            crossAxisCount: orientation == Orientation.portrait ? 1 : 2,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            childAspectRatio: 16 / 10,
            children: <Widget>[
              Column(children: <Widget>[
                Padding(
                  padding:
                  const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Align(
                            child: Text(
                              "TRENO DA",
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.w700),
                            ),
                            alignment: Alignment.bottomLeft,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _fromSearch();
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
                                              borderRadius:
                                              BorderRadius.circular(128.0),
                                              borderSide: BorderSide(
                                                width: 0.8,
                                              )),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 24.0),
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
                  padding:
                  const EdgeInsets.only(top: 36.0, left: 16.0, right: 16.0),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Align(
                            child: Text(
                              "TRENO PER",
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.w700),
                            ),
                            alignment: Alignment.bottomLeft,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _toSearch();
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
                                              borderRadius:
                                              BorderRadius.circular(128.0),
                                              borderSide: BorderSide(
                                                width: 0.8,
                                              )),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 24.0),
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
              ]),
              Padding(
                padding: const EdgeInsets.only(
                    top: 16.0, left: 16.0, right: 16.0, bottom: 64.0),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Align(
                          child: Text(
                            "TRENO ALLE",
                            style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontWeight: FontWeight.w700),
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
                            normalTextStyle: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).disabledColor),
                            highlightedTextStyle: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).accentColor),
                            spacing: 10,
                            itemHeight: 40,
                            isForce2Digits: true,
                            itemWidth: 30,
                            onTimeChange: (time) {
                              if (time != null) {
                                setState(() {
                                  _time = time;
                                });
                              }
                            },
                          ),
                          FlatButton.icon(
                            label: Text(
                              DateFormat.yMMMd().format(_date),
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
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
            ]),
      ),
      Container(
        child: Padding(
          padding: const EdgeInsets.only(right: 32.0),
          child: RaisedButton.icon(
            onPressed: () {
              NavigatorUtils.searchSolutions(context,
                  to: _to, from: _from, date: _date, time: _time);
            },
            icon: Icon(Icons.search),
            label: Text("CERCA"),
            textTheme: ButtonTextTheme.primary,
          ),
        ),
      )
    ]);
  }

  void _pickDate() async {
    var date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(seconds: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    setState(() {
      _date = date;
    });
  }
}

class StationAutocompleteSearch extends StatefulWidget {
  final TIStation station;
  final String animationTag;

  const StationAutocompleteSearch({Key key, this.station, @required this.animationTag}) : super(key: key);

  @override
  _StationAutocompleteSearchState createState() => _StationAutocompleteSearchState();
}

class _StationAutocompleteSearchState extends State<StationAutocompleteSearch> {
  final TextEditingController controller = TextEditingController();
  List<TIStation> stations = List();

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
    if (controller.text != ""){
      final res = await http.get(
          "http://www.viaggiatreno.it/viaggiatrenonew/resteasy/viaggiatreno/cercaStazione/${controller.text}");
      if (this.mounted){
        setState(() {
          stations = stationFromJson(res.body);
        });
      }
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: widget.animationTag,
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
              print(stations[index].nomeBreve);
              Navigator.pop(context, stations[index]);
            },
          );
        },
        itemCount: stations.length,
      ),
    );
  }
}