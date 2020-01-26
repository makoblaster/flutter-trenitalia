import 'package:treni/model/trenitalia/ti_train.dart';

class Stop{
  String name;
  int id;
  DateTime arriveTime;
  DateTime arriveTimeWithDelay;
  DateTime leaveTime;
  DateTime leaveTimeWithDelay;
  int delay;

  Stop({this.id, this.name, this.arriveTime, this.leaveTime, this.arriveTimeWithDelay, this.leaveTimeWithDelay, this.delay});

  factory Stop.fromFermata(TIFermata fermata){
    return Stop(
      id: int.parse(fermata.id.substring(1)),
      name: fermata.stazione,
      arriveTime: DateTime.fromMillisecondsSinceEpoch(fermata.arrivoTeorico),
      leaveTime: DateTime.fromMillisecondsSinceEpoch(fermata.partenzaTeorica),
      arriveTimeWithDelay: DateTime.fromMillisecondsSinceEpoch(fermata.arrivoReale),
      leaveTimeWithDelay: DateTime.fromMillisecondsSinceEpoch(fermata.partenzaReale),
      delay: fermata.ritardo
    );
  }
}