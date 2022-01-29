import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper {
  static Future<sql.Database> database() async {
    final db_path = await sql.getDatabasesPath();
    return await sql.openDatabase(path.join(db_path, 'auth.db'),
        onCreate: (db, version) {
      return db.execute('CREATE TABLE creds(id TEXT PRIMARY KEY, pass TEXT)');
    }, version: 1);
  }

  static Future<void> insert(String loginId, String password) async {
    final db = await DBHelper.database();
    db.insert('creds', {'id': loginId, 'pass': password},
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    db.close();
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    final db = await DBHelper.database();

    final res = await db.query('creds');
    db.close();
    return res;
  }
}
