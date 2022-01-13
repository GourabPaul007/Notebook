import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/db/database.dart';
import 'package:frontend/models/message_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

final singleSubjectProvider = ChangeNotifierProvider.autoDispose((ref) => SingleSubjectNotifier());

class SingleSubjectNotifier extends ChangeNotifier {
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  List<Message> messages = [];

  // late List<String> images = chatItems.removeWhere((element) => element.contains(".jpg"));

  // AppBar Stuff
  bool showHoldMessageIcons = false;
  List<Message> selectedMessages = [];

  // late int subjectRowId;
  // void setSubjectRowId(int rowId) {
  //   subjectRowId = rowId;
  // }

  // late String subjectName;
  // void setSubjectName(String name) {
  //   subjectName = name;
  // }

  Future<void> addMessage(String newChat, String subjectName, int subjectRowId) async {
    if (newChat == "") return;

    // database stuff
    await DBHelper().addMessageDatabase(Message(
      rowId: null,
      id: const Uuid().v1(),
      body: newChat,
      subjectName: subjectName,
      subjectRowId: subjectRowId,
      timeCreated: DateTime.now().millisecondsSinceEpoch,
      timeUpdated: DateTime.now().millisecondsSinceEpoch,
    ));
    List<Message> newMessages = await DBHelper().getMessagesDatabase(subjectRowId);

    // setState(() {
    messages = newMessages;

    // Other Stuff
    showHoldMessageIcons = false;
    // });
    notifyListeners();
  }

  Future<void> deleteMessages(int subjectRowId) async {
    // database stuff
    if (await DBHelper().deleteMessagesDatabase(selectedMessages) < 1) return;
    List<Message> newMessages = await DBHelper().getMessagesDatabase(subjectRowId);

    // setState(() {
    messages = newMessages;
    // Other Stuff
    selectedMessages = [];
    showHoldMessageIcons = false;
    // });
    notifyListeners();
  }

  Future _imgFromCamera(String imagePath, String subjectName, int subjectRowId) async {
    debugPrint(imagePath);
    if (imagePath != null || imagePath != "") {
      addMessage(imagePath, subjectName, subjectRowId);
    }
  }

  Future _imgFromGallery(String subjectName, int subjectRowId) async {
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

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      _image = response.file;
      // setState(() {});
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
    // setState(() {
    selectedMessages.add(message);
    showHoldMessageIcons = hasSelectedMessages();
    // });
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
    // setState(() {});
    notifyListeners();
  }

  void getData(int subjectRowId) async {
    var result = await DBHelper().getMessagesDatabase(subjectRowId);
    messages = result;
    notifyListeners();
  }

  // =============================================================================================================
  // =============================================================================================================
  // =============================================================================================================
  // Input Area Services

  bool _cameraIconVisible = true;
  bool _galleryIconVisible = true;
  // bool _sendIconVisible = false;

  TextEditingController newTextController = TextEditingController();

  late List<CameraDescription> camerasNew;
  late CameraDescription cameraNew;

  void _sendInputText(String subjectName, int subjectRowId) async {
    addMessage(newTextController.text, subjectName, subjectRowId);
    // newTextController.text = "";
    newTextController.clear();
    _updateInputText(newTextController.text);
  }

  void _updateInputText(String value) {
    if (value.isNotEmpty) {
      _cameraIconVisible = false;
      _galleryIconVisible = false;
      // _sendIconVisible = true;
      notifyListeners();
    } else {
      _cameraIconVisible = true;
      _galleryIconVisible = true;
      // _sendIconVisible = true;
      notifyListeners();
    }
  }

  void imagePath() {}
}
