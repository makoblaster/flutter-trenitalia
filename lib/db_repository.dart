import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:treni/model/station.dart';
import 'package:treni/model/train.dart';
import 'package:treni/model/train_route.dart';
import 'package:path/path.dart' as path;

class DbRepository {
  DbRepository._privateConstructor();

  static final DbRepository instance = DbRepository._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    return await openDatabase(
        path.join(await getDatabasesPath(), 'train_database.db'),
        onCreate: (db, version) {
      db.execute(
          "CREATE TABLE stations(id INTEGER PRIMARY KEY, nomeBreve TEXT);");
      db.execute(
          "CREATE TABLE routes(id INTEGER PRIMARY KEY, from_id INTEGER, to_id INTEGER, timestamp INTEGER, favorite INTEGER NOT NULL, " +
              "FOREIGN KEY (from_id) REFERENCES stations(id), FOREIGN KEY (to_id) REFERENCES stations(id));");
    }, version: 2);
  }

  static Future<int> insertRoute(Station from, Station to) async {
    final Database db = await DbRepository.instance.database;
    print("from id = ${from.id}");
    await db.insert('stations', from.toDbMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
    await db.insert('stations', to.toDbMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
    return await db.insert(
      'routes',
      TrainRoute(from: from, to: to, favorite: false).toDbMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  static Future<void> removeRoute(TrainRoute route) async {
    final Database db = await DbRepository.instance.database;
    await db.rawDelete("DELETE FROM routes WHERE id = ${route.id};");
  }

  static Future<void> setFavoriteRoute(TrainRoute route) async {
    int boolean = route.favorite ? 0 : 1;
    final Database db = await DbRepository.instance.database;
    await db.rawUpdate('UPDATE routes SET favorite = $boolean WHERE id = ${route.id};');
  }

  static Future<TrainRoute> getTrainRouteByStations(Station from, Station to) async {
    final Database db = await DbRepository.instance.database;
    final List<Map<String, dynamic>> maps =
    await db.rawQuery('SELECT s1.nomeBreve as fromBreve, s2.nomeBreve as toBreve, r.favorite as favorite, r.id as id, s1.id as fromId, s2.id as toId '
        'FROM routes r, stations s1, stations s2 WHERE r.from_id = ${from.id} AND r.to_id = ${to.id} AND s1.id = ${from.id} AND s2.id = ${to.id}');

    print("routes = ${maps.length}");

    if (maps.length > 0) {
      return TrainRoute(
          to: Station(nomeBreve: maps[0]['toBreve'], id: maps[0]['toId']),
          from: Station(nomeBreve: maps[0]['fromBreve'], id: maps[0]['fromId']),
          favorite: maps[0]['favorite'] == 1 ? true : false,
          id: maps[0]['id']);
    } else return null;

  }

  static Future<TrainRoute> getTrainRouteById(int id) async {
    final Database db = await DbRepository.instance.database;
    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT r.id AS route_id, s1.nomeBreve AS fromBreve, s2.nomeBreve AS toBreve, s1.id AS fromId, s2.id AS toId, r.favorite as favorite '
            'FROM routes r, stations s1, stations s2 WHERE r.id = $id AND s1.id = r.from_id AND s2.id = r.to_id LIMIT 1;');

    print(maps.toString());
    if (maps.length > 0) {
      return TrainRoute(
          to: Station(nomeBreve: maps[0]['toBreve'], id: maps[0]['toId']),
          from: Station(nomeBreve: maps[0]['fromBreve'], id: maps[0]['fromId']),
          favorite: maps[0]['favorite'] == 1 ? true : false,
          id: maps[0]['route_id']);
    } else return null;
  }

  static Future<List<TrainRoute>> favoriteRoutes() async {
    final Database db = await DbRepository.instance.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT COUNT(*) as times_used, r.id as id, s1.nomeBreve AS fromBreve, s2.nomeBreve AS toBreve, s1.id AS fromId, s2.id AS toId, r.favorite as favorite' +
            ' FROM routes r, stations s1, stations s2 WHERE r.favorite = 1 AND r.from_id = s1.id AND r.to_id = s2.id GROUP BY r.from_id, r.to_id ORDER BY COUNT(*) DESC;');

    return List.generate(maps.length, (i) {
      return TrainRoute(
          timesUsed: maps[i]['times_used'],
          to: Station(nomeBreve: maps[i]['toBreve'], id: maps[i]['toId']),
          from: Station(nomeBreve: maps[i]['fromBreve'], id: maps[i]['fromId']),
          favorite: maps[i]['favorite'] == 1 ? true : false,
          id: maps[i]['id']);
    });
  }

  static Future<List<TrainRoute>> recentRoutes(int size) async {
    final Database db = await DbRepository.instance.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT r.id as id, s1.nomeBreve AS fromBreve, s2.nomeBreve AS toBreve, s1.id AS fromId, s2.id AS toId, r.favorite as favorite' +
            ' FROM routes r, stations s1, stations s2 WHERE r.favorite = 0 AND r.from_id = s1.id AND r.to_id = s2.id ORDER BY r.timestamp DESC LIMIT $size;');


    print("recents = ${maps.length}");
    return List.generate(maps.length, (i) {
      return TrainRoute(
          timesUsed: maps[i]['times_used'],
          to: Station(nomeBreve: maps[i]['toBreve'], id: maps[i]['toId']),
          from: Station(nomeBreve: maps[i]['fromBreve'], id: maps[i]['fromId']),
          favorite: maps[i]['favorite'] == 1 ? true : false,
          id: maps[i]['id']);
    });
  }

  static Future<List<TrainRoute>> getRoutes({int size, int recents}) async {
    var routes = await favoriteRoutes();
    if (routes.length < size - recents) {
      recents = size - routes.length;
    }
    print("toget = ${recents}");
    routes.addAll(await recentRoutes(recents));
    return routes;
  }
}
