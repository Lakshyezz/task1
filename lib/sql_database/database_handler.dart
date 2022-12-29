import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseHandler {
  static Database? _database;
  static final DataBaseHandler _dataBaseHandler = DataBaseHandler._internal();

  factory DataBaseHandler() {
    return _dataBaseHandler;
  }

  DataBaseHandler._internal(); //

  Future<Database?> openDB() async {
    _database = await openDatabase(join(await getDatabasesPath(), "User.db"));
    return _database;
  }
}
