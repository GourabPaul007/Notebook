import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/document_model.dart';
import 'package:frontend/repositories/documents_repository.dart';
import 'package:frontend/widgets/snack_bar.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import 'package:permission_handler/permission_handler.dart';
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
    // request storage, if granted, proceed
    if (await Permission.storage.request().isGranted) {
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
    // If not granted, do nothing (the null checking on returned documents is done on the ui code)
    else if (await Permission.storage.request().isDenied) {
    }
    // If permanently denied, then open settings page
    else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  Future<String> addDocument(File file) async {
    // creating the directory
    File returnedImageFile;
    String returnedImageFilePath = "";
    if (file.path.substring(file.path.lastIndexOf(".") + 1) == "pdf") {
      final Directory documentDirectory = await getApplicationDocumentsDirectory();
      final imageFile = File(join(
        documentDirectory.path,
        "document_thumbnails",
        basename(file.path),
      ));
      if (!await imageFile.exists()) {
        imageFile.create(recursive: true);
      }

      // getting the image from pdf
      final document = await PdfDocument.openFile(file.path);
      final page = await document.getPage(1);
      final pageImage = await page.render(height: 120, width: 90);
      returnedImageFile = await imageFile.writeAsBytes(pageImage!.bytes);
      returnedImageFilePath = returnedImageFile.path;
    } else {}

    Document newDocument = Document(
      rowId: null,
      name: "",
      about: "",
      thumbnailPath: returnedImageFilePath,
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
