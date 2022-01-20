import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/db/database.dart';
import 'package:frontend/repositories/message_repository.dart';
import 'package:frontend/models/message_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

final messageServiceProvider = ChangeNotifierProvider((ref) => MessageService());

class MessageService extends ChangeNotifier {
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  List<Message> messages = [];

  List<Message> images = [];
  void setImages() {
    images = messages.where((value) => value.isImage).toList();
  }

  // AppBar Stuff
  bool showHoldMessageIcons = false;
  List<Message> selectedMessages = [];

  // ===========================================================================================
  // ===========================================================================================
  // Subject Metadata for when you click on a subject on subjectlist page and go in that subject
  late int subjectRowId;
  late String subjectName;

  int get getSubjectRowId => subjectRowId;
  void setSubjectRowId(int rowId) {
    subjectRowId = rowId;
    notifyListeners();
  }

  String get getSubjectName => subjectName;
  void setSubjectName(String name) {
    subjectName = name;
    notifyListeners();
  }
  // ===========================================================================================
  // ===========================================================================================

  // ===========================================================================================
  // ===========================================================================================
  // Get all the message info on edit message modal
  String get getEditMessageTitle => selectedMessages[0].title;
  String get getEditMessageBody => selectedMessages[0].body;
  // int? get getEditMessageRowId => selectedMessages[0].rowId;
  // bool get getEditMessageIsText => selectedMessages[0].isText;
  // ===========================================================================================
  // ===========================================================================================

  Future<void> addMessage(String newChat, int subjectRowId, bool isFavourite, bool isText, bool isImage) async {
    if (newChat == "") return;

    // database stuff
    await MessageRepository().addMessageToLocalDatabase(Message(
      rowId: null,
      id: const Uuid().v1(),
      title: "",
      body: newChat,
      // subjectName: subjectName,
      subjectRowId: subjectRowId,
      timeCreated: DateTime.now().millisecondsSinceEpoch,
      timeUpdated: DateTime.now().millisecondsSinceEpoch,
      isFavourite: isFavourite,
      isText: isText,
      isImage: isImage,
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

    await MessageRepository().editMessageFromLocalDatabase(selectedMessages[0]);
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
    print(selectedMessages);
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

  void getData() async {
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
  void sendInputText(String text, String subjectName, int subjectRowId) async {
    const bool isFavourite = false;
    const bool isText = true;
    const bool isImage = false;

    addMessage(text, subjectRowId, isFavourite, isText, isImage);
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
  Future imgFromCamera(String imagePath, String subjectName, int subjectRowId) async {
    debugPrint(imagePath);
    if (imagePath != null || imagePath != "") {
      const bool isFavourite = false;
      const bool isText = false;
      const bool isImage = true;
      addMessage(imagePath, subjectRowId, isFavourite, isText, isImage);
    }
  }

  /// Adds Image from gallery.
  /// takes the [imagePath] sent from [ImagePicker().pickImage] and adds the image path to [Message.body]
  Future imgFromGallery(String subjectName, int subjectRowId) async {
    try {
      XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      _image = image;
      notifyListeners();
      if (_image != null) {
        const bool isFavourite = false;
        const bool isText = false;
        const bool isImage = true;
        addMessage(_image!.path, subjectRowId, isFavourite, isText, isImage);
      }
    } on Exception catch (e) {
      await retrieveLostData();
      debugPrint("failed to retrive image from gallery" + e.toString());
    }
  }
}
