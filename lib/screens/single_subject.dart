import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/db/database.dart';
import 'package:frontend/models/message_model.dart';
import 'package:frontend/screens/single_subject/each_message.dart';
import 'package:frontend/screens/single_subject/input_area.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

// import 'single_subject/camera_screen.dart';

class SingleSubject extends StatefulWidget {
  // CameraDescription camera;
  final int subjectRowId;
  final String subjectName;

  const SingleSubject({
    Key? key,
    required this.subjectName,
    required this.subjectRowId,
    // required this.camera,
  }) : super(key: key);

  @override
  State<SingleSubject> createState() => _SingleSubjectState();
}

class _SingleSubjectState extends State<SingleSubject> {
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  List<Message> messages = [];
  // late List<String> images = chatItems.removeWhere((element) => element.contains(".jpg"));

  // AppBar Stuff
  bool _showHoldMessageIcons = false;
  List<Message> _selectedMessages = [];

  Future<void> addMessage(String newChat) async {
    if (newChat == "") return;

    // database stuff
    await DBHelper().addMessageDatabase(Message(
      rowId: null,
      id: const Uuid().v1(),
      body: newChat,
      subjectName: widget.subjectName,
      subjectRowId: widget.subjectRowId,
      timeCreated: DateTime.now().millisecondsSinceEpoch,
      timeUpdated: DateTime.now().millisecondsSinceEpoch,
    ));
    List<Message> newMessages = await DBHelper().getMessagesDatabase(widget.subjectRowId);

    setState(() {
      messages = newMessages;

      // Other Stuff
      _showHoldMessageIcons = false;
    });
  }

  Future<void> deleteMessages() async {
    // database stuff
    if (await DBHelper().deleteMessagesDatabase(_selectedMessages) < 1) return;
    List<Message> newMessages = await DBHelper().getMessagesDatabase(widget.subjectRowId);

    setState(() {
      messages = newMessages;
      // Other Stuff
      _selectedMessages = [];
      _showHoldMessageIcons = false;
    });
  }

  Future _imgFromCamera(String imagePath) async {
    debugPrint(imagePath);
    if (imagePath != null || imagePath != "") {
      addMessage(imagePath);
    }
  }

  Future _imgFromGallery() async {
    try {
      XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      setState(() {
        _image = image;
      });
      if (_image != null) addMessage(_image!.path);
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
      setState(() {});
    } else {
      debugPrint(response.exception.toString());
    }
  }

  // helper function for displaying the appbad icons which depend onuser hold or taps
  bool hasSelectedMessages() {
    return _selectedMessages.isNotEmpty;
  }

  void _messageOnLongPress(Message message) {
    HapticFeedback.vibrate();
    setState(() {
      _selectedMessages.add(message);
      _showHoldMessageIcons = hasSelectedMessages();
    });
  }

  void _messageOnTap(Message message) {
    if (_selectedMessages.isNotEmpty && !_selectedMessages.contains(message)) {
      _selectedMessages.add(message);

      _showHoldMessageIcons = hasSelectedMessages();
    } else {
      _selectedMessages.remove(message);
      _showHoldMessageIcons = hasSelectedMessages();
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    retrieveLostData();

    void getData() async {
      var result = await DBHelper().getMessagesDatabase(widget.subjectRowId);
      setState(() {
        messages = result;
      });
    }

    getData();
  }

  @override
  void dispose() {
    super.dispose();
    _selectedMessages = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subjectName),
        actions: <Widget>[
          _showHoldMessageIcons
              ? Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Material(
                    shape: const CircleBorder(),
                    clipBehavior: Clip.hardEdge,
                    color: Colors.transparent,
                    child: IconButton(
                      onPressed: () {
                        deleteMessages();
                      },
                      icon: const Icon(
                        Icons.delete_rounded,
                        size: 26.0,
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Material(
              shape: const CircleBorder(),
              clipBehavior: Clip.hardEdge,
              color: Colors.transparent,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.more_vert,
                  size: 26.0,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          // color: Color(0xFF555a5d),
          // color: Color(0xFFe5ddd5),
          color: Color(0xFFECE5DD),
        ),
        child: Column(
          children: [
            Container(
              child: Expanded(
                flex: 4,
                child: ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  itemCount: messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Material(
                      color: _selectedMessages.contains(
                        messages.elementAt(index),
                      )
                          ? Colors.grey[400]
                          : Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.black12,
                        onLongPress: () {
                          _messageOnLongPress(messages.elementAt(index));
                        },
                        onTap: () {
                          _messageOnTap(messages.elementAt(index));
                        },
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: EachMessage(
                            message: messages.elementAt(index),
                            messages: messages,
                            // images: images,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // TEXTBOX AT THE BOTTOM
            Container(
              alignment: Alignment.bottomCenter,
              child: InputAreaWidget(
                addMessage: addMessage,
                imgFromGallery: _imgFromGallery,
                imgFromCamera: _imgFromCamera,
                // camera: widget.camera,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
