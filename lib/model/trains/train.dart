import 'package:treni/model/trains/stop.dart';
import 'package:treni/model/trenitalia/ti_solutions.dart';
import 'package:treni/model/trenitalia/ti_train.dart';

class Train{
  String trainName;
  int delay;
  List<Stop> stops;

  Train({this.delay, this.stops, this.trainName});

  factory Train.fromTIVehicle(TIVehicle vehicle, TITrain train){
    List<Stop> stops = List();
    for (TIFermata fermata in train.fermate){
      stops.add(Stop.fromFermata(fermata));
    }
    return Train(
      trainName: vehicle.categoriaDescrizione + vehicle.numeroTreno,
      delay: train.ritardo,
      stops: stops
    );
  }
}