import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  DatabaseHelper._instance();
  static Database? _db = null;

  String noteTable = "note_table";
  String colId = 'id';
  String colTitle = 'title';
  String colDate = 'date';
  String colPriority = 'priority';
  String colStatus = 'status';

  Future<Database?> get db async {
    if (_db == null) {
      _db=await _initDB();
    }

    return _db;
  }

  Future<Database> _initDB() async {

    Directory dir= await getApplicationDocumentsDirectory();
    String path= dir.path + 'todo_list.db';
    final todoListDB=await openDatabase(

      path,
      version: 1,
      onCreate: createDB
    );
    return todoListDB;
  }

  void createDB(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $noteTable('
            '$colId INTEGER PRIMARY KEY AUTOINCREMENT,'
            ' $colTitle TEXT,'
            ' $colDate TEXT,'
            ' $colPriority TEXT,'
            ' $colStatus INTEGER  '
            ')');
  }
}
