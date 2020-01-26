import 'dart:ui';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:treni/model/palette.dart';
import 'package:treni/model/trenitalia/ti_solutions.dart';
import 'package:http/http.dart' as http;
import 'package:treni/model/trenitalia/ti_train.dart';
import 'package:treni/model/trains/train_origin.dart';

import 'solution_list.dart';

class SolutionDetailsPage extends StatefulWidget {
  final TISoluzione solution;

  const SolutionDetailsPage({Key key, this.solution}) : super(key: key);

  @override
  _SolutionPageState createState() => _SolutionPageState();
}

class _SolutionPageState extends State<SolutionDetailsPage> {
  int currentStopIndex = 5;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Dettagli soluzione"),
        ),
        body: ListView.builder(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: widget.solution.vehicles.length,
            itemBuilder: (context, index) {
              TIVehicle vehicle = widget.solution.vehicles[index];
              return FutureBuilder(
                future: _trainDetails(vehicle),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ));
                  TITrain train = snapshot.data;

                  int originIndex = train.getFermataPartenzaIndexByTime(vehicle.orarioPartenza);
                  TIFermata origin = train.fermate[originIndex];

                  int destinationIndex =
                      train.getFermataArrivoIndexByTime(vehicle.orarioArrivo);
                  TIFermata destination = train.fermate[destinationIndex];

                  int currentStation = train.getCurrentStationIndex();

                  return Card(
                    margin: EdgeInsets.all(16.0),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ExpandablePanel(
                          header: VehicleName(
                            shape: Shape.Square,
                            numeroTreno: vehicle.numeroTreno,
                            categoriaDescrizione: vehicle.categoriaDescrizione,
                          ),
                          collapsed: Column(
                            children: <Widget>[
                              StationView(
                                isFirstStation: true,
                                stopType: _getStopType(index, currentStation),
                                stationName: origin.stazione,
                                stopTime: DateTime.fromMillisecondsSinceEpoch(
                                    origin.partenzaTeorica),
                              ),
                              StationView(
                                isFirstStation: false,
                                stopType: _getStopType(destinationIndex, currentStation),
                                stationName: destination.stazione,
                                stopTime: DateTime.fromMillisecondsSinceEpoch(
                                    destination.programmata),
                              ),
                            ],
                          ),
                        expanded: ListView.builder(physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                          TIFermata fermata = train.fermate[index];
                          DateTime arrivo;
                          if (fermata.arrivoTeorico != null) {
                            arrivo = DateTime.fromMillisecondsSinceEpoch(
                                fermata.arrivoTeorico);
                          }
                          return StationView(
                            isFirstStation: index == 0 ? true : false,
                            stopType: _getStopType(index, currentStation),
                            stationName: fermata.stazione,
                            stopTime: arrivo ?? DateTime.now(),
                          );
                        },
                        itemCount: train.fermate.length,
                        shrinkWrap: true,),

                      ),
                    ),
                  );
                },
              );
            }));
  }

  StopType _getStopType(int index, int currentStation){
    if (index > currentStation) {
      return StopType.Past;
    }
    if (index == currentStation) {
      return StopType.Current;
    }
    return StopType.Future;
  }

  Future<TITrain> _trainDetails(TIVehicle vehicle) async {
    final startRes = await http.get(
        "http://www.viaggiatreno.it/viaggiatrenonew/resteasy/viaggiatreno/cercaNumeroTrenoTrenoAutocomplete/${vehicle.numeroTreno}");
    TrainOrigin trainOrigin = trainOriginFromString(startRes.body);
    final res = await http.get(
        "http://www.viaggiatreno.it/viaggiatrenonew/resteasy/viaggiatreno/andamentoTreno/${trainOrigin.stationCode}/${trainOrigin.trainCode}");
    return trainFromJson(res.body);
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
    this.stopTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: CustomPaint(
        painter:
            StopPainter(isFirstStation: isFirstStation, stationType: stopType),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(left: 60.0, top: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              
              children: <Widget>[
                Flexible(
                  fit: FlexFit.loose,
                  child: Text(
                    stationName,
                    style: TextStyle(fontSize: 16),
                    overflow: TextOverflow.fade,
                    softWrap: false,
                  ),
                ),
                stopTime == null
                    ? Text("--:--")
                    : Padding(
                        padding: const EdgeInsets.only(right: 16.0, left: 8.0),
                        child: Text(DateFormat.Hm().format(stopTime),
                            style: TextStyle(fontSize: 16)),
                      )
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
        color = Palette.intercity;
        break;
      case StopType.Future:
        color = Palette.blue;
        break;
    }

    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = stationType == StopType.Future
          ? PaintingStyle.stroke
          : PaintingStyle.fill;

    double radius = 10;
    double length = 26;
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
