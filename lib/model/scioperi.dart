// To parse this JSON data, do
//
//     final scioperi = scioperiFromJson(jsonString);

import 'dart:convert';

Scioperi scioperiFromJson(String str) => Scioperi.fromJson(json.decode(str));

String scioperiToJson(Scioperi data) => json.encode(data.toJson());

class Scioperi {
  String help;
  bool success;
  Result result;

  Scioperi({
    this.help,
    this.success,
    this.result,
  });

  factory Scioperi.fromJson(Map<String, dynamic> json) => Scioperi(
    help: json["help"],
    success: json["success"],
    result: Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "help": help,
    "success": success,
    "result": result.toJson(),
  };
}

class Result {
  String resourceId;
  List<Field> fields;
  List<Record> records;
  Links links;
  int limit;
  int total;

  Result({
    this.resourceId,
    this.fields,
    this.records,
    this.links,
    this.limit,
    this.total,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    resourceId: json["resource_id"],
    fields: List<Field>.from(json["fields"].map((x) => Field.fromJson(x))),
    records: List<Record>.from(json["records"].map((x) => Record.fromJson(x))),
    links: Links.fromJson(json["_links"]),
    limit: json["limit"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "resource_id": resourceId,
    "fields": List<dynamic>.from(fields.map((x) => x.toJson())),
    "records": List<dynamic>.from(records.map((x) => x.toJson())),
    "_links": links.toJson(),
    "limit": limit,
    "total": total,
  };
}

class Field {
  String type;
  String id;

  Field({
    this.type,
    this.id,
  });

  factory Field.fromJson(Map<String, dynamic> json) => Field(
    type: json["type"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "id": id,
  };
}

class Links {
  String start;
  String next;

  Links({
    this.start,
    this.next,
  });

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    start: json["start"],
    next: json["next"],
  );

  Map<String, dynamic> toJson() => {
    "start": start,
    "next": next,
  };
}

class Record {
  String categoria;
  DateTime dataProclamazione;
  String settore;
  String modalita;
  String nomeProvincia;
  DateTime dataInizio;
  DateTime dataRicezione;
  String note;
  String sindacato;
  String nomeRegione;
  DateTime dataFine;
  int id;
  String rilevanza;

  Record({
    this.categoria,
    this.dataProclamazione,
    this.settore,
    this.modalita,
    this.nomeProvincia,
    this.dataInizio,
    this.dataRicezione,
    this.note,
    this.sindacato,
    this.nomeRegione,
    this.dataFine,
    this.id,
    this.rilevanza,
  });

  factory Record.fromJson(Map<String, dynamic> json) => Record(
    categoria: json["categoria"],
    dataProclamazione: DateTime.parse(json["dataProclamazione"]),
    settore: json["settore"],
    modalita: json["modalita"],
    nomeProvincia: json["nome_provincia"],
    dataInizio: DateTime.parse(json["dataInizio"]),
    dataRicezione: DateTime.parse(json["dataRicezione"]),
    note: json["note"],
    sindacato: json["sindacato"],
    nomeRegione: json["nome_regione"],
    dataFine: DateTime.parse(json["dataFine"]),
    id: json["_id"],
    rilevanza: json["rilevanza"],
  );

  Map<String, dynamic> toJson() => {
    "categoria": categoria,
    "dataProclamazione": dataProclamazione.toIso8601String(),
    "settore": settore,
    "modalita": modalita,
    "nome_provincia": nomeProvincia,
    "dataInizio": dataInizio.toIso8601String(),
    "dataRicezione": dataRicezione.toIso8601String(),
    "note": note,
    "sindacato": sindacato,
    "nome_regione": nomeRegione,
    "dataFine": dataFine.toIso8601String(),
    "_id": id,
    "rilevanza": rilevanza,
  };
}
