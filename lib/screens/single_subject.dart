import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/db/database.dart';
import 'package:frontend/models/message_model.dart';
import 'package:frontend/screens/single_subject/each_message.dart';
import 'package:frontend/screens/single_subject/input_area.dart';
import 'package:frontend/services/message_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'single_subject/camera_screen.dart';

class SingleSubject extends ConsumerStatefulWidget {
// CameraDescription camera;

  const SingleSubject({
    Key? key,
    // required this.camera,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SingleSubjectState();
}

class _SingleSubjectState extends ConsumerState<SingleSubject> {
  @override
  void initState() {
    super.initState();

    ref.read(messageProvider).retrieveLostData();

    ref.read(messageProvider).getData();
  }

  @override
  void dispose() {
    super.dispose();
    // ref.read(messageProvider).disposeState();
  }

  @override
  Widget build(BuildContext context) {
    final messageRef = ref.watch(messageProvider);
    return Scaffold(
      appBar: AppBar(
        // title: Text(ref.watch(messageProvider).subjectName),
        title: Text(messageRef.subjectName),
        actions: <Widget>[
          messageRef.showHoldMessageIcons
              ? Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Material(
                    shape: const CircleBorder(),
                    clipBehavior: Clip.hardEdge,
                    color: Colors.transparent,
                    child: IconButton(
                      onPressed: () {
                        ref.read(messageProvider).deleteMessages(messageRef.subjectRowId);
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
                  itemCount: messageRef.messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Material(
                      color: messageRef.selectedMessages.contains(
                        messageRef.messages.elementAt(index),
                      )
                          ? Colors.grey[400]
                          : Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.black12,
                        onLongPress: () {
                          ref.read(messageProvider).messageOnLongPress(messageRef.messages.elementAt(index));
                          // message.messageOnLongPress(messages.elementAt(index));
                        },
                        onTap: () {
                          ref.read(messageProvider).messageOnTap(messageRef.messages.elementAt(index));
                        },
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: EachMessage(
                            message: messageRef.messages.elementAt(index),
                            messages: messageRef.messages,
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
              child: const InputAreaWidget(
                  // addMessage: ref.read(messageProvider).addMessage,
                  // imgFromGallery: _imgFromGallery,
                  // imgFromCamera: _imgFromCamera,
                  // camera: widget.camera,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
