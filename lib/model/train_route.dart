import 'package:treni/model/station.dart';

class TrainRoute{
  int id;
  int timesUsed = 0;
  Station from;
  Station to;
  bool favorite = false;

  TrainRoute({this.from, this.to, this.timesUsed, this.favorite, this.id});

  Map<String, dynamic> toDbMap() => {
    'from_id': from.id,
    'to_id': to.id,
    'timestamp': DateTime.now().millisecondsSinceEpoch,
    'favorite': favorite ? 1 : 0
  };
}