import 'package:flutter/material.dart';
import 'package:frontend/screens/single_subject/each_message.dart';
import 'package:frontend/screens/single_subject/input_area.dart';
import 'package:frontend/screens/single_subject/messages_appbar/message_delete_button.dart';
import 'package:frontend/screens/single_subject/messages_appbar/message_edit_button.dart';
import 'package:frontend/screens/single_subject/messages_appbar/message_star_button.dart';
import 'package:frontend/screens/single_subject/messages_appbar/subject_title.dart';
import 'package:frontend/services/camera_service.dart';
import 'package:frontend/services/message_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/services/subject_service.dart';

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
    Future<void> reqPermission() async {
      await ref.read(cameraServiceProvider).requestPermission();
    }

    reqPermission();
    // dispose the previous [states] if there are
    ref.read(messageServiceProvider).deleteStates();

    // needed to check for camera idk ill check later
    ref.read(messageServiceProvider).retrieveLostData();

    // get the initial [messages] to show on page load
    ref.read(messageServiceProvider).getMessages(ref.read(subjectServiceProvider).getSubjectRowId);
  }

  @override
  Widget build(BuildContext context) {
    final messageService = ref.watch(messageServiceProvider);
    return WillPopScope(
      onWillPop: ref.read(messageServiceProvider).willPopScreen,
      child: Scaffold(
        appBar: AppBar(
          // toolbarHeight: kToolbarHeight,
          title: const SubjectTitle(),
          actions: <Widget>[
            // Star Button
            messageService.showHoldMessageIcons ? const MessageStarButton() : const SizedBox(),
            // Delete Button
            messageService.showHoldMessageIcons ? const MessageDeleteButton() : const SizedBox(),
            // Edit Button
            messageService.selectedMessages.length == 1 ? const MessageEditButton() : const SizedBox(),
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Material(
                shape: const CircleBorder(),
                clipBehavior: Clip.hardEdge,
                color: Colors.transparent,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert, size: 26.0),
                ),
              ),
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFDBD4CC),
          ),
          child: Column(
            children: [
              Expanded(
                flex: 4,
                child: ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  itemCount: messageService.messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Material(
                      color: messageService.selectedMessages.contains(
                        messageService.messages.elementAt(index),
                      )
                          ? Colors.grey[400]
                          : Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.black12,
                        onLongPress: () {
                          ref.read(messageServiceProvider).messageOnLongPress(messageService.messages.elementAt(index));
                          // message.messageOnLongPress(messages.elementAt(index));
                        },
                        onTap: () {
                          ref.read(messageServiceProvider).messageOnTap(messageService.messages.elementAt(index));
                        },
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // left area of message, should be used as message metadata(datetime etc.)
                              const Flexible(
                                flex: 1,
                                child: SizedBox(),
                              ),
                              // the message
                              Flexible(
                                flex: 7,
                                child: EachMessage(
                                  index: index,
                                  parentType: 'SingleSubjectPage',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // TEXTBOX AT THE BOTTOM
              Container(
                alignment: Alignment.bottomCenter,
                child: const InputAreaWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
