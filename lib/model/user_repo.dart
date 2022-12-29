import 'package:sqflite/sqflite.dart';

class UserRepo {
  void createTable(Database? db) {
    db?.execute(
        'CREATE TABLE IF NOT EXISTS USER(id INTEGER PRIMARY KEY, idFromAPI INTEGER,name TEXT)');
  }

  Future<List<Map<String, dynamic>>> getUsers(Database? db) async {
    final List<Map<String, dynamic>> maps = await db!.query('User');
    print(maps);
    return maps;
  }
}
