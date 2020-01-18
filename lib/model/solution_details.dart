import 'dart:ui';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:treni/model/palette.dart';
import 'package:treni/model/solutions.dart';
import 'package:http/http.dart' as http;
import 'package:treni/model/train.dart';
import 'package:treni/model/train_origin.dart';

import '../solution_list.dart';

class SolutionDetailsPage extends StatefulWidget {
  final Soluzione solution;

  const SolutionDetailsPage({Key key, this.solution}) : super(key: key);

  @override
  _SolutionPageState createState() => _SolutionPageState();
}

class _SolutionPageState extends State<SolutionDetailsPage> {
  Train train;
  int currentStopIndex = 5;

  @override
  void initState() {
    super.initState();
    _trainDetails(widget.solution.vehicles[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Dettagli soluzione"),
        ),
        body: train != null
            ? Column(
                children: <Widget>[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ExpandablePanel(
                        header: VehicleName(
                          categoriaDescrizione:
                              widget.solution.vehicles[0].categoriaDescrizione,
                          numeroTreno: widget.solution.vehicles[0].numeroTreno,
                          shape: Shape.Square,
                        ),
                        collapsed: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            height: 80,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 4.0),
                              child: ListView(
                                children: <Widget>[
                                  StationView(
                                    isFirstStation: true,
                                    stopType: StopType.Current,
                                    stationName:
                                        train.fermate[currentStopIndex].stazione, 
                                    stopTime: DateTime.fromMillisecondsSinceEpoch(train.fermate[currentStopIndex].arrivoTeorico),
                                  ),
                                  StationView(
                                    isFirstStation: false,
                                    stopType: StopType.Future,
                                    stationName: train
                                        .fermate[train.fermate.length - 1]
                                        .stazione,
                                    stopTime: DateTime.fromMillisecondsSinceEpoch(train.fermate[train.fermate.length - 1].arrivoTeorico),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        expanded: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            height: 500,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  StopType stopType = StopType.Current;
                                  if (currentStopIndex < index) {
                                    stopType = StopType.Past;
                                  } else if (currentStopIndex > index) {
                                    stopType = StopType.Future;
                                  }

                                  return StationView(
                                    isFirstStation: index == 0 ? true : false,
                                    stopType: stopType,
                                    stationName: train.fermate[index].stazione, 
                                    stopTime: DateTime.fromMillisecondsSinceEpoch(train.fermate[index].arrivoTeorico),
                                  );
                                },
                                itemCount: train.fermate.length,
                              ),
                            ),
                          ),
                        ),
                        tapHeaderToExpand: true,
                        hasIcon: true,
                      ),
                    ),
                  )
                ],
              )
            : Center(child: CircularProgressIndicator()));
  }

  void _trainDetails(Vehicle vehicle) async {
    final startRes = await http.get(
        "http://www.viaggiatreno.it/viaggiatrenonew/resteasy/viaggiatreno/cercaNumeroTrenoTrenoAutocomplete/${vehicle.numeroTreno}");
    TrainOrigin trainOrigin = trainOriginFromString(startRes.body);
    final res = await http.get(
        "http://www.viaggiatreno.it/viaggiatrenonew/resteasy/viaggiatreno/andamentoTreno/${trainOrigin.stationCode}/${trainOrigin.trainCode}");
    print(res.body);
    setState(() {
      train = trainFromJson(res.body);
      print(train.numeroTreno);
    });
  }
}

class StationView extends StatelessWidget {
  final bool isFirstStation;
  final StopType stopType;
  final String stationName;
  final DateTime stopTime;

  const StationView({
    Key key,
    @required this.isFirstStation,
    @required this.stopType,
    @required this.stationName,
    @required this.stopTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: CustomPaint(
        painter:
            StopPainter(isFirstStation: isFirstStation, stationType: stopType),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(left: 60.0, top: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(stationName),
                stopTime == null ? Text("--:--") :
                Text(DateFormat.Hm().format(stopTime))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum StopType { Past, Current, Future }

class StopPainter extends CustomPainter {
  final bool isFirstStation;
  final StopType stationType;

  StopPainter({this.isFirstStation, this.stationType});

  @override
  void paint(Canvas canvas, Size size) {
    Color color;
    switch (stationType) {
      case StopType.Past:
        color = Palette.lightblue;
        break;
      case StopType.Current:
        color = Palette.orange;
        break;
      case StopType.Future:
        color = Palette.blue;
        break;
    }

    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = stationType == StopType.Current
          ? PaintingStyle.stroke
          : PaintingStyle.stroke;

    double radius = 10;
    double length = 15;
    Offset startOffset = Offset(radius * 2, radius);

    if (!isFirstStation) {
      canvas.drawLine(Offset(startOffset.dx, startOffset.dy - radius),
          Offset(startOffset.dx, startOffset.dy - radius - length), paint);
    }
    canvas.drawCircle(startOffset, radius, paint);
  }

  @override
  bool shouldRepaint(StopPainter oldDelegate) {
    return oldDelegate.isFirstStation != isFirstStation ||
        oldDelegate.stationType != stationType;
  }
}
