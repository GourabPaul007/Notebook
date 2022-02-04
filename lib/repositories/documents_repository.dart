import 'package:frontend/db/database.dart';
import 'package:frontend/models/document_model.dart';
import 'package:sqflite/sqflite.dart';

class DocumentRepository {
  String documentsTable = "documents_table";

  Future<List<Document>> getDocumentsFromLocalDatabase() async {
    Database db = await DBHelper.instance.database;
    var documents = await db.query(documentsTable, orderBy: 'time_added DESC');
    List<Document> documentList = documents.isNotEmpty ? documents.map((c) => Document.fromMap(c)).toList() : [];
    return documentList;
  }

  Future<int> addDocumentToLocalDatabse(Document document) async {
    int returnCode = -1;
    Database db = await DBHelper.instance.database;
    returnCode = await db.insert(
      documentsTable,
      document.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
    return returnCode;
  }

  Future<int> deleteDocumentsFromLocalDatabase(Set<int> rowIds) async {
    int returnCode = -1;
    Database db = await DBHelper.instance.database;
    returnCode = await db.delete(
      documentsTable,
      where: "row_id IN (${List.filled(rowIds.length, '?').join(',')})",
      whereArgs: rowIds.toList(),
    );
    return returnCode;
  }

  // Future<int> deleteSubjectFromLocalDatabase(Subject subject) async {
  //   Database db = await DBHelper.instance.database;
  //   // Deleting the messages tied to the subject First
  //   int messagesDeletedCount =
  //       await db.delete("messages_table", where: "subject_row_id = ?", whereArgs: [subject.rowId]);
  //   // Deleting the subject
  //   int subjectsDeletedCount = await db.delete("subjects_table", where: "row_id = ?", whereArgs: [subject.rowId]);
  //   // await db.close();
  //   MessageRepository().printAllMessagesFromLocalDatabase();
  //   return subjectsDeletedCount + messagesDeletedCount;
  // }

  // Future<int> updateSubjectFromLocalDatabase(int rowId, String name, String description, int timeUpdated) async {
  //   Map<String, dynamic> row = {
  //     "name": name,
  //     "description": description,
  //     "time_updated": timeUpdated,
  //   };

  //   Database db = await DBHelper.instance.database;
  //   int returnCode = await db.update(subjectsTable, row, where: "rowId = ?", whereArgs: [rowId]);
  //   // await db.close();
  //   return returnCode;
  // }
}
