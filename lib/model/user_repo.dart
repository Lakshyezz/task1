import 'package:sqflite/sqflite.dart';

class UserRepo {
  void createTable(Database? db) {
    db?.execute(
        'CREATE TABLE USER(id INTEGER PRIMARY KEY, idFromAPI INTEGER,name TEXT,username TEXT,email TEXT)');
  }
}
