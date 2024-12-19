import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_iq/models/save_draft_answer_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

class SaveDraftAnswerNotifier extends StateNotifier<List<SaveDraftAnswer>> {
  SaveDraftAnswerNotifier() : super([]);

  Future<Database> _getDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(
      path.join(dbPath, "save_draft_answer.db"),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE save_draft_answer(id INTEGER PRIMARY KEY AUTOINCREMENT, label_id INTEGER, app_id INTEGER, problem_id INTEGER, draft_answer TEXT)",
        );
      },
      version: 1,
    );
    return db;
  }

  Future<void> loadSaveDraftAnswer() async {
    final db = await _getDatabase();
    final data = await db.query("save_draft_answer");
    final saveDraftAnswer = data.map((row) {
      return SaveDraftAnswer(
        id: row["id"] as int,
        labelId: row["label_id"] as int,
        appId: row["app_id"] as int,
        problemId: row["problem_id"] as int,  // Added problemId
        draftAnswer: row["draft_answer"] as String,
      );
    }).toList();
    state = saveDraftAnswer;
  }

  Future<SaveDraftAnswer?> getDraftAnswer(int labelId, int appId, int problemId) async {
    final db = await _getDatabase();
    final data = await db.query(
      "save_draft_answer",
      where: "label_id = ? AND app_id = ? AND problem_id = ?",
      whereArgs: [labelId, appId, problemId],  // Updated whereArgs
    );

    if (data.isNotEmpty) {
      final row = data.first;
      return SaveDraftAnswer(
        id: row["id"] as int,
        labelId: row["label_id"] as int,
        appId: row["app_id"] as int,
        problemId: row["problem_id"] as int,
        draftAnswer: row["draft_answer"] as String,
      );
    } else {
      return null;
    }
  }

  Future<String> addSaveDraftAnswer(int labelId, int appId, int problemId, String draftAnswer) async {
    final db = await _getDatabase();

    // Check if an answer already exists with the same labelId, appId, problemId, and draftAnswer
    final existingSameAnswer = await db.query(
      "save_draft_answer",
      where: "label_id = ? AND app_id = ? AND problem_id = ? AND draft_answer = ?",
      whereArgs: [labelId, appId, problemId, draftAnswer],  // Updated whereArgs
    );

    if (existingSameAnswer.isNotEmpty) {
      return 'exists';
    }

    // Check if an answer exists with the same labelId, appId, problemId, but different draftAnswer
    final existingDifferentAnswer = await db.query(
      "save_draft_answer",
      where: "label_id = ? AND app_id = ? AND problem_id = ?",
      whereArgs: [labelId, appId, problemId],  // Updated whereArgs
    );

    if (existingDifferentAnswer.isNotEmpty) {
      final id = existingDifferentAnswer.first["id"] as int;
      await db.update(
        "save_draft_answer",
        {"draft_answer": draftAnswer},
        where: "id = ?",
        whereArgs: [id],
      );
      loadSaveDraftAnswer();
      return 'updated';
    }

    // Insert the new answer
    await db.insert("save_draft_answer", {
      "label_id": labelId,
      "app_id": appId,
      "problem_id": problemId,  // Added problemId
      "draft_answer": draftAnswer,
    });
    loadSaveDraftAnswer();
    return 'saved';
  }

  Future<void> removeSaveDraftAnswer(int id) async {
    final db = await _getDatabase();
    await db.delete("save_draft_answer", where: "id = ?", whereArgs: [id]);
    state = state.where((draft) => draft.id != id).toList();
  }
}

final saveDraftAnswerProvider = StateNotifierProvider<SaveDraftAnswerNotifier, List<SaveDraftAnswer>>(
      (ref) => SaveDraftAnswerNotifier(),
);
