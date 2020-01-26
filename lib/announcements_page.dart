import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:treni/model/scioperi.dart';
import 'package:http/http.dart' as http;

class AnnouncementsPage extends StatelessWidget {
  const AnnouncementsPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _scioperi(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        List<Record> scioperi = snapshot.data;
        if (scioperi.length == 0) {
          return Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.announcement,
                    color: Theme.of(context).disabledColor,
                    size: 80,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Nessun annuncio",
                      style: TextStyle(color: Theme.of(context).disabledColor),
                    ),
                  )
                ],
              ),
            ),
          );
        }
        return ListView.builder(
            itemCount: scioperi.length,
            itemBuilder: (context, index) {
              Record sciopero = scioperi[index];
              return ListTile(
                title: Text("${sciopero.nomeRegione}: ${sciopero.sindacato}"),
                subtitle: Text(
                    "Da ${DateFormat.MEd().format(sciopero.dataInizio)} alle ${DateFormat.Hm().format(sciopero.dataInizio)} "
                        "- ${DateFormat.MEd().format(sciopero.dataFine)} alle ${DateFormat.Hm().format(sciopero.dataFine)}"),
              );
            });
      },
    );
  }

  Future<List<Record>> _scioperi() async {
    final res = await http.get(
        "http://dati.mit.gov.it/catalog/api/action/datastore_search?resource_id=6838feb1-1f3d-40dc-845f-d304088a92cd&q=Ferroviario&limit=15");
    Scioperi scioperi = scioperiFromJson(res.body);
    List<Record> result = List();
    if (scioperi.success) {
      var records = scioperi.result.records;
      for (var record in records) {
        if (record.dataInizio.compareTo(DateTime.now()) > 0) {
          result.add(record);
        }
      }
    }
    return result;
  }
}