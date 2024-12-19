import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_iq/models/recently_visited.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

class RecentlyVisitedNotifier extends StateNotifier<List<RecentlyVisited>> {
  RecentlyVisitedNotifier() : super([]);

  Future<Database> _getDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(
      path.join(dbPath, "recently_visited.db"),
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE recently_visited(app_id INTEGER, type_id TEXT, title TEXT,completedPercent TEXT,totalPercent TEXT, app_type TEXT, app_route TEXT, coach_percent REAL, PRIMARY KEY (app_id, type_id))");
      },
      version: 1,
    );
    return db;
  }

  Future<void> loadRecentlyVisited() async {
    final db = await _getDatabase();
    final data = await db.query("recently_visited");
    final recentlyVisited = data.map((row) {
      return RecentlyVisited(
          appId: row["app_id"] as int,
          typeId: row["type_id"] as String,
          title: row["title"] as String,
          appType: row["app_type"] as String,
          appRoute: row["app_route"] as String,
          completedPercent: row["completedPercent"] as String,
          totalPercent: row["totalPercent"] as String,
          coachPercent: row["coach_percent"] as double);
    }).toList();
    state = recentlyVisited.reversed.toList();
  }

  Future<void> removeRecentlyVisited() async {
    final db = await _getDatabase();
    db.delete("recently_visited");
    state = [];
  }

  void addRecentlyVisited(int appId,String title, String appType, String appRoute, String typeId,
      {double? coachPercent,String ? completedPercent,String ? totalPercent}) async {
    final newRecentlyVisited = RecentlyVisited(
        appId: appId,
        typeId: typeId,
        title: title,
        appType: appType,
        appRoute: appRoute
    );
    final db = await _getDatabase();
    //check if such item is already present id db
    final data = await db.query("recently_visited",
        where: "title = ?", whereArgs: [newRecentlyVisited.title]);

    if(data.isNotEmpty){
      db.delete("recently_visited",
          where: "title = ?", whereArgs: [newRecentlyVisited.title]);
    }
    int isInserted = await db.insert("recently_visited", {
      "app_id": newRecentlyVisited.appId,
      "type_id": newRecentlyVisited.typeId,
      "title": newRecentlyVisited.title,
      "app_type": newRecentlyVisited.appType,
      "app_route": newRecentlyVisited.appRoute,
      "totalPercent": totalPercent ?? "0",
      "completedPercent": completedPercent ?? "0",
      "coach_percent": coachPercent ?? 0.0,
    });
    if (isInserted == 0) {
      return;
    }
    loadRecentlyVisited();
    //remove least recent element if more than 5 are present in list
    if (state.length > 5) {
      db.delete("recently_visited",
          where: "type_id = ?", whereArgs: [state.last.typeId]);
      state = state.sublist(0, 5);
    }
  }
}

final recentlyVisitedProvider =
    StateNotifierProvider<RecentlyVisitedNotifier, List<RecentlyVisited>>(
        (ref) => RecentlyVisitedNotifier());
