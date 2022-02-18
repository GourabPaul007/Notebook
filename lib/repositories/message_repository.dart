import 'package:frontend/db/database.dart';
import 'package:frontend/models/message_model.dart';
import 'package:frontend/models/subject_model.dart';
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
    List<Message> messageList = [];
    for (int i = 0; i < messages.length; i++) {
      messageList.add(Message.fromMap(messages[i]));
    }
    return messageList;
  }

  // For Development Purpose
  Future<void> printAllMessagesFromLocalDatabase() async {
    Database db = await DBHelper.instance.database;
    var messages = await db.query(
      messageTable,
      orderBy: 'time_created DESC',
    );
    List<Message> messageList = messages.isNotEmpty ? messages.map((c) => Message.fromMap(c)).toList() : [];
    // print("rowId----id----body-----------subjectName----subjectRowId\n");
    // ignore: unused_local_variable
    for (var element in messageList) {
      // print("${element.rowId} ${element.id} ${element.body}-------${element.subjectName} ${element.subjectRowId}\n");
    }
  }

  Future<int> addMessageToLocalDatabase(Message message) async {
    Database db = await DBHelper.instance.database;
    return await db.insert(messageTable, message.toMap());
  }

  // Edit Message from the edit button
  Future<int> editMessageFromLocalDatabase(Message message) async {
    Database db = await DBHelper.instance.database;
    Map<String, dynamic> values = {
      "title": message.title,
      "body": message.body,
      "color": message.color,
      "time_updated": message.timeUpdated,
    };
    final returnCode = await db.update(messageTable, values, where: "row_id = ?", whereArgs: [message.rowId]);
    return returnCode;
  }

  Future<int> deleteMessagesFromLocalDatabase(List<Message> messages) async {
    Database db = await DBHelper.instance.database;
    List<int?> rowIds = [];
    for (int i = 0; i < messages.length; i++) {
      rowIds.add(messages[i].rowId);
    }
    int returnCode = await db.delete(
      messageTable,
      where: "row_id IN (${List.filled(rowIds.length, '?').join(',')})",
      whereArgs: rowIds,
    );
    // await db.close();
    return returnCode;
  }

  Future<int> remove(Subject subject) async {
    String name = subject.name;
    Database db = await DBHelper.instance.database;
    return await db.delete('message_table', where: 'name = ?', whereArgs: [name]);
  }

  toggleStarMessagesFromDatabase(List<Message> messages, int flag) async {
    Database db = await DBHelper.instance.database;
    Map<String, dynamic> values;
    // if flag is 1, then unstar all messages
    if (flag == 1) {
      values = {"is_favourite": 0};
    } else {
      values = {"is_favourite": 1};
    }
    List<int?> rowIds = [];
    for (int i = 0; i < messages.length; i++) {
      rowIds.add(messages[i].rowId);
    }
    final returnCode = await db.update(
      messageTable,
      values,
      where: "row_id IN (${List.filled(rowIds.length, '?').join(',')})",
      whereArgs: rowIds,
    );
    return returnCode;
  }

  /// get the messages from database where [is_favourite] is true & subject_row_id is given.
  ///
  /// If Called from [SubjectDetailsPage], will show subject specific starred messages.
  ///
  /// Else If Called from [HomePage], will show all starred messages
  Future<List<Message>> getStarredMessagesFromLocalDatabase(String from, int subjectRowId) async {
    Database db = await DBHelper.instance.database;
    List<Map<String, Object?>> messages;
    if (from == "HomePage" && subjectRowId == -1) {
      messages = await db.query(
        messageTable,
        where: 'is_favourite = 1',
        orderBy: 'time_created DESC',
      );
    } else {
      messages = await db.query(
        messageTable,
        where: 'subject_row_id = ? AND is_favourite = 1',
        whereArgs: [subjectRowId],
        orderBy: 'time_created DESC',
      );
    }
    List<Message> starredMessageList = [];
    if (messages.isNotEmpty) {
      for (int i = 0; i < messages.length; i++) {
        starredMessageList.add(Message.fromMap(messages[i]));
      }
    }
    return starredMessageList;
  }
}
