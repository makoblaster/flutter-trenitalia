// To parse this JSON data, do
//
//     final station = stationFromJson(jsonString);

import 'dart:convert';

List<TIStation> stationFromJson(String str) => List<TIStation>.from(json.decode(str).map((x) => TIStation.fromJson(x)));

String stationToJson(List<TIStation> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TIStation {
  String nomeLungo;
  String nomeBreve;
  String label;
  int id;

  TIStation({
    this.nomeLungo,
    this.nomeBreve,
    this.label,
    this.id,
  });

  factory TIStation.fromJson(Map<String, dynamic> json) {
    int id = extractId(json["id"]);

    return TIStation(
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
