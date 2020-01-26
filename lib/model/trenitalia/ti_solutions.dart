// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

TISolutionRequest solutionRequestFromJson(String str) => TISolutionRequest.fromJson(json.decode(str));

String solutionRequestToJson(TISolutionRequest data) => json.encode(data.toJson());

class TISolutionRequest {
  List<TISoluzione> soluzioni;
  String origine;
  String destinazione;
  dynamic errore;

  TISolutionRequest({
    this.soluzioni,
    this.origine,
    this.destinazione,
    this.errore,
  });

  factory TISolutionRequest.fromJson(Map<String, dynamic> json) => TISolutionRequest(
    soluzioni: List<TISoluzione>.from(json["soluzioni"].map((x) => TISoluzione.fromJson(x))),
    origine: json["origine"],
    destinazione: json["destinazione"],
    errore: json["errore"],
  );

  Map<String, dynamic> toJson() => {
    "soluzioni": List<dynamic>.from(soluzioni.map((x) => x.toJson())),
    "origine": origine,
    "destinazione": destinazione,
    "errore": errore,
  };
}

class TISoluzione {
  String durata;
  List<TIVehicle> vehicles;

  TISoluzione({
    this.durata,
    this.vehicles,
  });

  factory TISoluzione.fromJson(Map<String, dynamic> json) => TISoluzione(
    durata: json["durata"],
    vehicles: List<TIVehicle>.from(json["vehicles"].map((x) => TIVehicle.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "durata": durata,
    "vehicles": List<dynamic>.from(vehicles.map((x) => x.toJson())),
  };
}

class TIVehicle {
  String origine;
  String destinazione;
  DateTime orarioPartenza;
  DateTime orarioArrivo;
  String categoria;
  String categoriaDescrizione;
  String numeroTreno;

  TIVehicle({
    this.origine,
    this.destinazione,
    this.orarioPartenza,
    this.orarioArrivo,
    this.categoria,
    this.categoriaDescrizione,
    this.numeroTreno,
  });

  factory TIVehicle.fromJson(Map<String, dynamic> json) => TIVehicle(
    origine: json["origine"],
    destinazione: json["destinazione"],
    orarioPartenza: DateTime.parse(json["orarioPartenza"]),
    orarioArrivo: DateTime.parse(json["orarioArrivo"]),
    categoria: json["categoria"],
    categoriaDescrizione: json["categoriaDescrizione"],
    numeroTreno: json["numeroTreno"],
  );

  Map<String, dynamic> toJson() => {
    "origine": origine,
    "destinazione": destinazione,
    "orarioPartenza": orarioPartenza.toIso8601String(),
    "orarioArrivo": orarioArrivo.toIso8601String(),
    "categoria": categoria,
    "categoriaDescrizione": categoriaDescrizione,
    "numeroTreno": numeroTreno,
  };
}
