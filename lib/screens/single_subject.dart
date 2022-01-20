import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/single_subject/each_message.dart';
import 'package:frontend/screens/single_subject/edit_message_dialog.dart';
import 'package:frontend/screens/single_subject/input_area.dart';
import 'package:frontend/services/camera_service.dart';
import 'package:frontend/services/message_service.dart';
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
    Future<void> reqPermission() async {
      await ref.read(cameraServiceProvider).requestPermission();
    }

    reqPermission();
    // dispose the previous [states] if there are
    ref.read(messageServiceProvider).deleteStates();

    // needed to check for camera idk ill check later
    ref.read(messageServiceProvider).retrieveLostData();

    // get the initial [messages] to show on page load
    ref.read(messageServiceProvider).getData();
  }

  @override
  Widget build(BuildContext context) {
    final messageService = ref.watch(messageServiceProvider);
    return WillPopScope(
      onWillPop: ref.read(messageServiceProvider).willPopScreen,
      child: Scaffold(
        appBar: AppBar(
          title: messageService.selectedMessages.isNotEmpty
              ? Text(messageService.selectedMessages.length.toString())
              : Text(messageService.subjectName),
          // title: Text(widget.subjectName),
          actions: <Widget>[
            messageService.showHoldMessageIcons
                ? Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Material(
                      shape: const CircleBorder(),
                      clipBehavior: Clip.hardEdge,
                      color: Colors.transparent,
                      child: IconButton(
                        onPressed: () {
                          ref.read(messageServiceProvider).deleteMessages(messageService.subjectRowId);
                        },
                        icon: const Icon(Icons.delete_rounded, size: 26.0),
                      ),
                    ),
                  )
                : const SizedBox(),
            messageService.selectedMessages.length == 1
                ? Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Material(
                      shape: const CircleBorder(),
                      clipBehavior: Clip.hardEdge,
                      color: Colors.transparent,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              opaque: false,
                              pageBuilder: (context, _, __) => const EditMessageDialog(
                                  // messageRowId: messageService.selectedMessages[0].rowId!,
                                  ),
                            ),
                          );
                          // ref.read(messageServiceProvider).deleteMessages(messageService.subjectRowId);
                        },
                        icon: const Icon(Icons.edit_rounded, size: 26.0),
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
                  icon: const Icon(Icons.more_vert, size: 26.0),
                ),
              ),
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
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
                            ref
                                .read(messageServiceProvider)
                                .messageOnLongPress(messageService.messages.elementAt(index));
                            // message.messageOnLongPress(messages.elementAt(index));
                          },
                          onTap: () {
                            ref.read(messageServiceProvider).messageOnTap(messageService.messages.elementAt(index));
                          },
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: EachMessage(index: index),
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
                child: const InputAreaWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
