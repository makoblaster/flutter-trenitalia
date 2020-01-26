// To parse this JSON data, do
//
//     final train = trainFromJson(jsonString);

import 'dart:convert';

Train trainFromJson(String str) => Train.fromJson(json.decode(str));

String trainToJson(Train data) => json.encode(data.toJson());

class Train {
  int getCurrentStationIndex() {
    for (int i  = 0; i < fermate.length; i++){
      if (fermate[i].stazione == stazioneUltimoRilevamento){
        return i;
      }
    }
    return -1;
  }

  int getFermataPartenzaIndexByTime(DateTime orarioPartenza) {
    for (int i  = 0; i < fermate.length; i++){
      DateTime trainTime = DateTime.fromMillisecondsSinceEpoch(fermate[i].partenzaTeorica);
      if (trainTime.hour == orarioPartenza.hour && trainTime.minute == orarioPartenza.minute){
        return i;
      }
    }
    return -1;
  }

  int getFermataArrivoIndexByTime(DateTime orarioArrivo){
    for (int i  = 0; i < fermate.length; i++){
      DateTime trainTime = DateTime.fromMillisecondsSinceEpoch(fermate[i].programmata);
      if (trainTime.hour == orarioArrivo.hour && trainTime.minute == orarioArrivo.minute){
        return i;
      }
    }
    return -1;
  }

  Fermata getFermataPartenzaByTime(DateTime orarioPartenza){
    return fermate.firstWhere((x) {
      DateTime trainTime = DateTime.fromMillisecondsSinceEpoch(x.partenzaTeorica);
      print("${trainTime.hour}:${trainTime.minute} - ${orarioPartenza.hour}:${orarioPartenza.minute}");
      return trainTime.hour == orarioPartenza.hour && trainTime.minute == orarioPartenza.minute;
    });
  }

  String tipoTreno;
  dynamic orientamento;
  int codiceCliente;
  dynamic fermateSoppresse;
  dynamic dataPartenza;
  List<Fermata> fermate;
  dynamic anormalita;
  dynamic provvedimenti;
  dynamic segnalazioni;
  int oraUltimoRilevamento;
  String stazioneUltimoRilevamento;
  String idDestinazione;
  String idOrigine;
  List<CambiNumero> cambiNumero;
  bool hasProvvedimenti;
  List<String> descOrientamento;
  String compOraUltimoRilevamento;
  dynamic motivoRitardoPrevalente;
  String descrizioneVco;
  dynamic materialeLabel;
  int numeroTreno;
  String categoria;
  dynamic categoriaDescrizione;
  String origine;
  dynamic codOrigine;
  String destinazione;
  dynamic codDestinazione;
  dynamic origineEstera;
  dynamic destinazioneEstera;
  dynamic oraPartenzaEstera;
  dynamic oraArrivoEstera;
  int tratta;
  int regione;
  String origineZero;
  String destinazioneZero;
  int orarioPartenzaZero;
  int orarioArrivoZero;
  bool circolante;
  dynamic binarioEffettivoArrivoCodice;
  dynamic binarioEffettivoArrivoDescrizione;
  dynamic binarioEffettivoArrivoTipo;
  dynamic binarioProgrammatoArrivoCodice;
  dynamic binarioProgrammatoArrivoDescrizione;
  dynamic binarioEffettivoPartenzaCodice;
  dynamic binarioEffettivoPartenzaDescrizione;
  dynamic binarioEffettivoPartenzaTipo;
  dynamic binarioProgrammatoPartenzaCodice;
  dynamic binarioProgrammatoPartenzaDescrizione;
  String subTitle;
  String esisteCorsaZero;
  bool inStazione;
  bool haCambiNumero;
  bool nonPartito;
  int provvedimento;
  dynamic riprogrammazione;
  int orarioPartenza;
  int orarioArrivo;
  dynamic stazionePartenza;
  dynamic stazioneArrivo;
  dynamic statoTreno;
  dynamic corrispondenze;
  List<dynamic> servizi;
  int ritardo;
  String tipoProdotto;
  String compOrarioPartenzaZeroEffettivo;
  String compOrarioArrivoZeroEffettivo;
  String compOrarioPartenzaZero;
  String compOrarioArrivoZero;
  String compOrarioArrivo;
  String compOrarioPartenza;
  String compNumeroTreno;
  List<String> compOrientamento;
  String compTipologiaTreno;
  String compClassRitardoTxt;
  String compClassRitardoLine;
  String compImgRitardo2;
  String compImgRitardo;
  List<String> compRitardo;
  List<String> compRitardoAndamento;
  List<String> compInStazionePartenza;
  List<String> compInStazioneArrivo;
  String compOrarioEffettivoArrivo;
  String compDurata;
  String compImgCambiNumerazione;

  Train({
    this.tipoTreno,
    this.orientamento,
    this.codiceCliente,
    this.fermateSoppresse,
    this.dataPartenza,
    this.fermate,
    this.anormalita,
    this.provvedimenti,
    this.segnalazioni,
    this.oraUltimoRilevamento,
    this.stazioneUltimoRilevamento,
    this.idDestinazione,
    this.idOrigine,
    this.cambiNumero,
    this.hasProvvedimenti,
    this.descOrientamento,
    this.compOraUltimoRilevamento,
    this.motivoRitardoPrevalente,
    this.descrizioneVco,
    this.materialeLabel,
    this.numeroTreno,
    this.categoria,
    this.categoriaDescrizione,
    this.origine,
    this.codOrigine,
    this.destinazione,
    this.codDestinazione,
    this.origineEstera,
    this.destinazioneEstera,
    this.oraPartenzaEstera,
    this.oraArrivoEstera,
    this.tratta,
    this.regione,
    this.origineZero,
    this.destinazioneZero,
    this.orarioPartenzaZero,
    this.orarioArrivoZero,
    this.circolante,
    this.binarioEffettivoArrivoCodice,
    this.binarioEffettivoArrivoDescrizione,
    this.binarioEffettivoArrivoTipo,
    this.binarioProgrammatoArrivoCodice,
    this.binarioProgrammatoArrivoDescrizione,
    this.binarioEffettivoPartenzaCodice,
    this.binarioEffettivoPartenzaDescrizione,
    this.binarioEffettivoPartenzaTipo,
    this.binarioProgrammatoPartenzaCodice,
    this.binarioProgrammatoPartenzaDescrizione,
    this.subTitle,
    this.esisteCorsaZero,
    this.inStazione,
    this.haCambiNumero,
    this.nonPartito,
    this.provvedimento,
    this.riprogrammazione,
    this.orarioPartenza,
    this.orarioArrivo,
    this.stazionePartenza,
    this.stazioneArrivo,
    this.statoTreno,
    this.corrispondenze,
    this.servizi,
    this.ritardo,
    this.tipoProdotto,
    this.compOrarioPartenzaZeroEffettivo,
    this.compOrarioArrivoZeroEffettivo,
    this.compOrarioPartenzaZero,
    this.compOrarioArrivoZero,
    this.compOrarioArrivo,
    this.compOrarioPartenza,
    this.compNumeroTreno,
    this.compOrientamento,
    this.compTipologiaTreno,
    this.compClassRitardoTxt,
    this.compClassRitardoLine,
    this.compImgRitardo2,
    this.compImgRitardo,
    this.compRitardo,
    this.compRitardoAndamento,
    this.compInStazionePartenza,
    this.compInStazioneArrivo,
    this.compOrarioEffettivoArrivo,
    this.compDurata,
    this.compImgCambiNumerazione,
  });

  factory Train.fromJson(Map<String, dynamic> json) => Train(
    tipoTreno: json["tipoTreno"],
    orientamento: json["orientamento"],
    codiceCliente: json["codiceCliente"],
    fermateSoppresse: json["fermateSoppresse"],
    dataPartenza: json["dataPartenza"],
    fermate: List<Fermata>.from(json["fermate"].map((x) => Fermata.fromJson(x))),
    anormalita: json["anormalita"],
    provvedimenti: json["provvedimenti"],
    segnalazioni: json["segnalazioni"],
    oraUltimoRilevamento: json["oraUltimoRilevamento"],
    stazioneUltimoRilevamento: json["stazioneUltimoRilevamento"],
    idDestinazione: json["idDestinazione"],
    idOrigine: json["idOrigine"],
    cambiNumero: List<CambiNumero>.from(json["cambiNumero"].map((x) => CambiNumero.fromJson(x))),
    hasProvvedimenti: json["hasProvvedimenti"],
    descOrientamento: List<String>.from(json["descOrientamento"].map((x) => x)),
    compOraUltimoRilevamento: json["compOraUltimoRilevamento"],
    motivoRitardoPrevalente: json["motivoRitardoPrevalente"],
    descrizioneVco: json["descrizioneVCO"],
    materialeLabel: json["materiale_label"],
    numeroTreno: json["numeroTreno"],
    categoria: json["categoria"],
    categoriaDescrizione: json["categoriaDescrizione"],
    origine: json["origine"],
    codOrigine: json["codOrigine"],
    destinazione: json["destinazione"],
    codDestinazione: json["codDestinazione"],
    origineEstera: json["origineEstera"],
    destinazioneEstera: json["destinazioneEstera"],
    oraPartenzaEstera: json["oraPartenzaEstera"],
    oraArrivoEstera: json["oraArrivoEstera"],
    tratta: json["tratta"],
    regione: json["regione"],
    origineZero: json["origineZero"],
    destinazioneZero: json["destinazioneZero"],
    orarioPartenzaZero: json["orarioPartenzaZero"],
    orarioArrivoZero: json["orarioArrivoZero"],
    circolante: json["circolante"],
    binarioEffettivoArrivoCodice: json["binarioEffettivoArrivoCodice"],
    binarioEffettivoArrivoDescrizione: json["binarioEffettivoArrivoDescrizione"],
    binarioEffettivoArrivoTipo: json["binarioEffettivoArrivoTipo"],
    binarioProgrammatoArrivoCodice: json["binarioProgrammatoArrivoCodice"],
    binarioProgrammatoArrivoDescrizione: json["binarioProgrammatoArrivoDescrizione"],
    binarioEffettivoPartenzaCodice: json["binarioEffettivoPartenzaCodice"],
    binarioEffettivoPartenzaDescrizione: json["binarioEffettivoPartenzaDescrizione"],
    binarioEffettivoPartenzaTipo: json["binarioEffettivoPartenzaTipo"],
    binarioProgrammatoPartenzaCodice: json["binarioProgrammatoPartenzaCodice"],
    binarioProgrammatoPartenzaDescrizione: json["binarioProgrammatoPartenzaDescrizione"],
    subTitle: json["subTitle"],
    esisteCorsaZero: json["esisteCorsaZero"],
    inStazione: json["inStazione"],
    haCambiNumero: json["haCambiNumero"],
    nonPartito: json["nonPartito"],
    provvedimento: json["provvedimento"],
    riprogrammazione: json["riprogrammazione"],
    orarioPartenza: json["orarioPartenza"],
    orarioArrivo: json["orarioArrivo"],
    stazionePartenza: json["stazionePartenza"],
    stazioneArrivo: json["stazioneArrivo"],
    statoTreno: json["statoTreno"],
    corrispondenze: json["corrispondenze"],
    servizi: List<dynamic>.from(json["servizi"].map((x) => x)),
    ritardo: json["ritardo"],
    tipoProdotto: json["tipoProdotto"],
    compOrarioPartenzaZeroEffettivo: json["compOrarioPartenzaZeroEffettivo"],
    compOrarioArrivoZeroEffettivo: json["compOrarioArrivoZeroEffettivo"],
    compOrarioPartenzaZero: json["compOrarioPartenzaZero"],
    compOrarioArrivoZero: json["compOrarioArrivoZero"],
    compOrarioArrivo: json["compOrarioArrivo"],
    compOrarioPartenza: json["compOrarioPartenza"],
    compNumeroTreno: json["compNumeroTreno"],
    compOrientamento: List<String>.from(json["compOrientamento"].map((x) => x)),
    compTipologiaTreno: json["compTipologiaTreno"],
    compClassRitardoTxt: json["compClassRitardoTxt"],
    compClassRitardoLine: json["compClassRitardoLine"],
    compImgRitardo2: json["compImgRitardo2"],
    compImgRitardo: json["compImgRitardo"],
    compRitardo: List<String>.from(json["compRitardo"].map((x) => x)),
    compRitardoAndamento: List<String>.from(json["compRitardoAndamento"].map((x) => x)),
    compInStazionePartenza: List<String>.from(json["compInStazionePartenza"].map((x) => x)),
    compInStazioneArrivo: List<String>.from(json["compInStazioneArrivo"].map((x) => x)),
    compOrarioEffettivoArrivo: json["compOrarioEffettivoArrivo"],
    compDurata: json["compDurata"],
    compImgCambiNumerazione: json["compImgCambiNumerazione"],
  );

  Map<String, dynamic> toJson() => {
    "tipoTreno": tipoTreno,
    "orientamento": orientamento,
    "codiceCliente": codiceCliente,
    "fermateSoppresse": fermateSoppresse,
    "dataPartenza": dataPartenza,
    "fermate": List<dynamic>.from(fermate.map((x) => x.toJson())),
    "anormalita": anormalita,
    "provvedimenti": provvedimenti,
    "segnalazioni": segnalazioni,
    "oraUltimoRilevamento": oraUltimoRilevamento,
    "stazioneUltimoRilevamento": stazioneUltimoRilevamento,
    "idDestinazione": idDestinazione,
    "idOrigine": idOrigine,
    "cambiNumero": List<dynamic>.from(cambiNumero.map((x) => x.toJson())),
    "hasProvvedimenti": hasProvvedimenti,
    "descOrientamento": List<dynamic>.from(descOrientamento.map((x) => x)),
    "compOraUltimoRilevamento": compOraUltimoRilevamento,
    "motivoRitardoPrevalente": motivoRitardoPrevalente,
    "descrizioneVCO": descrizioneVco,
    "materiale_label": materialeLabel,
    "numeroTreno": numeroTreno,
    "categoria": categoria,
    "categoriaDescrizione": categoriaDescrizione,
    "origine": origine,
    "codOrigine": codOrigine,
    "destinazione": destinazione,
    "codDestinazione": codDestinazione,
    "origineEstera": origineEstera,
    "destinazioneEstera": destinazioneEstera,
    "oraPartenzaEstera": oraPartenzaEstera,
    "oraArrivoEstera": oraArrivoEstera,
    "tratta": tratta,
    "regione": regione,
    "origineZero": origineZero,
    "destinazioneZero": destinazioneZero,
    "orarioPartenzaZero": orarioPartenzaZero,
    "orarioArrivoZero": orarioArrivoZero,
    "circolante": circolante,
    "binarioEffettivoArrivoCodice": binarioEffettivoArrivoCodice,
    "binarioEffettivoArrivoDescrizione": binarioEffettivoArrivoDescrizione,
    "binarioEffettivoArrivoTipo": binarioEffettivoArrivoTipo,
    "binarioProgrammatoArrivoCodice": binarioProgrammatoArrivoCodice,
    "binarioProgrammatoArrivoDescrizione": binarioProgrammatoArrivoDescrizione,
    "binarioEffettivoPartenzaCodice": binarioEffettivoPartenzaCodice,
    "binarioEffettivoPartenzaDescrizione": binarioEffettivoPartenzaDescrizione,
    "binarioEffettivoPartenzaTipo": binarioEffettivoPartenzaTipo,
    "binarioProgrammatoPartenzaCodice": binarioProgrammatoPartenzaCodice,
    "binarioProgrammatoPartenzaDescrizione": binarioProgrammatoPartenzaDescrizione,
    "subTitle": subTitle,
    "esisteCorsaZero": esisteCorsaZero,
    "inStazione": inStazione,
    "haCambiNumero": haCambiNumero,
    "nonPartito": nonPartito,
    "provvedimento": provvedimento,
    "riprogrammazione": riprogrammazione,
    "orarioPartenza": orarioPartenza,
    "orarioArrivo": orarioArrivo,
    "stazionePartenza": stazionePartenza,
    "stazioneArrivo": stazioneArrivo,
    "statoTreno": statoTreno,
    "corrispondenze": corrispondenze,
    "servizi": List<dynamic>.from(servizi.map((x) => x)),
    "ritardo": ritardo,
    "tipoProdotto": tipoProdotto,
    "compOrarioPartenzaZeroEffettivo": compOrarioPartenzaZeroEffettivo,
    "compOrarioArrivoZeroEffettivo": compOrarioArrivoZeroEffettivo,
    "compOrarioPartenzaZero": compOrarioPartenzaZero,
    "compOrarioArrivoZero": compOrarioArrivoZero,
    "compOrarioArrivo": compOrarioArrivo,
    "compOrarioPartenza": compOrarioPartenza,
    "compNumeroTreno": compNumeroTreno,
    "compOrientamento": List<dynamic>.from(compOrientamento.map((x) => x)),
    "compTipologiaTreno": compTipologiaTreno,
    "compClassRitardoTxt": compClassRitardoTxt,
    "compClassRitardoLine": compClassRitardoLine,
    "compImgRitardo2": compImgRitardo2,
    "compImgRitardo": compImgRitardo,
    "compRitardo": List<dynamic>.from(compRitardo.map((x) => x)),
    "compRitardoAndamento": List<dynamic>.from(compRitardoAndamento.map((x) => x)),
    "compInStazionePartenza": List<dynamic>.from(compInStazionePartenza.map((x) => x)),
    "compInStazioneArrivo": List<dynamic>.from(compInStazioneArrivo.map((x) => x)),
    "compOrarioEffettivoArrivo": compOrarioEffettivoArrivo,
    "compDurata": compDurata,
    "compImgCambiNumerazione": compImgCambiNumerazione,
  };


}

class CambiNumero {
  String nuovoNumeroTreno;
  String stazione;

  CambiNumero({
    this.nuovoNumeroTreno,
    this.stazione,
  });

  factory CambiNumero.fromJson(Map<String, dynamic> json) => CambiNumero(
    nuovoNumeroTreno: json["nuovoNumeroTreno"],
    stazione: json["stazione"],
  );

  Map<String, dynamic> toJson() => {
    "nuovoNumeroTreno": nuovoNumeroTreno,
    "stazione": stazione,
  };
}

class Fermata {
  dynamic orientamento;
  dynamic kcNumTreno;
  String stazione;
  String id;
  dynamic listaCorrispondenze;
  int programmata;
  dynamic programmataZero;
  int effettiva;
  int ritardo;
  dynamic partenzaTeoricaZero;
  dynamic arrivoTeoricoZero;
  int partenzaTeorica;
  int arrivoTeorico;
  bool isNextChanged;
  int partenzaReale;
  int arrivoReale;
  int ritardoPartenza;
  int ritardoArrivo;
  int progressivo;
  String binarioEffettivoArrivoCodice;
  String binarioEffettivoArrivoTipo;
  String binarioEffettivoArrivoDescrizione;
  dynamic binarioProgrammatoArrivoCodice;
  String binarioProgrammatoArrivoDescrizione;
  String binarioEffettivoPartenzaCodice;
  String binarioEffettivoPartenzaTipo;
  String binarioEffettivoPartenzaDescrizione;
  dynamic binarioProgrammatoPartenzaCodice;
  String binarioProgrammatoPartenzaDescrizione;
  String tipoFermata;
  bool visualizzaPrevista;
  bool nextChanged;
  int nextTrattaType;
  int actualFermataType;
  dynamic materialeLabel;

  Fermata({
    this.orientamento,
    this.kcNumTreno,
    this.stazione,
    this.id,
    this.listaCorrispondenze,
    this.programmata,
    this.programmataZero,
    this.effettiva,
    this.ritardo,
    this.partenzaTeoricaZero,
    this.arrivoTeoricoZero,
    this.partenzaTeorica,
    this.arrivoTeorico,
    this.isNextChanged,
    this.partenzaReale,
    this.arrivoReale,
    this.ritardoPartenza,
    this.ritardoArrivo,
    this.progressivo,
    this.binarioEffettivoArrivoCodice,
    this.binarioEffettivoArrivoTipo,
    this.binarioEffettivoArrivoDescrizione,
    this.binarioProgrammatoArrivoCodice,
    this.binarioProgrammatoArrivoDescrizione,
    this.binarioEffettivoPartenzaCodice,
    this.binarioEffettivoPartenzaTipo,
    this.binarioEffettivoPartenzaDescrizione,
    this.binarioProgrammatoPartenzaCodice,
    this.binarioProgrammatoPartenzaDescrizione,
    this.tipoFermata,
    this.visualizzaPrevista,
    this.nextChanged,
    this.nextTrattaType,
    this.actualFermataType,
    this.materialeLabel,
  });

  factory Fermata.fromJson(Map<String, dynamic> json) => Fermata(
    orientamento: json["orientamento"],
    kcNumTreno: json["kcNumTreno"],
    stazione: json["stazione"],
    id: json["id"],
    listaCorrispondenze: json["listaCorrispondenze"],
    programmata: json["programmata"],
    programmataZero: json["programmataZero"],
    effettiva: json["effettiva"],
    ritardo: json["ritardo"],
    partenzaTeoricaZero: json["partenzaTeoricaZero"],
    arrivoTeoricoZero: json["arrivoTeoricoZero"],
    partenzaTeorica: json["partenza_teorica"] == null ? null : json["partenza_teorica"],
    arrivoTeorico: json["arrivo_teorico"] == null ? null : json["arrivo_teorico"],
    isNextChanged: json["isNextChanged"],
    partenzaReale: json["partenzaReale"] == null ? null : json["partenzaReale"],
    arrivoReale: json["arrivoReale"] == null ? null : json["arrivoReale"],
    ritardoPartenza: json["ritardoPartenza"],
    ritardoArrivo: json["ritardoArrivo"],
    progressivo: json["progressivo"],
    binarioEffettivoArrivoCodice: json["binarioEffettivoArrivoCodice"] == null ? null : json["binarioEffettivoArrivoCodice"],
    binarioEffettivoArrivoTipo: json["binarioEffettivoArrivoTipo"] == null ? null : json["binarioEffettivoArrivoTipo"],
    binarioEffettivoArrivoDescrizione: json["binarioEffettivoArrivoDescrizione"] == null ? null : json["binarioEffettivoArrivoDescrizione"],
    binarioProgrammatoArrivoCodice: json["binarioProgrammatoArrivoCodice"],
    binarioProgrammatoArrivoDescrizione: json["binarioProgrammatoArrivoDescrizione"] == null ? null : json["binarioProgrammatoArrivoDescrizione"],
    binarioEffettivoPartenzaCodice: json["binarioEffettivoPartenzaCodice"] == null ? null : json["binarioEffettivoPartenzaCodice"],
    binarioEffettivoPartenzaTipo: json["binarioEffettivoPartenzaTipo"] == null ? null : json["binarioEffettivoPartenzaTipo"],
    binarioEffettivoPartenzaDescrizione: json["binarioEffettivoPartenzaDescrizione"] == null ? null : json["binarioEffettivoPartenzaDescrizione"],
    binarioProgrammatoPartenzaCodice: json["binarioProgrammatoPartenzaCodice"],
    binarioProgrammatoPartenzaDescrizione: json["binarioProgrammatoPartenzaDescrizione"] == null ? null : json["binarioProgrammatoPartenzaDescrizione"],
    tipoFermata: json["tipoFermata"],
    visualizzaPrevista: json["visualizzaPrevista"],
    nextChanged: json["nextChanged"],
    nextTrattaType: json["nextTrattaType"],
    actualFermataType: json["actualFermataType"],
    materialeLabel: json["materiale_label"],
  );

  Map<String, dynamic> toJson() => {
    "orientamento": orientamento,
    "kcNumTreno": kcNumTreno,
    "stazione": stazione,
    "id": id,
    "listaCorrispondenze": listaCorrispondenze,
    "programmata": programmata,
    "programmataZero": programmataZero,
    "effettiva": effettiva,
    "ritardo": ritardo,
    "partenzaTeoricaZero": partenzaTeoricaZero,
    "arrivoTeoricoZero": arrivoTeoricoZero,
    "partenza_teorica": partenzaTeorica == null ? null : partenzaTeorica,
    "arrivo_teorico": arrivoTeorico == null ? null : arrivoTeorico,
    "isNextChanged": isNextChanged,
    "partenzaReale": partenzaReale == null ? null : partenzaReale,
    "arrivoReale": arrivoReale == null ? null : arrivoReale,
    "ritardoPartenza": ritardoPartenza,
    "ritardoArrivo": ritardoArrivo,
    "progressivo": progressivo,
    "binarioEffettivoArrivoCodice": binarioEffettivoArrivoCodice == null ? null : binarioEffettivoArrivoCodice,
    "binarioEffettivoArrivoTipo": binarioEffettivoArrivoTipo == null ? null : binarioEffettivoArrivoTipo,
    "binarioEffettivoArrivoDescrizione": binarioEffettivoArrivoDescrizione == null ? null : binarioEffettivoArrivoDescrizione,
    "binarioProgrammatoArrivoCodice": binarioProgrammatoArrivoCodice,
    "binarioProgrammatoArrivoDescrizione": binarioProgrammatoArrivoDescrizione == null ? null : binarioProgrammatoArrivoDescrizione,
    "binarioEffettivoPartenzaCodice": binarioEffettivoPartenzaCodice == null ? null : binarioEffettivoPartenzaCodice,
    "binarioEffettivoPartenzaTipo": binarioEffettivoPartenzaTipo == null ? null : binarioEffettivoPartenzaTipo,
    "binarioEffettivoPartenzaDescrizione": binarioEffettivoPartenzaDescrizione == null ? null : binarioEffettivoPartenzaDescrizione,
    "binarioProgrammatoPartenzaCodice": binarioProgrammatoPartenzaCodice,
    "binarioProgrammatoPartenzaDescrizione": binarioProgrammatoPartenzaDescrizione == null ? null : binarioProgrammatoPartenzaDescrizione,
    "tipoFermata": tipoFermata,
    "visualizzaPrevista": visualizzaPrevista,
    "nextChanged": nextChanged,
    "nextTrattaType": nextTrattaType,
    "actualFermataType": actualFermataType,
    "materiale_label": materialeLabel,
  };
}
