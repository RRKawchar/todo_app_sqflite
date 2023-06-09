import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app_sqflite/models/note.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  DatabaseHelper._instance();
  static Database? _db;

  String noteTable = "note_table";
  String colId = 'id';
  String colTitle = 'title';
  String colDate = 'date';
  String colPriority = 'priority';
  String colStatus = 'status';

  Future<Database?> get db async {
    _db ??= await _initDB();

    return _db;
  }

  Future<Database> _initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'todo_list.db';
    final todoListDB = await openDatabase(path, version: 1, onCreate: createDB);
    return todoListDB;
  }

  void createDB(Database db, int version) async {
    await db.execute('CREATE TABLE $noteTable('
        '$colId INTEGER PRIMARY KEY AUTOINCREMENT,'
        ' $colTitle TEXT,'
        ' $colDate TEXT,'
        ' $colPriority TEXT,'
        ' $colStatus INTEGER  '
        ')');
  }

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database? db = await instance.db;
    final List<Map<String, dynamic>> result = await db!.query(noteTable);

    return result;
  }

  Future<List<Note>> getNoteList() async {
    final List<Map<String, dynamic>> noteMapList = await getNoteMapList();

    final List<Note> noteList = [];

    noteMapList.forEach((noteMap) {
      noteList.add(Note.fromMap(noteMap));
    });
    noteList.sort((noteA, noteB) => noteA.date!.compareTo(noteB.date!));

    return noteList;
  }

  Future<int> insertNote(Note note) async {
    Database? db = await instance.db;
    final int result = await db!.insert(
      noteTable,
      note.toMap(),
    );
    return result;
  }

  Future<int> updateNote(Note note) async {
    Database? db = await instance.db;
    final int result = await db!.update(
      noteTable,
      note.toMap(),
      where: '$colId=?',
      whereArgs: [note.id],
    );
    return result;
  }

  Future<int> deleteNote(int id) async {
    Database? db = await instance.db;

    final int result =
        await db!.delete(noteTable, where: 'id=?', whereArgs: [id]);

    return result;
  }
}
