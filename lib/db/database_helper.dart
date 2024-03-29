import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

String subjectsTable = "subjects_table";
String messagesTable = "messages_table";

final databaseProvider = FutureProvider((ref) async {
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
});

void _onCreate(Database db, int version) async {
  await db.execute("""
        CREATE TABLE IF NOT EXISTS $subjectsTable(
          row_id INTEGER PRIMARY KEY AUTOINCREMENT,
          id TEXT NOT NULL, 
          name TEXT NOT NULL,
          description TEXT,
          avatar_color TEXT,
          time_created INTEGER NOT NULL,
          time_updated INTEGER NOT NULL
        )
        """);
  await db.execute("""
        CREATE TABLE IF NOT EXISTS $messagesTable(
          row_id INTEGER PRIMARY KEY AUTOINCREMENT,
          id TEXT NOT NULL,
          body TEXT,
          time_created INTEGER NOT NULL,
          time_updated INTEGER NOT NULL,
          is_favourite BOOLEAN NOT NULL DEFAULT 0,
          subject_name TEXT NOT NULL,
          subject_row_id INTEGER NOT NULL,
          FOREIGN KEY(subject_row_id) REFERENCES $subjectsTable(row_id)
        )
        """);
}

















// import 'dart:io';

// import 'package:frontend/models/subject_model.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';

// class DatabaseHelper {
//   DatabaseHelper._privateConstructor();
//   static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

//   static Database? _database;
//   Future<Database> get database async => _database ??= await _initDatabase();

//   Future<Database> _initDatabase() async {
//     Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     String path = join(documentsDirectory.path, 'database.db');
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: (db, version) async {
//         await db.execute("CREATE TABLE IF NOT EXISTS subjects(name TEXT, avatarColor TEXT)");
//         await db.execute("""CREATE TABLE IF NOT EXISTS message_table(
//           id INTEGER AUTO INCREMENT, 
//           body TEXT, 
//           subjectName TEXT, 
//           time INTEGER)
//         """);
//       },
//     );
//   }

//   // Future _onCreate(Database db, int version) async {
//   //   await db.execute('''
//   //     CREATE TABLE IF NOT EXISTS subjects(name TEXT, avatarColor TEXT)
//   //     ''');
//   // }

//   Future<List<Subject>> getSubjects() async {
//     Database db = await instance.database;
//     var subjects = await db.query('subjects', orderBy: 'name');
//     // print(subjects);
//     List<Subject> subjectList = subjects.isNotEmpty ? subjects.map((c) => Subject.fromMap(c)).toList() : [];
//     return subjectList;
//   }

//   Future<int> add(Subject subject) async {
//     Database db = await instance.database;
//     return await db.insert('subjects', subject.toMap());
//   }

//   Future<int> remove(Subject subject) async {
//     String name = subject.name;
//     Database db = await instance.database;
//     return await db.delete('subjects', where: 'name = ?', whereArgs: [name]);
//   }

//   // Future<int> update(Subject subject) async {
//   //   Database db = await instance.database;
//   //   return await db.update('groceries', subject.toMap(), where: "id = ?", whereArgs: [subject.id]);
//   // }
// }

