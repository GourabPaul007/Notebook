import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/helpers/date_time.dart';
import 'package:frontend/screens/single_subject_page/each_message.dart';
import 'package:frontend/services/starred_message_service.dart';
import 'package:frontend/services/subject_service.dart';

/// Will show starred messages.
///
/// If called from [HomePage], It will show all starred messages
///
/// If called from [SubjectDetailsPage], It will show subject specific starred messages
class StarredMessagesPage extends ConsumerStatefulWidget {
  final String from;
  const StarredMessagesPage({Key? key, required this.from}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StarredMessagesPageState();
}

class _StarredMessagesPageState extends ConsumerState<StarredMessagesPage> {
  @override
  void initState() {
    super.initState();

    void initGetData() async {
      if (widget.from == "HomePage") {
        await ref.read(starredMessageServiceProvider).setStarredMessages(widget.from);
      } else {
        await ref.read(starredMessageServiceProvider).setStarredMessages(
              widget.from,
              ref.read(subjectServiceProvider).getSubject.rowId!,
            );
      }
    }

    initGetData();
  }

  @override
  Widget build(BuildContext context) {
    final starredMessages = ref.watch(starredMessageServiceProvider).starredMessages;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(
          "Favourite Notes",
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: starredMessages.length,
          itemBuilder: (BuildContext context, int index) {
            final singleMessage = starredMessages.elementAt(index);
            return Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: Colors.black12,
                onLongPress: () {
                  // ref.read(messageServiceProvider).messageOnLongPress(messageService.starredMessages.elementAt(index));
                  // message.messageOnLongPress(messages.elementAt(index));
                },
                onTap: () {
                  // ref.read(messageServiceProvider).messageOnTap(messageService.messages.elementAt(index));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 0, bottom: 2, left: 8, right: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            "Topic  ►  ",
                            style: Theme.of(context).textTheme.headline5!.copyWith(fontSize: 16),
                          ),
                          Text(
                            singleMessage.subjectName,
                            style: Theme.of(context).textTheme.headline5!.copyWith(fontSize: 16),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                unixToDate(singleMessage.timeCreated),
                                style: Theme.of(context).textTheme.headline5!.copyWith(fontSize: 16),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 7,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: EachMessage(
                              // index: index,
                              message: singleMessage,
                              from: 'StarredMessagesPage',
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
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: Colors.grey[700],
            );
          },
        ),
      ),
    );
  }
}
