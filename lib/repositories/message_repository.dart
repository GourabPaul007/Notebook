import 'dart:io';
import 'package:frontend/db/database.dart';
import 'package:frontend/db/database_helper.dart';
import 'package:frontend/models/message_model.dart';
import 'package:frontend/models/subject_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class MessageRepository {
  String messageTable = "messages_table";

  // get the messages after initial boot or after updating or deleting messages
  Future<List<Message>> getMessagesFromLocalDatabase(int subjectRowId) async {
    Database db = await DBHelper.instance.database;
    var messages = await db.query(
      messageTable,
      where: 'subject_row_id = ?',
      whereArgs: [subjectRowId],
      orderBy: 'time_created DESC',
    );
    // print(messages);
    List<Message> messageList = messages.isNotEmpty ? messages.map((c) => Message.fromMap(c)).toList() : [];
    return messageList;
  }

  Future<int> addMessageToLocalDatabase(Message message) async {
    Database db = await DBHelper.instance.database;
    return await db.insert(messageTable, message.toMap());
  }

  Future<int> deleteMessagesFromLocalDatabase(List<Message> messages) async {
    Database db = await DBHelper.instance.database;
    List<int?> rowIds = messages.map((e) => e.rowId).toList();

    // if rowIds array dont include null value, then it executes if block. Otherwise executes else block
    // if (rowIds.any((e) => e != null)) {
    int returnCode = await db.delete(
      messageTable,
      where: "row_id IN (${List.filled(rowIds.length, '?').join(',')})",
      whereArgs: rowIds,
    );
    // await db.close();
    return returnCode;
  }
  // }

  Future<int> remove(Subject subject) async {
    String name = subject.name;
    Database db = await DBHelper.instance.database;
    return await db.delete('message_table', where: 'name = ?', whereArgs: [name]);
  }
}
