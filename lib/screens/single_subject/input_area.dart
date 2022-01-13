// The Input area at the bottom on a chat Screen

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/screens/single_subject/camera_screen.dart';
import 'package:frontend/services/single_subject_service.dart';

class InputAreaWidget extends ConsumerStatefulWidget {
  // final void Function(String newChat) addMessage;
  final String subjectName;
  final int subjectRowId;
  final Future Function() imgFromGallery;
  final Future Function(String) imgFromCamera;

  // CameraDescription camera;

  const InputAreaWidget({
    Key? key,
    // required this.addMessage,
    required this.subjectName,
    required this.subjectRowId,
    required this.imgFromGallery,
    required this.imgFromCamera,
    // required this.camera,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InputAreaWidgetState();
}

class _InputAreaWidgetState extends ConsumerState<InputAreaWidget> {
  bool _cameraIconVisible = true;
  bool _galleryIconVisible = true;
  // bool _sendIconVisible = false;

  TextEditingController newTextController = TextEditingController();

  late List<CameraDescription> camerasNew;
  late CameraDescription cameraNew;

  @override
  void initState() {
    super.initState();
    availableCameras().then((availableCameras) {
      camerasNew = availableCameras;
      cameraNew = camerasNew.first;
    });
  }

  @override
  void dispose() {
    newTextController.dispose();
    super.dispose();
  }

  void _sendInputText() async {
    // ref.read(singleSubjectProvider).addMessage(newTextController.text, ref.read(singleSubjectProvider).subjectName,
    //     ref.read(singleSubjectProvider).subjectRowId);
    ref.read(singleSubjectProvider).addMessage(newTextController.text, widget.subjectName, widget.subjectRowId);
    newTextController.text = "";
    newTextController.clear();
    _updateInputText(newTextController.text);
  }

  void _updateInputText(String value) {
    if (value.isNotEmpty) {
      setState(() {
        _cameraIconVisible = false;
        _galleryIconVisible = false;
        // _sendIconVisible = true;
      });
    } else {
      setState(() {
        _cameraIconVisible = true;
        _galleryIconVisible = true;
        // _sendIconVisible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
        child: Container(
          padding: const EdgeInsets.only(top: 4),
          // height: 50,
          child: Row(
            children: [
              Expanded(
                flex: 10,
                child: Container(
                  decoration: const BoxDecoration(
                      // color: Color(0xFF555a5d),
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 0.5,
                          offset: Offset(0, 0.5),
                        )
                      ]),
                  child: Material(
                    type: MaterialType.transparency,
                    child: Container(
                      padding: const EdgeInsets.only(left: 4),
                      child: Row(
                        children: <Widget>[
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            switchOutCurve: Curves.easeOutExpo,
                            transitionBuilder: btnTransition,
                            child: !_cameraIconVisible
                                ? const SizedBox()
                                : Container(
                                    width: 40,
                                    child: Material(
                                      shape: const CircleBorder(),
                                      clipBehavior: Clip.hardEdge,
                                      color: Colors.transparent,
                                      child: IconButton(
                                        onPressed: () async {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => TakePictureScreen(
                                                // cameraOld: widget.camera,
                                                cameraNew: cameraNew,
                                                imgFromCamera: widget.imgFromCamera,
                                              ),
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.camera_alt_rounded),
                                        splashColor: Colors.amber,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            transitionBuilder: btnTransition,
                            switchOutCurve: Curves.easeOutExpo,
                            child: !_galleryIconVisible
                                ? const SizedBox()
                                : Container(
                                    width: 40,
                                    child: Material(
                                      shape: const CircleBorder(),
                                      clipBehavior: Clip.hardEdge,
                                      color: Colors.transparent,
                                      child: IconButton(
                                        onPressed: () async {
                                          await widget.imgFromGallery();
                                        },
                                        splashColor: Colors.amber,
                                        icon: const Icon(Icons.photo),
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Scrollbar(
                              child: TextField(
                                cursorColor: Colors.red,
                                style: const TextStyle(color: Colors.black),
                                maxLines: 1,
                                controller: newTextController,
                                onChanged: _updateInputText,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(
                                    top: 2.0,
                                    left: 12.0,
                                    right: 12.0,
                                    bottom: 2.0,
                                  ),
                                  hintText: "Type your message",
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // !_sendIconVisible ? const SizedBox() :
              Expanded(
                flex: 2,
                child: Material(
                  color: Theme.of(context).primaryColor,
                  shape: const CircleBorder(),
                  clipBehavior: Clip.hardEdge,
                  child: IconButton(
                    onPressed: _sendInputText,
                    // iconSize: 48,
                    icon: const Icon(
                      Icons.send_rounded,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

// To make the icons slide in and out
  Widget btnTransition(Widget child, Animation<double> animation) {
    final offsetAnimation = Tween<Offset>(begin: const Offset(-0.2, 0.0), end: Offset.zero).animate(animation);
    return SlideTransition(
      position: offsetAnimation,
      child: child,
    );
  }
}
