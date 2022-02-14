// The Input area at the bottom on a chat Screen

import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/screens/single_subject/bottom_sheet.dart';
import 'package:frontend/screens/single_subject/camera_screen.dart';
import 'package:frontend/services/camera_service.dart';
import 'package:frontend/services/message_service.dart';
import 'package:frontend/services/subject_service.dart';

class InputAreaWidget extends ConsumerStatefulWidget {
  const InputAreaWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InputAreaWidgetState();
}

class _InputAreaWidgetState extends ConsumerState<InputAreaWidget> {
  final _inputTextController = TextEditingController();

  // late List<CameraDescription> camerasNew;
  // late CameraDescription cameraNew;

  @override
  void initState() {
    super.initState();
    ref.read(cameraServiceProvider).initCameras();

    _inputTextController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _inputTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final messageService = ref.watch(messageServiceProvider);
    final subjectService = ref.watch(subjectServiceProvider);

    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
      height: 60,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 12,
            child: Container(
              decoration: BoxDecoration(
                // color: Color(0xFF555a5d),
                color: Colors.grey[300],
                borderRadius: const BorderRadius.all(
                  Radius.circular(50),
                ),
              ),
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  padding: const EdgeInsets.only(left: 4),
                  child: Row(
                    children: <Widget>[
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        switchOutCurve: Curves.easeOutExpo,
                        transitionBuilder: btnTransition,
                        child: _inputTextController.text.isNotEmpty
                            ? const SizedBox()
                            : SizedBox(
                                width: 40,
                                child: Material(
                                  shape: const CircleBorder(),
                                  clipBehavior: Clip.hardEdge,
                                  color: Colors.transparent,
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const TakePictureScreen(),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.camera_alt_outlined),
                                    splashColor: Colors.amber,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder: btnTransition,
                        switchOutCurve: Curves.easeOutExpo,
                        child: _inputTextController.text.isNotEmpty
                            ? const SizedBox()
                            : SizedBox(
                                width: 40,
                                child: Material(
                                  shape: const CircleBorder(),
                                  clipBehavior: Clip.hardEdge,
                                  color: Colors.transparent,
                                  child: IconButton(
                                    onPressed: () async {
                                      await ref.read(messageServiceProvider).imgFromGallery(
                                            subjectService.getSubjectRowId,
                                          );
                                    },
                                    splashColor: Colors.amber,
                                    icon: const Icon(Icons.photo_outlined),
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(
                        width: 40,
                        child: Material(
                          shape: const CircleBorder(),
                          clipBehavior: Clip.hardEdge,
                          color: Colors.transparent,
                          child: IconButton(
                            onPressed: () async {
                              // ref.read(messageServiceProvider).pickFiles(subjectService.subjectRowId);
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                barrierColor: Colors.transparent,
                                builder: (BuildContext context) {
                                  return SingleSubjectBottomSheet(subjectRowId: subjectService.subjectRowId);
                                },
                              );
                            },
                            icon: Transform.rotate(angle: 45, child: const Icon(Icons.attach_file_rounded)),
                            splashColor: Colors.amber,
                            color: Colors.black,
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
                            controller: _inputTextController,
                            onChanged: ref.read(messageServiceProvider).updateInputText,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                left: 8.0,
                                right: 12.0,
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
                onPressed: () {
                  ref.read(messageServiceProvider).sendInputText(
                        _inputTextController.text,
                        subjectService.subjectRowId,
                      );
                  _inputTextController.clear();
                },
                // iconSize: 48,
                icon: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
