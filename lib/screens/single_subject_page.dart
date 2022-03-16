import 'package:flutter/material.dart';
import 'package:frontend/models/subject_model.dart';
import 'package:frontend/screens/single_subject_page/each_message.dart';
import 'package:frontend/screens/single_subject_page/edit_message_dialog.dart';
import 'package:frontend/screens/single_subject_page/input_area.dart';
import 'package:frontend/screens/subject_details_page.dart';
import 'package:frontend/services/message_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/services/subject_service.dart';

class SingleSubject extends ConsumerStatefulWidget {
  const SingleSubject({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SingleSubjectState();
}

class _SingleSubjectState extends ConsumerState<SingleSubject> {
  @override
  void initState() {
    super.initState();
    // needed to check for camera idk ill check later
    ref.read(messageServiceProvider).retrieveLostData();
    // get the initial [messages] to show on page load
    ref.read(messageServiceProvider).getMessages(ref.read(subjectServiceProvider).getSubject.rowId!);
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

            // Popup Menu Button
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Material(
                shape: const CircleBorder(),
                clipBehavior: Clip.hardEdge,
                color: Colors.transparent,
                child: PopupMenuTheme(
                  data: Theme.of(context).popupMenuTheme,
                  child: PopupMenuButton(
                    iconSize: 26.0,
                    onSelected: (result) {
                      switch (result) {
                        case 1:
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SubjectDetailsPage()),
                          );
                          break;
                        default:
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Text(
                          "Topic Info",
                          style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 16),
                        ),
                        value: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            // color: Color(0xFFDBD4CC),
            color: Theme.of(context).backgroundColor,
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
                          ? Theme.of(context).splashColor
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
                                  message: messageService.messages.elementAt(index),
                                  from: 'SingleSubjectPage',
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

// ===============================================================================================================================
// ===============================================================================================================================
// ===============================================================================================================================
// AppBar Area Widgets

class SubjectTitle extends ConsumerWidget {
  const SubjectTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMessages = ref.watch(messageServiceProvider).selectedMessages;
    final subjectName = ref.watch(subjectServiceProvider).subject.name;

    return SizedBox(
      height: kToolbarHeight,
      child: selectedMessages.isNotEmpty
          ? Container(
              padding: const EdgeInsets.only(left: 4),
              alignment: Alignment.centerLeft,
              width: double.maxFinite,
              child: Text(
                selectedMessages.length.toString(),
                style: Theme.of(context).textTheme.headline1,
              ),
            )
          : Material(
              color: Colors.transparent,
              child: InkWell(
                child: Container(
                  padding: const EdgeInsets.only(left: 4),
                  alignment: Alignment.centerLeft,
                  width: double.maxFinite,
                  child: Text(
                    subjectName,
                    style: Theme.of(context).textTheme.headline1,
                    maxLines: 1,
                  ),
                ),
                onTap: () {
                  // List<Subject> selectedSubjects = ref.watch(subjectServiceProvider).selectedSubjects;
                  // ref.read(subjectServiceProvider).setSubject(selectedSubjects[0]);

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SubjectDetailsPage()),
                  );
                },
              ),
            ),
    );
  }
}

class MessageStarButton extends ConsumerWidget {
  const MessageStarButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMessages = ref.watch(messageServiceProvider).selectedMessages;
    selectedMessages.any((element) => element.isFavourite);
    // selectedMessages.where((element) => element.isFavourite)

    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Material(
        shape: const CircleBorder(),
        clipBehavior: Clip.hardEdge,
        color: Colors.transparent,
        child: IconButton(
          onPressed: () async {
            await ref.read(messageServiceProvider).toggleStarMessages();
          },
          icon: Icon(
            ref.watch(messageServiceProvider).selectedMessages.every((element) => element.isFavourite)
                ? Icons.star_rate_rounded
                : Icons.star_border_rounded,
            size: 28.0,
          ),
        ),
      ),
    );
  }
}

class MessageEditButton extends StatelessWidget {
  const MessageEditButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Material(
        shape: const CircleBorder(),
        clipBehavior: Clip.hardEdge,
        color: Colors.transparent,
        child: IconButton(
          onPressed: () {
            showDialog(
                context: context,
                barrierColor: Colors.transparent,
                builder: (context) {
                  return const EditMessageDialog(type: "edit");
                });
          },
          icon: const Icon(Icons.edit_outlined, size: 26.0),
        ),
      ),
    );
  }
}

class MessageDeleteButton extends ConsumerWidget {
  const MessageDeleteButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Material(
        shape: const CircleBorder(),
        clipBehavior: Clip.hardEdge,
        color: Colors.transparent,
        child: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  title: const Text(
                    "Delete Message?",
                    style: TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.w400),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => {() {}, Navigator.pop(context, 'Cancel')},
                      child: Text("Cancel", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20)),
                    ),
                    TextButton(
                      onPressed: () => {
                        ref
                            .read(messageServiceProvider)
                            .deleteMessages(ref.watch(subjectServiceProvider).subject.rowId!),
                        Navigator.pop(context),
                      },
                      child: Text("Delete", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20)),
                    ),
                    const SizedBox(width: 4),
                  ],
                );
              },
            );
          },
          icon: const Icon(Icons.delete_outline_rounded, size: 26.0),
        ),
      ),
    );
  }
}
