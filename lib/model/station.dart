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
  int id;

  Station({
    this.nomeLungo,
    this.nomeBreve,
    this.label,
    this.id,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    int id = extractId(json["id"]);

    return Station(
        nomeLungo: json["nomeLungo"],
        nomeBreve: json["nomeBreve"],
        label: json["label"] == null ? null : json["label"],
        id: id
    );
  }

  Map<String, dynamic> toJson() => {
    "nomeLungo": nomeLungo,
    "nomeBreve": nomeBreve,
    "label": label == null ? null : label,
    "id": getFormattedId(),
  };

  Map<String, dynamic> toDbMap() => {
    "nomeBreve": nomeBreve,
    "id": id
  };

  String getFormattedId(){
    return "S" + id.toString().padLeft(5, '0');
  }

  static int extractId(String sid){
    return int.parse(sid.substring(1));
  }
}
