import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/document_model.dart';
import 'package:frontend/repositories/documents_repository.dart';
import 'package:frontend/widgets/snack_bar.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';

final documentServiceProvider = ChangeNotifierProvider((ref) {
  return PdfService();
});

class PdfService extends ChangeNotifier {
  List<Document> documents = [];
  bool documentsOnHold = false;
  List<Document> selectedDocuments = [];

  int get getEditMessageColor => selectedDocuments[0].color;

  void documentOnTap(BuildContext context, Document document) async {
    if (selectedDocuments.isEmpty) {
      // if the file exists then open, otherwise show snackbar saying "file has been deleted"
      if (File(document.path).existsSync()) {
        await OpenFile.open(
          document.path,
          // type: "application/pdf",
        );
      } else {
        SnackBarWidget.buildSnackbar(context, "File has been deleted");
      }
    } else if (selectedDocuments.contains(document)) {
      selectedDocuments.remove(document);
      documentsOnHold = selectedDocuments.isNotEmpty;
    } else {
      selectedDocuments.add(document);
      documentsOnHold = selectedDocuments.isNotEmpty;
    }
    notifyListeners();
  }

  void documentOnLongPress(Document document) {
    HapticFeedback.vibrate();
    if (selectedDocuments.contains(document)) {
      selectedDocuments.remove(document);
    } else {
      selectedDocuments.add(document);
    }
    documentsOnHold = selectedDocuments.isNotEmpty;
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
      name: "",
      about: "",
      path: file.path,
      color: Colors.deepPurpleAccent.value,
      size: (file.lengthSync() / 1000).floor(),
      type: file.path.substring(file.path.lastIndexOf(".") + 1),
      timeAdded: DateTime.now().millisecondsSinceEpoch,
      timeUpdated: DateTime.now().millisecondsSinceEpoch,
      isFavourite: false,
    );
    for (var document in documents) {
      if (document.path == newDocument.path) {
        return "Document Already Exists";
      }
    }
    await DocumentsRepository().addDocumentToLocalDatabse(newDocument);
    await getAllDocuments();
    return "Document Added";
  }

  Future<void> getAllDocuments() async {
    documents = await DocumentsRepository().getDocumentsFromLocalDatabase();
    notifyListeners();
  }

  void deleteSelectedDocuments() async {
    Set<int> rowIds = selectedDocuments.map((e) => e.rowId!).toSet();
    await DocumentsRepository().deleteDocumentsFromLocalDatabase(rowIds);
    // getAllDocuments();
    for (Document eachSelectedDocument in selectedDocuments) {
      documents.remove(eachSelectedDocument);
    }
    disposeStates();
  }

  Future<void> editDocument(String name, int color) async {
    await DocumentsRepository().editDocumentFromLocalDatabase(
      selectedDocuments.first.rowId!,
      name,
      color,
      DateTime.now().millisecondsSinceEpoch,
    );
    // setting data in memory to save db call
    selectedDocuments[0].name = name;
    selectedDocuments[0].color = color;
    disposeStates();
    notifyListeners();
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
    documentsOnHold = false;
    selectedDocuments = [];
    notifyListeners();
  }
}
