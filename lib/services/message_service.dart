import 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/repositories/message_repository.dart';
import 'package:frontend/models/message_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

final messageServiceProvider = ChangeNotifierProvider((ref) => MessageService());

class MessageService extends ChangeNotifier {
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  List<Message> messages = [];

  /// separate [starredMessages] variable for [StarredMessagePage]
  List<Message> starredMessages = [];

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

  // ===========================================================================================
  // ===========================================================================================
  // General CRUD

  /// Adds a new [Message] to message repository/database.
  Future<void> addMessage(String newChat, int subjectRowId, String type) async {
    if (newChat == "") return;

    await MessageRepository().addMessageToLocalDatabase(Message(
      rowId: null,
      id: const Uuid().v1(),
      title: "",
      body: newChat,
      // subjectName: subjectName,
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

  Future<void> editMessage(int messsageRowId, String messageTitle, String messageBody) async {
    selectedMessages[0].title = messageTitle;
    selectedMessages[0].body = messageBody;
    selectedMessages[0].timeUpdated = DateTime.now().millisecondsSinceEpoch;

    await MessageRepository().editMessageFromLocalDatabase(selectedMessages.first);
    deleteStates();
    notifyListeners();
  }

  Future<void> deleteMessages(int subjectRowId) async {
    // database stuff
    if (await MessageRepository().deleteMessagesFromLocalDatabase(selectedMessages) < 1) return;
    List<Message> newMessages = await MessageRepository().getMessagesFromLocalDatabase(subjectRowId);
    messages = newMessages;
    // Other Stuff
    deleteStates();
    notifyListeners();
  }

  //
  // XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  //
  //
  //

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

  void getMessages(int subjectRowId) async {
    var result = await MessageRepository().getMessagesFromLocalDatabase(subjectRowId);
    messages = result;
    notifyListeners();
  }

  void deleteStates() {
    selectedMessages = [];
    showHoldMessageIcons = false;

    // notifyListeners();
  }

  /// Returns wheather the screen should [pop] or not. returns [true] if should [pop].
  /// To check if user has selected any messages, if so then remove them from [selectedMessages] and return false
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
  // bool _sendIconVisible = false;

  TextEditingController newTextController = TextEditingController();

  late List<CameraDescription> camerasNew;
  late CameraDescription cameraNew;

  /// sends input [text] to [addMessage] method and clears the [newTextController] text
  void sendInputText(String text, int subjectRowId) async {
    const bool isFavourite = false;
    const String type = "text";

    addMessage(text, subjectRowId, type);
    newTextController.clear();
    // updateInputText(text);
  }

  void updateInputText(String value) {
    if (value.isNotEmpty) {
      cameraIconVisible = false;
      galleryIconVisible = false;
      // _sendIconVisible = true;
      notifyListeners();
    } else {
      cameraIconVisible = true;
      galleryIconVisible = true;
      // _sendIconVisible = true;
      notifyListeners();
    }
  }

  /// Adds Image from Camera.
  /// takes the [imagePath] sent from [Camera] and adds the image path to [Message.body]
  Future imgFromCamera(String imagePath, int subjectRowId) async {
    debugPrint(imagePath);
    if (imagePath != "") {
      const bool isFavourite = false;
      const String type = "image";
      addMessage(imagePath, subjectRowId, type);
    }
  }

  /// Adds Image from gallery.
  /// takes the [imagePath] sent from [ImagePicker().pickImage] and adds the image path to [Message.body]
  Future imgFromGallery(int subjectRowId) async {
    try {
      XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      _image = image;
      notifyListeners();
      if (_image != null) {
        // const bool isFavourite = false;
        // const bool isText = false;
        const String type = "image";
        addMessage(_image!.path, subjectRowId, type);
      }
    } on Exception catch (e) {
      await retrieveLostData();
      debugPrint("failed to retrive image from gallery" + e.toString());
    }
  }

  Future pickFiles(int subjectRowId) async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result == null) return null;

    List<File> files = result.paths.map((path) {
      return File(path!);
    }).toList();
    for (var file in files) {
      addMessage(file.path, subjectRowId, "document");
    }
  }

  /// if [flag] is 1 then unstar all messages. else star all messages
  /// [flag] is set to 1 when [selectedMessages] includes all starred messages.
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
    deleteStates();
    notifyListeners();
  }

  /// set the [starredMessages] on initial load of [StarredMessagesPage]
  Future<void> setStarredMessages(int subjectRowId) async {
    starredMessages = [];
    starredMessages = await MessageRepository().getStarredMessagesFromLocalDatabase(subjectRowId);
    for (var element in starredMessages) {
      debugPrint(element.body + "-----" + element.isFavourite.toString());
    }
    notifyListeners();
  }

  /// dispose the [starredMessages] on destroying the [StarredMessagesPage]
  void disposeStarredMessages() {
    starredMessages = [];
    // notifyListeners();
  }
}
