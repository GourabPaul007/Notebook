import 'package:frontend/db/database.dart';
import 'package:frontend/models/subject_model.dart';
import 'package:sqflite/sqflite.dart';

class SubjectRepository {
  String subjectsTable = "subjects_table";

  Future<List<Subject>> getSubjectsFromLocalDatabase() async {
    Database db = await DBHelper.instance.database;
    var subjects = await db.query(subjectsTable, orderBy: 'time_created DESC');
    List<Subject> subjectList = subjects.isNotEmpty ? subjects.map((c) => Subject.fromMap(c)).toList() : [];
    // await db.close();
    return subjectList;
  }

  Future<int> addSubjectToLocalDatabse(Subject subject) async {
    int returnCode = -1;
    Database db = await DBHelper.instance.database;
    returnCode = await db.insert(
      subjectsTable,
      subject.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
    // await db.close();
    return returnCode;
  }

  Future<int> deleteSubjectFromLocalDatabase(Subject subject) async {
    Database db = await DBHelper.instance.database;
    // Deleting the messages tied to the subject First
    int messagesDeletedCount =
        await db.delete("messages_table", where: "subject_row_id = ?", whereArgs: [subject.rowId]);
    // Deleting the subject
    int subjectsDeletedCount = await db.delete("subjects_table", where: "row_id = ?", whereArgs: [subject.rowId]);
    // await db.close();
    return subjectsDeletedCount + messagesDeletedCount;
  }

  Future<int> updateSubjectFromLocalDatabase(int rowId, String name, String description, int timeUpdated) async {
    Map<String, dynamic> row = {
      "name": name,
      "description": description,
      "time_updated": timeUpdated,
    };

    Database db = await DBHelper.instance.database;
    int returnCode = await db.update(subjectsTable, row, where: "rowId = ?", whereArgs: [rowId]);
    // await db.close();
    return returnCode;
  }
}














// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:frontend/db/database.dart';
// import 'package:frontend/db/database_helper.dart';
// import 'package:frontend/models/message_model.dart';
// import 'package:frontend/models/subject_model.dart';
// import 'package:sqflite/sqflite.dart';

// class SubjectRepository {
  // final Database database;

  // SubjectRepository(this.database);
  // String subjectsTable = "subjects_table";
  // String messagesTable = "messages_table";

  // final instance = DBHelper.instance;
  // static final DBHelper instance = DBHelper._privateConstructor();

  // Future<List<Subject>> getSubjects() async {
  //   var subjects = await database.query(subjectsTable, orderBy: 'time_created DESC');
  //   List<Subject> subjectList = subjects.isNotEmpty ? subjects.map((c) => Subject.fromMap(c)).toList() : [];
  //   // await db.close();
  //   return subjectList;
  // }

  // Future<int> addSubject(Subject subject) async {
  //   int returnCode = -1;
  //   returnCode = await database.insert(
  //     subjectsTable,
  //     subject.toMap(),
  //     conflictAlgorithm: ConflictAlgorithm.abort,
  //   );
  //   // await db.close();
  //   return returnCode;
  // }

  // Future<int> deleteSubject(Subject subject) async {
  //   // Deleting the messages tied to the subject First
  //   int messagesDeletedCount =
  //       await database.delete("messages_table", where: "subject_row_id = ?", whereArgs: [subject.rowId]);
  //   // Deleting the subject
  //   int subjectsDeletedCount = await database.delete("subjects_table", where: "row_id = ?", whereArgs: [subject.rowId]);
  //   // await db.close();
  //   return subjectsDeletedCount + messagesDeletedCount;
  // }

  // Future<int> updateSubject(int rowId, String name, String description, int timeUpdated) async {
  //   Map<String, dynamic> row = {
  //     "name": name,
  //     "description": description,
  //     "time_updated": timeUpdated,
  //   };

  //   int returnCode = await database.update(subjectsTable, row, where: "rowId = ?", whereArgs: [rowId]);
  //   // await db.close();
  //   return returnCode;
  // }

  // Future<List<Subject>> getSubjectsFromLocalDatabase() async {
  //   List<Subject> subjects = await DBHelper.instance.getSubjects();
  //   return subjects;
  // }

  // Future<int> addSubjectToLocalDatabase(Subject subject) async {
  //   // Database db = await instance.database;

  //   int returnCode = -1;
  //   returnCode = await DBHelper.instance.addSubject(subject);
  //   return returnCode;
  // }

  // Future<int> deleteSubjectFromLocalDatabase(Subject subject) async {
  //   int returnCode = await DBHelper.instance.deleteSubject(subject);
  //   return returnCode;
  // }

  // Future<int> updateSubjectFromLocalDatabase(int rowId, String name, String description, int timeUpdated) async {
  //   int returnCode = await DBHelper.instance.updateSubject(rowId, name, description, timeUpdated);
  //   return returnCode;
  // }
// }

// final subjectRepositoryProvider = FutureProvider((ref) async {
//   final database = await ref.watch(databaseProvider.future);
//   return SubjectRepository(database);
// });
