import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import '../models/sample_answer_unlock_model.dart';

class SampleAnswerUnlockNotifier extends StateNotifier<List<SampleAnswerUnlock>> {
  SampleAnswerUnlockNotifier() : super([]);

  Future<Database> _getDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(
      path.join(dbPath, "sample_answer_unlock.db"),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE sample_answer_unlock(id INTEGER PRIMARY KEY AUTOINCREMENT, label_id INTEGER, app_id INTEGER, date TEXT, usage_count INTEGER)",
        );
      },
      version: 1,
    );
    return db;
  }

  Future<void> loadSampleAnswerUnlock() async {
    final db = await _getDatabase();
    final data = await db.query("sample_answer_unlock");
    final sampleAnswerUnlock = data.map((row) {
      return SampleAnswerUnlock(
        id: row["id"] as int,
        labelId: row["label_id"] as int,
        appId: row["app_id"] as int,
        date: row["date"] as String,
        usageCount: row["usage_count"] as int,
      );
    }).toList();
    state = sampleAnswerUnlock;
  }

  Future<void> removeSampleAnswerUnlock(int id) async {
    final db = await _getDatabase();
    db.delete("sample_answer_unlock", where: "id = ?", whereArgs: [id]);
    state = state.where((usage) => usage.id != id).toList();
  }

  Future<void> addSampleAnswerUnlock(int labelId, int appId) async {
    final db = await _getDatabase();
    String today = DateTime.now().toIso8601String().split('T').first;
    final data = await db.query(
      "sample_answer_unlock",
      where: "date = ? AND label_id = ? AND app_id = ?",
      whereArgs: [today, labelId, appId],
    );

    if (data.isEmpty) {
      // First usage of the day
      final id = await db.insert("sample_answer_unlock", {
        "label_id": labelId,
        "app_id": appId,
        "date": today,
        "usage_count": 1,
      });
      loadSampleAnswerUnlock();
      return;
    }

    final usageCount = data.first["usage_count"] as int;
    if (usageCount < 2) {
      final id = data.first["id"] as int;
      await db.update(
        "sample_answer_unlock",
        {"usage_count": usageCount + 1},
        where: "id = ?",
        whereArgs: [id],
      );
      loadSampleAnswerUnlock();
      return;
    }

    // Exceeded usage limit
  }

  Future<int> getUsageCount(int labelId, int appId) async {
    final db = await _getDatabase();
    String today = DateTime.now().toIso8601String().split('T').first;
    final data = await db.query(
      "sample_answer_unlock",
      where: "date = ? AND label_id = ? AND app_id = ?",
      whereArgs: [today, labelId, appId],
    );

    if (data.isNotEmpty) {
      return data.first["usage_count"] as int;
    } else {
      return 0;
    }
  }
}

final sampleAnswerUnlockProvider = StateNotifierProvider<SampleAnswerUnlockNotifier, List<SampleAnswerUnlock>>(
      (ref) => SampleAnswerUnlockNotifier(),
);
