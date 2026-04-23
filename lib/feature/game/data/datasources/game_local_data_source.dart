import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import 'game_database.dart';
import '../models/game_session_model.dart';

abstract class GameLocalDataSource {
  Future<GameSessionModel?> getCurrentGame();

  Future<void> saveCurrentGame(GameSessionModel session);

  Future<void> clearCurrentGame();
}

class SqfliteGameLocalDataSource implements GameLocalDataSource {
  SqfliteGameLocalDataSource(this._gameDatabase);

  final GameDatabase _gameDatabase;

  @override
  Future<GameSessionModel?> getCurrentGame() async {
    final database = await _gameDatabase.database;
    final rows = await database.query(
      GameDatabase.sessionsTable,
      where: 'id = ?',
      whereArgs: const [GameDatabase.currentSessionId],
      limit: 1,
    );
    if (rows.isEmpty) {
      return null;
    }

    final rawGame = rows.first['payload'] as String;
    final decoded = jsonDecode(rawGame) as Map<String, dynamic>;
    return GameSessionModel.fromJson(decoded);
  }

  @override
  Future<void> saveCurrentGame(GameSessionModel session) async {
    final database = await _gameDatabase.database;
    await database.insert(GameDatabase.sessionsTable, {
      'id': GameDatabase.currentSessionId,
      'payload': jsonEncode(session.toJson()),
      'updated_at': DateTime.now().millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> clearCurrentGame() async {
    final database = await _gameDatabase.database;
    await database.delete(
      GameDatabase.sessionsTable,
      where: 'id = ?',
      whereArgs: const [GameDatabase.currentSessionId],
    );
  }
}
