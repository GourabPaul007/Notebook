import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/screens/single_subject/each_message.dart';
import 'package:frontend/services/message_service.dart';
import 'package:frontend/services/subject_service.dart';

class StarredMessagesPage extends ConsumerStatefulWidget {
  const StarredMessagesPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StarredMessagesPageState();
}

class _StarredMessagesPageState extends ConsumerState<StarredMessagesPage> {
  @override
  void initState() {
    super.initState();
    ref.read(messageServiceProvider).setStarredMessages(ref.read(subjectServiceProvider).getSubjectRowId);
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   ref.read(messageServiceProvider).disposeStarredMessages();
  // }

  @override
  Widget build(BuildContext context) {
    final messageService = ref.watch(messageServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Starred Messages",
          style: TextStyle(fontSize: 22),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: messageService.starredMessages.length,
          itemBuilder: (BuildContext context, int index) {
            return Material(
              color: messageService.selectedMessages.contains(
                messageService.starredMessages.elementAt(index),
              )
                  ? Colors.grey[400]
                  : Colors.transparent,
              child: InkWell(
                splashColor: Colors.black12,
                onLongPress: () {
                  // ref.read(messageServiceProvider).messageOnLongPress(messageService.starredMessages.elementAt(index));
                  // message.messageOnLongPress(messages.elementAt(index));
                },
                onTap: () {
                  // ref.read(messageServiceProvider).messageOnTap(messageService.messages.elementAt(index));
                },
                child: Row(
                  children: [
                    Flexible(
                      flex: 4,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: EachMessage(
                          index: index,
                          parentType: 'StarredMessagesPage',
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: const SizedBox(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider();
          },
        ),
      ),
    );
  }
}
