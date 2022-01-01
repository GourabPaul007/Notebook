import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:frontend/models/message_model.dart';
import 'package:frontend/models/subject_overview_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database? _db;

  // Future<Database> get db async {
  //   if (_db == null) {
  //     return await initDb();
  //   } else {
  //     return _db;
  //   }
  // }

  Future<Database> get database async => _db ??= await initDb();

  Future<Database> initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "database.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  void _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE IF NOT EXISTS subjects(name TEXT, avatarColor TEXT)");
    await db.execute("""CREATE TABLE IF NOT EXISTS message_table(
          _id INTEGER AUTO INCREMENT,
          id TEXT,
          body TEXT,
          subjectName TEXT,
          timeCreated INTEGER)
        """);
  }

  Future<List<Subject>> getSubjects() async {
    Database db = await database;
    var subjects = await db.query('subjects', orderBy: 'name');
    print(subjects);
    List<Subject> subjectList = subjects.isNotEmpty ? subjects.map((c) => Subject.fromMap(c)).toList() : [];
    // db.close();
    return subjectList;
  }

  Future<int> addSubject(Subject subject) async {
    print(subject);
    int returnCode = -1;
    try {
      Database db = await database;
      returnCode = await db.insert(
        'subjects',
        subject.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
      // db.close();
    } catch (e) {
      debugPrint(e.toString());
    }
    return returnCode;
  }

  // Future<List<Employee>> getEmployees() async {
  //   var dbClient = await db;
  //   List<Map> list = await dbClient.rawQuery('SELECT * FROM Employee');
  //   List<Employee> employees = new List();
  //   for (int i = 0; i < list.length; i++) {
  //     employees.add(new Employee(list[i]["firstname"], list[i]["lastname"], list[i]["mobileno"], list[i]["emailid"]));
  //   }
  //   print(employees.length);
  //   return employees;
  // }

// ===============================================================================================================
// ===============================================================================================================
// ===============================================================================================================

// Messages

  Future<List<Message>> getMessagesDatabase(String subjectName) async {
    Database db = await database;
    var messages = await db.query(
      'message_table',
      where: 'subjectName = ?',
      whereArgs: [subjectName],
      orderBy: 'timeCreated DESC',
    );
    print(messages);
    List<Message> messageList = messages.isNotEmpty ? messages.map((c) => Message.fromMap(c)).toList() : [];
    return messageList;
  }

  Future<int> addMessageDatabase(Message message) async {
    Database db = await database;
    return await db.insert(
      'message_table',
      message.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<int> deleteMessagesDatabase(
    // Message message,
    List<int> timestamps,
  ) async {
    Database db = await database;
    return await db.delete(
      'message_table',
      where: "timeCreated IN (${List.filled(timestamps.length, '?').join(',')})",
      whereArgs: timestamps,
    );
  }

  // Future<int> update(Subject subject) async {
  //   Database db = await instance.database;
  //   return await db.update('groceries', subject.toMap(), where: "id = ?", whereArgs: [subject.id]);
  // }
}
