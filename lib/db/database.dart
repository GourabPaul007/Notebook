import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database? _db;

  String subjectsTable = "subjects_table";
  String messagesTable = "messages_table";
  String documentsTable = "documents_table";

  // Future<Database> get db async {
  //   if (_db == null) {
  //     return await initDb();
  //   } else {
  //     return _db;
  //   }
  // }

  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  Future<Database> get database async => _db ??= await _initDb();

  Future<Database> _initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "database.db");
    return await openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute("PRAGMA foreign_keys = ON");
      },
      onCreate: _onCreate,
    );
  }

  void _onCreate(Database db, int version) async {
    await db.execute("""
        CREATE TABLE IF NOT EXISTS $subjectsTable(
          row_id INTEGER PRIMARY KEY AUTOINCREMENT,
          id TEXT NOT NULL, 
          name TEXT NOT NULL,
          description TEXT,
          avatar_color INTEGER,
          avatar_path TEXT NOT NULL,
          time_created INTEGER NOT NULL,
          time_updated INTEGER NOT NULL
        )
        """);
    await db.execute("""
        CREATE TABLE IF NOT EXISTS $messagesTable(
          row_id INTEGER PRIMARY KEY AUTOINCREMENT,
          id TEXT NOT NULL,
          title TEXT NOT NULL,
          body TEXT NOT NULL,
          color INTEGER NOT NULL,
          time_created INTEGER NOT NULL,
          time_updated INTEGER NOT NULL,
          type TEXT NOT NULL,
          is_favourite BOOLEAN NOT NULL DEFAULT 0,
          subject_name TEXT NOT NULL,
          subject_row_id INTEGER NOT NULL,
          FOREIGN KEY(subject_row_id) REFERENCES $subjectsTable(row_id)
        )
        """);

    // The Documents Table in 2nd page
    await db.execute("""
        CREATE TABLE IF NOT EXISTS $documentsTable(
          row_id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          about TEXT NOT NULL,
          path TEXT NOT NULL,
          size INTEGER NOT NULL,
          type TEXT NOT NULL,
          color INTEGER NOT NULL,
          time_added INTEGER NOT NULL,
          time_updated INTEGER NOT NULL,
          is_favourite BOOLEAN NOT NULL DEFAULT 0
        )
        """);
    // await db.execute("""
    //   CREATE INDEX
    // """);
  }
}
