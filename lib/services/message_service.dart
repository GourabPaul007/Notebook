import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/db/database.dart';
import 'package:frontend/repositories/message_repository.dart';
import 'package:frontend/models/message_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

final messageProvider = ChangeNotifierProvider((ref) => MessageService());

class MessageService extends ChangeNotifier {
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  List<Message> messages = [];

  // late List<String> images = chatItems.removeWhere((element) => element.contains(".jpg"));

  // AppBar Stuff
  bool showHoldMessageIcons = false;
  List<Message> selectedMessages = [];

  late int subjectRowId;
  int get getSubjectRowId => subjectRowId;
  void setSubjectRowId(int rowId) {
    subjectRowId = rowId;
    notifyListeners();
  }

  late String subjectName;
  String get getSubjectName => subjectName;
  void setSubjectName(String name) {
    subjectName = name;
    notifyListeners();
  }

  Future<void> addMessage(String newChat, String subjectName, int subjectRowId) async {
    if (newChat == "") return;

    // database stuff
    await MessageRepository().addMessageToLocalDatabase(Message(
      rowId: null,
      id: const Uuid().v1(),
      body: newChat,
      subjectName: subjectName,
      subjectRowId: subjectRowId,
      timeCreated: DateTime.now().millisecondsSinceEpoch,
      timeUpdated: DateTime.now().millisecondsSinceEpoch,
    ));
    List<Message> newMessages = await MessageRepository().getMessagesFromLocalDatabase(subjectRowId);

    // setState(() {
    messages = newMessages;

    // Other Stuff
    showHoldMessageIcons = false;
    // });
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

  // helper function for displaying the appbad icons which depend onuser hold or taps
  bool hasSelectedMessages() {
    return selectedMessages.isNotEmpty;
  }

  void messageOnLongPress(Message message) {
    HapticFeedback.vibrate();
    selectedMessages.add(message);
    showHoldMessageIcons = hasSelectedMessages();
    notifyListeners();
  }

  void messageOnTap(Message message) {
    if (selectedMessages.isNotEmpty && !selectedMessages.contains(message)) {
      selectedMessages.add(message);

      showHoldMessageIcons = hasSelectedMessages();
    } else {
      selectedMessages.remove(message);
      showHoldMessageIcons = hasSelectedMessages();
    }
    notifyListeners();
  }

  void getData() async {
    var result = await MessageRepository().getMessagesFromLocalDatabase(subjectRowId);
    messages = result;
    notifyListeners();
  }

  disposeState() {
    selectedMessages = [];
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

  void sendInputText(String text, String subjectName, int subjectRowId) async {
    addMessage(text, subjectName, subjectRowId);
    // newTextController.text = "";
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

  Future imgFromCamera(String imagePath, String subjectName, int subjectRowId) async {
    debugPrint(imagePath);
    if (imagePath != null || imagePath != "") {
      addMessage(imagePath, subjectName, subjectRowId);
    }
  }

  Future imgFromGallery(String subjectName, int subjectRowId) async {
    try {
      XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      // setState(() {
      _image = image;
      // });
      notifyListeners();
      if (_image != null) addMessage(_image!.path, subjectName, subjectRowId);
    } on Exception catch (e) {
      await retrieveLostData();
      debugPrint("here" + e.toString());
    }
  }
}
