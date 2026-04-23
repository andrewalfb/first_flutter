import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class GameDatabase {
  static const databaseName = 'game_state.db';
  static const sessionsTable = 'game_sessions';
  static const currentSessionId = 1;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    final databasesPath = await getDatabasesPath();
    final databasePath = path.join(databasesPath, databaseName);
    _database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $sessionsTable (
            id INTEGER PRIMARY KEY,
            payload TEXT NOT NULL,
            updated_at INTEGER NOT NULL
          )
        ''');
      },
    );
    return _database!;
  }
}
