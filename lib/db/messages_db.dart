import 'dart:io';
import 'package:frontend/models/message_model.dart';
import 'package:frontend/models/subject_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class MessagesDatabaseHelper {
  MessagesDatabaseHelper._privateConstructor();
  static final MessagesDatabaseHelper instance = MessagesDatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'database.db');
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) async {
        await db.execute("""CREATE TABLE message_table(
          id INTEGER AUTO INCREMENT, 
          body TEXT, 
          subjectName TEXT, 
          time INTEGER)
        """);
      },
    );
  }

// get the messages
  Future<List<Message>> getMessages(String subjectName) async {
    Database db = await instance.database;
    var messages = await db.query(
      'message_table',
      where: 'subjectName = ?',
      whereArgs: [subjectName],
      orderBy: 'time DESC',
    );
    print(messages);
    List<Message> messageList = messages.isNotEmpty ? messages.map((c) => Message.fromMap(c)).toList() : [];
    return messageList;
  }

  Future<int> addMessage(Message message) async {
    Database db = await instance.database;
    return await db.insert('message_table', message.toMap());
  }

  Future<int> remove(Subject subject) async {
    String name = subject.name;
    Database db = await instance.database;
    return await db.delete('message_table', where: 'name = ?', whereArgs: [name]);
  }

  // Future<int> update(Subject subject) async {
  //   Database db = await instance.database;
  //   return await db.update('groceries', subject.toMap(), where: "id = ?", whereArgs: [subject.id]);
  // }
}
