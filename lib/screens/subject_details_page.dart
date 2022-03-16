import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/helpers/acronym.dart';
import 'package:frontend/helpers/change_color.dart';
import 'package:frontend/screens/starred_messages_page.dart';
import 'package:frontend/screens/subject_list_page/edit_subject_dialog.dart';
import 'package:frontend/services/subject_service.dart';

class SubjectDetailsPage extends ConsumerWidget {
  const SubjectDetailsPage({Key? key}) : super(key: key);

  String formatDate(DateTime dateTime) {
    return "${dateTime.day.toString()}/${dateTime.month.toString()}/${dateTime.year.toString()}";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final messageService = ref.watch(messageServiceProvider);
    final subject = ref.watch(subjectServiceProvider).subject;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Stack(children: [
              Container(
                color: Color(subject.avatarColor),
                child: Center(
                  child: Text(
                    makeAcronym(subject.name).toUpperCase(),
                    style: TextStyle(
                      color: darkenColor(Color(subject.avatarColor), 140),
                      fontSize: 72,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                left: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      subject.name,
                      style: TextStyle(
                          fontSize: 28, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onPrimary),
                    ),
                    Text(
                      "Created at  " +
                          formatDate(DateTime.fromMillisecondsSinceEpoch(
                            subject.timeCreated,
                          )),
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: Material(
                  color: Colors.transparent,
                  clipBehavior: Clip.hardEdge,
                  borderRadius: BorderRadius.circular(50),
                  child: IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierColor: Colors.transparent,
                        builder: (context) {
                          return EditSubjectDialog(
                            rowId: subject.rowId,
                            type: "edit",
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.edit_rounded, color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
              )
            ]),
          ),
          Expanded(
              flex: 8,
              child: Container(
                color: Colors.transparent,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        height: 56,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Description",
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            Text(
                              subject.description == "" ? "No Description Provided" : subject.description,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 8,
                        color: Theme.of(context).backgroundColor,
                      ),
                      Material(
                        color: Colors.transparent,
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const StarredMessagesPage(from: "SubjectDetailsPage"),
                              ),
                            );
                          },
                          title: Text(
                            "Starred Messages",
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          trailing: const Icon(
                            Icons.star_rate_rounded,
                          ),
                          // subtitle: Text("subtitle"),
                        ),
                      ),
                      // Divider(
                      //   color: Colors.grey[500],
                      //   indent: 16,
                      // ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
