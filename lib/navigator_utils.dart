import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:treni/db_repository.dart';
import 'package:treni/solution_list.dart';

import 'model/station.dart';
import 'model/train_route.dart';

class NavigatorUtils{
  static void searchSolutions(BuildContext context, {DateTime date, DateTime time, Station from, Station to, }) async {
    if (date != null && time != null && from != null && to != null) {

      TrainRoute route = await DbRepository.getTrainRouteByStations(from, to);
      if (route == null) {
        int id = await DbRepository.insertRoute(from, to);
        print("id = $id");
        route = await DbRepository.getTrainRouteById(id);
        print("route = ${route}, ${route.from.nomeBreve}");
      }
      await Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                SolutionListPage(
                  route: route,
                  date: date,
                  time: time,
                ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return child;
            },
          ));
    }
  }
}