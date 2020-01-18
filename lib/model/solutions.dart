// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

SolutionRequest solutionRequestFromJson(String str) => SolutionRequest.fromJson(json.decode(str));

String solutionRequestToJson(SolutionRequest data) => json.encode(data.toJson());

class SolutionRequest {
  List<Soluzione> soluzioni;
  String origine;
  String destinazione;
  dynamic errore;

  SolutionRequest({
    this.soluzioni,
    this.origine,
    this.destinazione,
    this.errore,
  });

  factory SolutionRequest.fromJson(Map<String, dynamic> json) => SolutionRequest(
    soluzioni: List<Soluzione>.from(json["soluzioni"].map((x) => Soluzione.fromJson(x))),
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

class Soluzione {
  String durata;
  List<Vehicle> vehicles;

  Soluzione({
    this.durata,
    this.vehicles,
  });

  factory Soluzione.fromJson(Map<String, dynamic> json) => Soluzione(
    durata: json["durata"],
    vehicles: List<Vehicle>.from(json["vehicles"].map((x) => Vehicle.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "durata": durata,
    "vehicles": List<dynamic>.from(vehicles.map((x) => x.toJson())),
  };
}

class Vehicle {
  String origine;
  String destinazione;
  DateTime orarioPartenza;
  DateTime orarioArrivo;
  String categoria;
  String categoriaDescrizione;
  String numeroTreno;

  Vehicle({
    this.origine,
    this.destinazione,
    this.orarioPartenza,
    this.orarioArrivo,
    this.categoria,
    this.categoriaDescrizione,
    this.numeroTreno,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
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
