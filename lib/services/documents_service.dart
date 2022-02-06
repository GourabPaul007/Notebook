import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/document_model.dart';
import 'package:frontend/repositories/documents_repository.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:share_plus/share_plus.dart';

final documentServiceProvider = ChangeNotifierProvider((ref) {
  return PdfService();
});

class PdfService extends ChangeNotifier {
  List<Document> documents = [];
  bool isDocumentsSelected = false;
  List<Document> selectedDocuments = [];

  void documentOnTap(BuildContext context, Document document) async {
    if (selectedDocuments.isEmpty) {
      await OpenFile.open(
        document.path,
        // type: "application/pdf",
      );
    } else if (selectedDocuments.contains(document)) {
      selectedDocuments.remove(document);
      isDocumentsSelected = selectedDocuments.isNotEmpty;
    } else {
      selectedDocuments.add(document);
      isDocumentsSelected = selectedDocuments.isNotEmpty;
    }
    notifyListeners();
  }

  void documentOnLongPress(Document document) {
    HapticFeedback.vibrate();
    selectedDocuments.add(document);
    isDocumentsSelected = true;
    // subjectOnHold = hasSelectedSubjects();
    notifyListeners();
  }

  Future<List<File>?> pickFiles() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result == null) return null;

    List<File> files = result.paths.map((path) {
      return File(path!);
    }).toList();
    return files;
  }

  Future<String> addDocument(File file) async {
    Document newDocument = Document(
      rowId: null,
      name: basename(file.path),
      path: file.path,
      size: (file.lengthSync() / 1000).floor(),
      type: file.path.substring(file.path.lastIndexOf(".") + 1),
      timeAdded: DateTime.now().millisecondsSinceEpoch,
      isFavourite: false,
    );
    // file.
    for (var document in documents) {
      if (document.path == newDocument.path) {
        return "Document Already Exists";
      }
    }
    await DocumentRepository().addDocumentToLocalDatabse(newDocument);
    await getAllDocuments();
    return "Document Added";
  }

  Future<void> getAllDocuments() async {
    documents = await DocumentRepository().getDocumentsFromLocalDatabase();
    notifyListeners();
  }

  void deleteSelectedDocuments() async {
    Set<int> rowIds = selectedDocuments.map((e) => e.rowId!).toSet();
    await DocumentRepository().deleteDocumentsFromLocalDatabase(rowIds);
    // getAllDocuments();
    for (Document eachSelectedDocument in selectedDocuments) {
      documents.remove(eachSelectedDocument);
    }
    disposeStates();
  }

  void shareSelectedDocuments() {
    Share.shareFiles(selectedDocuments.map((e) => e.path).toList());
  }

  // void openPDF(BuildContext context, File file) {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(builder: (context) => PDFViewerPage(file: file)),
  //   );
  // }

  // void openPDF2(BuildContext context, String filePath) {
  //   PdfController pdfController = PdfController(
  //     document: PdfDocument.openFile(filePath),
  //   );
  //   Navigator.of(context).push(
  //     MaterialPageRoute(builder: (context) => PDFViewerPage2(controller2: pdfController)),
  //   );
  // }

  void disposeStates() {
    // documents = [];
    isDocumentsSelected = false;
    selectedDocuments = [];
    notifyListeners();
  }
}
