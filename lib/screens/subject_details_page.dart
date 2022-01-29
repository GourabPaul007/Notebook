import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/screens/starred_messages_page.dart';
import 'package:frontend/screens/subject_list_page/edit_subject_dialog.dart';
import 'package:frontend/services/message_service.dart';
import 'package:frontend/services/subject_service.dart';

class SubjectDetailsPage extends ConsumerWidget {
  const SubjectDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageService = ref.watch(messageServiceProvider);
    final subjectService = ref.watch(subjectServiceProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Stack(children: [
                // subjectService.
                Image.network(
                  """https://images.unsplash.com/photo-1489549132488-d00b7eee80f1?ixlib=rb-1.2.1&
                  ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80""",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  // width: double.maxFinite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        subjectService.subjectName,
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
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
                    icon: const Icon(Icons.edit_rounded),
                  ),
                )
              ]),
            ),
            Expanded(
                flex: 8,
                child: Container(
                  color: const Color(0xFFECE5DD),
                  child: SingleChildScrollView(
                    // color: Colors.redAccent,
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          height: 56,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("Description", style: TextStyle(fontSize: 18, color: Colors.grey[800])),
                              Text(
                                subjectService.subjectDescription,
                                style: const TextStyle(fontSize: 18, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 8,
                          color: Colors.grey[400],
                        ),
                        Material(
                          color: Colors.transparent,
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const StarredMessagesPage(),
                                ),
                              );
                            },
                            title: const Text(
                              "Starred Messages",
                              style: TextStyle(fontSize: 20, color: Colors.black),
                            ),
                            trailing: const Icon(
                              Icons.star_rate_rounded,
                              color: Colors.black54,
                            ),
                            // subtitle: Text("subtitle"),
                          ),
                        ),
                        Divider(
                          color: Colors.grey[500],
                          indent: 16,
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
