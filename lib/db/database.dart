import 'dart:async';
import 'dart:io';
import 'package:frontend/models/message_model.dart';
import 'package:frontend/models/subject_model.dart';
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
      onConfigure: (db) async {
        await db.execute("PRAGMA foreign_keys = ON");
      },
      onCreate: _onCreate,
    );
  }

  void _onCreate(Database db, int version) async {
    await db.execute("""
        CREATE TABLE IF NOT EXISTS subjects_table(
          row_id INTEGER PRIMARY KEY AUTOINCREMENT,
          id TEXT NOT NULL, 
          name TEXT NOT NULL, 
          avatar_color TEXT,
          time_created INTEGER NOT NULL,
          time_updated INTEGER NOT NULL
        )
        """);
    await db.execute("""
        CREATE TABLE IF NOT EXISTS messages_table(
          row_id INTEGER PRIMARY KEY AUTOINCREMENT,
          id TEXT NOT NULL,
          body TEXT,
          time_created INTEGER NOT NULL,
          time_updated INTEGER NOT NULL,
          is_favourite BOOLEAN NOT NULL DEFAULT 0,
          subject_name TEXT NOT NULL,
          subject_row_id INTEGER NOT NULL,
          FOREIGN KEY(subject_row_id) REFERENCES subjects_table(row_id)
        )
        """);
  }

  Future<List<Subject>> getSubjects() async {
    Database db = await database;
    var subjects = await db.query('subjects_table', orderBy: 'time_created DESC');
    List<Subject> subjectList = subjects.isNotEmpty ? subjects.map((c) => Subject.fromMap(c)).toList() : [];
    // db.close();
    return subjectList;
  }

  Future<int> addSubject(Subject subject) async {
    int returnCode = -1;
    Database db = await database;
    returnCode = await db.insert(
      'subjects_table',
      subject.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
    // db.close();
    return returnCode;
  }

  Future<int> deleteSubject(Subject subject) async {
    Database db = await database;
    // Deleting the messages tied to the subject First
    int messagesDeletedCount =
        await db.delete("messages_table", where: "subject_row_id = ?", whereArgs: [subject.rowId]);
    // Deleting the subject
    int subjectsDeletedCount = await db.delete("subjects_table", where: "row_id = ?", whereArgs: [subject.rowId]);
    return subjectsDeletedCount + messagesDeletedCount;
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

  Future<List<Message>> getMessagesDatabase(int rowId) async {
    Database db = await database;
    var messages = await db.query(
      'messages_table',
      where: 'subject_row_id = ?',
      whereArgs: [rowId],
      orderBy: 'time_created DESC',
    );
    List<Message> messageList = messages.isNotEmpty ? messages.map((c) => Message.fromMap(c)).toList() : [];
    return messageList;
  }

  // Future<void> getAllMessagesDatabase() async {
  //   Database db = await database;
  //   var messages = await db.query(
  //     'messages_table',
  //     orderBy: 'time_created DESC',
  //   );
  //   print("************************");
  //   List<Message> messageList = messages.isNotEmpty ? messages.map((c) => Message.fromMap(c)).toList() : [];
  //   for (var element in messageList) {
  //     print("${element.rowId} ${element.id} ${element.body}--${element.subjectName} ${element.subjectRowId}\n");
  //   }
  // }

  Future<int> addMessageDatabase(Message message) async {
    Database db = await database;
    return await db.insert(
      'messages_table',
      message.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<int> deleteMessagesDatabase(List<Message> messages) async {
    Database db = await database;
    List<int?> rowIds = messages.map((e) => e.rowId).toList();

    // if rowIds array dont include null value, then it executes if block. Otherwise executes else block
    if (rowIds.any((e) => e != null)) {
      return await db.delete(
        'messages_table',
        where: "row_id IN (${List.filled(rowIds.length, '?').join(',')})",
        whereArgs: rowIds,
      );
    } else {
      List<String> ids = messages.map((e) => e.id).toList();
      return await db.delete(
        'messages_table',
        where: "id IN (${List.filled(rowIds.length, '?').join(',')})",
        whereArgs: ids,
      );
    }
  }

  // Future<int> update(Subject subject) async {
  //   Database db = await instance.database;
  //   return await db.update('groceries', subject.toMap(), where: "id = ?", whereArgs: [subject.id]);
  // }
}
