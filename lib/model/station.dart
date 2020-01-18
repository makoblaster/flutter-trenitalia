// To parse this JSON data, do
//
//     final station = stationFromJson(jsonString);

import 'dart:convert';

List<Station> stationFromJson(String str) => List<Station>.from(json.decode(str).map((x) => Station.fromJson(x)));

String stationToJson(List<Station> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Station {
  String nomeLungo;
  String nomeBreve;
  String label;
  String id;

  Station({
    this.nomeLungo,
    this.nomeBreve,
    this.label,
    this.id,
  });

  factory Station.fromJson(Map<String, dynamic> json) => Station(
    nomeLungo: json["nomeLungo"],
    nomeBreve: json["nomeBreve"],
    label: json["label"] == null ? null : json["label"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "nomeLungo": nomeLungo,
    "nomeBreve": nomeBreve,
    "label": label == null ? null : label,
    "id": id,
  };

  int getCode(){
    return int.parse(id.substring(1));
  }
}
