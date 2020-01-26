

import 'package:flutter/material.dart';

import 'db_repository.dart';
import 'model/trains/train_route.dart';
import 'navigator_utils.dart';

class RecentPage extends StatefulWidget {
  const RecentPage({Key key, int navIndex}) : super(key: key);

  @override
  _RecentPageState createState() => _RecentPageState();
}

class _RecentPageState extends State<RecentPage> {
  Future<bool> doNotRemove() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    var db = DbRepository.instance;
    return Container(
        child: SafeArea(
            child: Column(
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        "Tieni premuto a lungo per cercare subito, scorri per eliminare o aggiungere ai preferiti",
                        style: Theme.of(context).textTheme.caption,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                FutureBuilder(
                    future: DbRepository.getRoutes(size: 10, recents: 3),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData)
                        return Center(child: CircularProgressIndicator());
                      List<TrainRoute> routes = snapshot.data;
                      if (routes.length == 0) {
                        return Container(
                          alignment: Alignment.center,
                          child: Center(

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.train,
                                  color: Theme.of(context).disabledColor,
                                  size: 80,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Nessuna tratta.\nEsegui una ricerca.",
                                    style: Theme.of(context).textTheme.caption,
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var route = routes[index];
                          return Dismissible(
                            key: Key(route.id.toString()),
                            direction: DismissDirection.horizontal,
                            background: Container(
                              color: Theme.of(context).accentColor,
                              alignment: AlignmentDirectional.centerStart,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 32.0),
                                child: Icon(Icons.delete, color: Colors.white),
                              ),
                            ),
                            secondaryBackground: Container(
                              color: Colors.amber,
                              alignment: AlignmentDirectional.centerEnd,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 32.0),
                                child: Icon(
                                  route.favorite
                                      ? Icons.favorite_border
                                      : Icons.favorite,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            confirmDismiss: (direction) async {
                              switch (direction) {
                                case DismissDirection.startToEnd:
                                  return true;
                                case DismissDirection.endToStart:
                                  setState(() {
                                    DbRepository.setFavoriteRoute(route);
                                  });
                                  return false;
                                default:
                                  return false;
                              }
                            },
                            onDismissed: (direction) {
                              switch (direction) {
                                case DismissDirection.startToEnd:
                                  DbRepository.removeRoute(route);
                                  setState(() {
                                    routes.remove(route);
                                  });
                                  break;
                                default:
                                  break;
                              }
                            },
                            child: Container(
                              color: route.favorite
                                  ? Colors.amber[100]
                                  : Colors.transparent,
                              child: ListTile(
                                  contentPadding: const EdgeInsets.all(4.0),
                                  onLongPress: () {
                                    print(
                                        "${route.from.nomeBreve} - ${route.to.nomeBreve}");
                                    NavigatorUtils.searchSolutions(
                                      context,
                                      date: DateTime.now(),
                                      time: DateTime.now(),
                                      from: route.from,
                                      to: route.to,
                                    );
                                  },
//                                  onTap: () {
//                                    setState(() {
//                                      _from = route.from;
//                                      _to = route.to;
//                                      _time = DateTime.now();
//                                      _date = DateTime.now();
//                                    });
//                                  },
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(left: 16.0),
                                        child: Text(
                                          "${route.from.nomeBreve}",
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                          style: Theme.of(context).textTheme.body2,
                                        ),
                                      ),
                                      Icon(Icons.arrow_forward),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 16.0),
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            "${route.to.nomeBreve}",
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            style: Theme.of(context).textTheme.body2,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          );
                        },
                        itemCount: routes.length,
                        separatorBuilder: (BuildContext context, int index) => Divider(
                          height: 1,
                        ),
                      );
                    }),
              ],
            )));
  }
}