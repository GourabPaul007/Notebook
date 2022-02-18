import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final subjectService = ref.watch(subjectServiceProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
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
              Image.network(
                """https://images.unsplash.com/photo-1489549132488-d00b7eee80f1?ixlib=rb-1.2.1&
                ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80""",
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              Positioned(
                bottom: 8,
                left: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      subjectService.subjectName,
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "Created at  " +
                          formatDate(DateTime.fromMillisecondsSinceEpoch(
                            subjectService.subject.timeCreated,
                          )),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditSubjectDialog(
                            rowId: subjectService.subjectRowId,
                            type: "edit",
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit_rounded, color: Colors.white),
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
                              subjectService.subjectDescription,
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
