
TrainOrigin trainOriginFromString(String line) => TrainOrigin.fromString(line);

class TrainOrigin{
  final String stationCode;
  final int trainCode;

  TrainOrigin({this.stationCode, this.trainCode});

  factory TrainOrigin.fromString(String input){
    return TrainOrigin(
      stationCode: input.substring(input.lastIndexOf("-")+1, input.length-1),
      trainCode: int.parse(input.substring(0, input.indexOf(" ")))
    );
  }
}
