import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:treni/db_repository.dart';
import 'package:treni/solution_details.dart';
import 'package:treni/model/solutions.dart';
import 'package:treni/model/station.dart';
import 'package:http/http.dart' as http;

import 'model/palette.dart';
import 'model/train_route.dart';

class SolutionListPage extends StatefulWidget {
  final TrainRoute route;
  final DateTime time;
  final DateTime date;

  const SolutionListPage(
      {Key key,
      @required this.route,
      @required this.time,
      @required this.date})
      : super(key: key);

  @override
  _SolutionListPageState createState() => _SolutionListPageState();
}

class _SolutionListPageState extends State<SolutionListPage> {
  List<Soluzione> solutions;

  @override
  void initState() {
    super.initState();
    _search();
  }

  void _search() async {
    if (widget.route.from != null && widget.route.to != null) {
      print("http://www.viaggiatreno.it/viaggiatrenonew/resteasy/viaggiatreno/soluzioniViaggioNew/${widget.route.from.id}/${widget.route.to.id}/${DateFormat('yyyy-MM-dd').format(widget.date)}T${DateFormat('HH:mm:ss').format(widget.time)}");
      final res = await http.get(
          "http://www.viaggiatreno.it/viaggiatrenonew/resteasy/viaggiatreno/soluzioniViaggioNew/${widget.route.from.id}/${widget.route.to.id}/${DateFormat('yyyy-MM-dd').format(widget.date)}T${DateFormat('HH:mm:ss').format(widget.time)}");
      print(res.body);
      var sol = solutionRequestFromJson(res.body);

      setState(() {
        solutions = sol.soluzioni;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Text("${widget.route.from.nomeBreve}"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.arrow_forward),
            ),
            Flexible(
                fit: FlexFit.loose,
                child: Text("${widget.route.to.nomeBreve}",
                    overflow: TextOverflow.ellipsis, softWrap: false)),
          ],
        ),
        actions: <Widget>[
          IconButton(onPressed: () {
            setState(() {
              DbRepository.setFavoriteRoute(widget.route);
              widget.route.favorite = !widget.route.favorite;
            });

            },
            icon: Icon(widget.route.favorite ? Icons.favorite : Icons.favorite_border,)

          )
        ],
      ),
      body: SolutionListView(solutions: solutions),
    );
  }
}

class SolutionListView extends StatefulWidget {
  const SolutionListView({
    Key key,
    @required this.solutions,
  }) : super(key: key);

  final List<Soluzione> solutions;

  @override
  _SolutionListViewState createState() => _SolutionListViewState();
}

class _SolutionListViewState extends State<SolutionListView> {
  @override
  Widget build(BuildContext context) {
    if (widget.solutions != null) {
      if (widget.solutions.length > 0) {
        return ListView.separated(
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            Soluzione sol = widget.solutions[index];
            return Column(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    _solutionDetails(context, widget.solutions[index]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      title: Column(
                        children: <Widget>[
                          SolutionStation(
                              time: sol.vehicles[0].orarioPartenza,
                              station: sol.vehicles[0].origine),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0),
                                child: Icon(Icons.arrow_downward),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.access_time,
                                  size: 14,
                                  color: Theme
                                      .of(context)
                                      .disabledColor,
                                ),
                              ),
                              Text(
                                sol.durata,
                                style: TextStyle(color: Theme
                                    .of(context)
                                    .disabledColor),
                              ),
                            ],
                          ),
                          SolutionStation(
                              time:
                              sol.vehicles[sol.vehicles.length - 1]
                                  .orarioArrivo,
                              station:
                              sol.vehicles[sol.vehicles.length - 1]
                                  .destinazione),
                        ],
                      ),
                      subtitle: Container(
                        height: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                                fit: FlexFit.loose,
                                child: Text(
                                  "${_cambi(sol.vehicles.length - 1)}",
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                      fontSize: 13.0
                                  ),
                                )),
                            ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) =>
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: VehicleName(
                                      categoriaDescrizione:
                                      sol.vehicles[index].categoriaDescrizione,
                                      numeroTreno: sol.vehicles[index]
                                          .numeroTreno,
                                      shape: Shape.Arrow,
                                    ),
                                  ),
                              itemCount: sol.vehicles.length,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          itemCount: widget.solutions.length,
          separatorBuilder: (BuildContext context, int index) {
            return Divider();
          },
        );
      } else {
        return Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.not_interested, color: Theme.of(context).disabledColor, size: 80,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Nessuna soluzione trovata.\nProva a cercare altro.", style: TextStyle(color: Theme.of(context).disabledColor), textAlign: TextAlign.center,),
                )
              ],
            ),
          ),
        );
      }
    }
    return Center(child: CircularProgressIndicator());
  }

  String _cambi(int cambi) {
    if (cambi == 0) {
      return "";
    } else if (cambi == 1) {
      return "1 cambio: ";
    }
    return "$cambi cambi:  ";
  }

  void _solutionDetails(BuildContext context, Soluzione solution) async {
    await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              SolutionDetailsPage(
            solution: solution,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child;
          },
        ));
  }
}

class VehicleName extends StatelessWidget {
  const VehicleName({
    Key key,
    this.categoriaDescrizione,
    this.numeroTreno,
    @required this.shape,
  }) : super(key: key);

  final String categoriaDescrizione;
  final String numeroTreno;
  final Shape shape;

  @override
  Widget build(BuildContext context) {
    Color color = Palette.blue;
    if (categoriaDescrizione.toLowerCase().startsWith("freccia")) {
      color = Palette.red;
    }
    if (categoriaDescrizione.toLowerCase().startsWith("ic")) {
      color = Palette.intercity;
    }
    if (categoriaDescrizione.toLowerCase().startsWith("italo")) {
      color = Palette.lightblue;
    }
    String desc;
    if (categoriaDescrizione == "Regionale") {
      desc = "REG";
    } else if (categoriaDescrizione == "Frecciaargento") {
      desc = "FA";
    } else if (categoriaDescrizione == "Frecciabianca") {
      desc = "FB";
    } else if (categoriaDescrizione == "Frecciarossa") {
      desc = "FR";
    } else {
      desc = categoriaDescrizione;
    }

    if (shape == Shape.Arrow) {
      return CustomPaint(
        painter: ArrowPainter(
            strokeColor: color,
            paintingStyle: PaintingStyle.fill,
            strokeWidth: 10.0),
        child: Padding(
          padding: const EdgeInsets.only(left: 4.0, right: 12.0),
          child: Container(
            child: Center(
                child: Text(
              " $desc $numeroTreno ",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
            )),
          ),
        ),
      );
    } else if (shape == Shape.Square) {
      return Padding(
        padding: const EdgeInsets.only(left: 4.0, right: 12.0),
        child: Container(
          height: 40,
          child: Center(
              child: Text(
            " $desc $numeroTreno ",
            style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 18),
          )),
        ),
      );
    }
  }
}

enum Shape { Arrow, Square }

class SolutionStation extends StatelessWidget {
  const SolutionStation({
    Key key,
    @required this.time,
    this.station,
  }) : super(key: key);

  final DateTime time;
  final String station;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            "${DateFormat.Hm().format(time)} ",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            "$station",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}

class ArrowPainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  ArrowPainter(
      {this.strokeColor = Colors.black,
      this.strokeWidth = 3,
      this.paintingStyle = PaintingStyle.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    canvas.drawPath(getArrowPath(size.width, size.height), paint);
  }

  Path getArrowPath(double x, double y) {
    double pointLength = 10;
    return Path()
      ..moveTo(0, 0)
      ..lineTo(x - pointLength, 0)
      ..lineTo(x, y / 2)
      ..lineTo(x - pointLength, y)
      ..lineTo(0, y)
      ..lineTo(0, 0);
  }

  @override
  bool shouldRepaint(ArrowPainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
