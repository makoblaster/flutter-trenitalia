import 'package:treni/model/trains/stop.dart';
import 'package:treni/model/trains/train.dart';
import 'package:treni/model/trenitalia/ti_solutions.dart';
import 'package:treni/model/trenitalia/ti_train.dart';

class SearchResult{
  List<Train> trains;
  Duration duration;

  SearchResult({this.trains, this.duration});

  factory SearchResult.fromTISoluzione(TISoluzione sol, List<TITrain> TItrains){
    List<Train> trains = List();
    for (TIVehicle vehicle in sol.vehicles){
      trains.add(Train.fromTIVehicle(vehicle, TItrains.firstWhere((x) => x.numeroTreno == int.parse(vehicle.numeroTreno.substring(1)))));
    }
    
    return SearchResult(
      trains: trains
    );
  }
}