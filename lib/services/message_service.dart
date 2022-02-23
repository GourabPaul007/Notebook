import 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/repositories/message_repository.dart';
import 'package:frontend/models/message_model.dart';
import 'package:frontend/services/subject_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

final messageServiceProvider =
    ChangeNotifierProvider((ref) => MessageService(ref.watch(subjectServiceProvider).subjectName));

class MessageService extends ChangeNotifier {
  late String messageSubjectName;
  MessageService(this.messageSubjectName);

  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  List<Message> messages = [];

  /// separate [starredMessages] variable for [StarredMessagePage]

  // ===========================================================================================
  // ===========================================================================================
  // Image Message Stuff
  List<Message> images = [];
  void setImages() {
    images = messages.where((value) => value.type == "image").toList();
  }

  /// get the initial clicked [image] when user tapped image in messages([images])
  Message getTappedImage(int index) => images[index];

  // AppBar Stuff
  bool showHoldMessageIcons = false;
  List<Message> selectedMessages = [];

  // ===========================================================================================
  // Get all the message info on edit message modal
  String get getEditMessageTitle => selectedMessages[0].title;
  String get getEditMessageBody => selectedMessages[0].body;
  int get getEditMessageColor => selectedMessages[0].color;

  // ===========================================================================================
  // ===========================================================================================
  // General CRUD
  /// Adds a new [Message] to message repository/database.
  Future<void> addMessage(String title, String body, int color, int subjectRowId, String type) async {
    if (body == "") return;

    await MessageRepository().addMessageToLocalDatabase(Message(
      rowId: null,
      id: const Uuid().v1(),
      title: title,
      body: body,
      color: color,
      subjectName: messageSubjectName,
      subjectRowId: subjectRowId,
      timeCreated: DateTime.now().millisecondsSinceEpoch,
      timeUpdated: DateTime.now().millisecondsSinceEpoch,
      isFavourite: false,
      type: type,
    ));
    List<Message> newMessages = await MessageRepository().getMessagesFromLocalDatabase(subjectRowId);

    messages = newMessages;
    // Other Stuff
    showHoldMessageIcons = false;
    notifyListeners();
  }

  Future<void> getMessages(int subjectRowId) async {
    var result = await MessageRepository().getMessagesFromLocalDatabase(subjectRowId);
    messages = result;
    notifyListeners();
  }

  Future<void> editMessage(int messsageRowId, String messageTitle, String messageBody, int color) async {
    await MessageRepository().editMessageFromLocalDatabase(
      messsageRowId,
      messageTitle,
      messageBody,
      color,
      DateTime.now().millisecondsSinceEpoch,
    );
    // set the data in memory so the user can see the update without refreshing
    selectedMessages[0].title = messageTitle;
    selectedMessages[0].body = messageBody;
    selectedMessages[0].color = color;
    selectedMessages[0].timeUpdated = DateTime.now().millisecondsSinceEpoch;
    // clean up
    selectedMessages = [];
    showHoldMessageIcons = false;
    notifyListeners();
  }

  Future<void> deleteMessages(int subjectRowId) async {
    // database stuff
    if (await MessageRepository().deleteMessagesFromLocalDatabase(selectedMessages) < 1) return;
    List<Message> newMessages = await MessageRepository().getMessagesFromLocalDatabase(subjectRowId);
    messages = newMessages;
    // Other Stuff
    selectedMessages = [];
    showHoldMessageIcons = false;
    notifyListeners();
  }

  void messageOnLongPress(Message message) {
    HapticFeedback.vibrate();
    selectedMessages.add(message);
    showHoldMessageIcons = selectedMessages.isNotEmpty;
    notifyListeners();
  }

  void messageOnTap(Message message) {
    if (selectedMessages.isNotEmpty && !selectedMessages.contains(message)) {
      selectedMessages.add(message);
      showHoldMessageIcons = selectedMessages.isNotEmpty;
    } else {
      selectedMessages.remove(message);
      showHoldMessageIcons = selectedMessages.isNotEmpty;
    }
    notifyListeners();
  }
  // ===================================================================================================

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      _image = response.file;
      notifyListeners();
    } else {
      debugPrint(response.exception.toString());
    }
  }

  /// To check if user has selected any messages, if so then remove them from [selectedMessages] and return false
  ///
  /// Returns wheather the screen should [pop] or not. returns [true] if should [pop].
  ///
  /// If [selectedMessages] is already empty then return true.
  Future<bool> willPopScreen() async {
    if (selectedMessages.isNotEmpty) {
      selectedMessages = [];
      showHoldMessageIcons = selectedMessages.isNotEmpty;
      notifyListeners();
      return false;
    }
    return true;
  }

  // =============================================================================================================
  // =============================================================================================================
  // =============================================================================================================
  // Input Area Services

  bool cameraIconVisible = true;
  bool galleryIconVisible = true;

  TextEditingController newTextController = TextEditingController();

  late List<CameraDescription> camerasNew;
  late CameraDescription cameraNew;

  /// sends input [text] to [addMessage] method and clears the [newTextController] text
  void sendInputText(String text, int subjectRowId) async {
    addMessage("", text, Colors.deepPurpleAccent.value, subjectRowId, "text");
    newTextController.clear();
  }

  /// if the user starts to type something, hide the camera & gallery icon from textfield for elegance
  void onInputChange(String value) {
    if (value.isNotEmpty) {
      cameraIconVisible = false;
      galleryIconVisible = false;
      notifyListeners();
    } else {
      cameraIconVisible = true;
      galleryIconVisible = true;
      notifyListeners();
    }
  }

  /// Adds Image from Camera.
  ///
  /// takes the [imagePath] sent from [Camera] and adds the image path to [Message.body]
  Future imgFromCamera(String imagePath, int subjectRowId) async {
    debugPrint(imagePath);
    if (imagePath != "") {
      const String type = "image";
      addMessage("", imagePath, Colors.deepPurpleAccent.value, subjectRowId, type);
    }
  }

  /// Adds Image from gallery.
  ///
  /// takes the [imagePath] sent from [ImagePicker().pickImage] and adds the image path to [Message.body]
  Future imgFromGallery(int subjectRowId) async {
    try {
      XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      _image = image;
      notifyListeners();
      if (_image != null) {
        const String type = "image";
        addMessage("", _image!.path, Colors.deepPurpleAccent.value, subjectRowId, type);
      }
    } on Exception catch (e) {
      await retrieveLostData();
      debugPrint("failed to retrive image from gallery" + e.toString());
    }
  }

  /// picks documents from file system...
  Future pickDocuments(int subjectRowId) async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
      onFileLoading: (FilePickerStatus status) {
        debugPrint("file picker status: " + status.toString());
      },
    );
    if (result == null) return;
    List<File> files = result.paths.map((path) {
      return File(path!);
    }).toList();
    for (var file in files) {
      addMessage("", file.path, Colors.deepPurpleAccent.value, subjectRowId, "document");
    }
  }

  /// if [flag] is 1 then unstar all messages. else star all messages
  ///
  /// [flag] is set to 1 when [selectedMessages] includes all starred messages.
  ///
  /// [flag] is set to 0 when [selectedMessages] include a [message] which is not favourite
  Future<void> toggleStarMessages() async {
    int flag = 1;
    for (Message message in selectedMessages) {
      if (message.isFavourite == false) {
        flag = 0;
      }
    }
    MessageRepository().toggleStarMessagesFromDatabase(selectedMessages, flag);
    if (flag == 1) {
      for (Message message in selectedMessages) {
        message.isFavourite = false;
      }
    } else {
      for (Message message in selectedMessages) {
        message.isFavourite = true;
      }
    }
    // clean up
    selectedMessages = [];
    showHoldMessageIcons = false;
    notifyListeners();
  }
}
