import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/helpers/date_time.dart';
import 'package:frontend/services/documents_service.dart';
import 'package:frontend/services/subject_service.dart';
import 'package:path/path.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class ReceiveSharedIntentPage extends StatefulWidget {
  List<SharedMediaFile>? sharedFiles;
  final Function clearIntentData;
  ReceiveSharedIntentPage({
    Key? key,
    required this.sharedFiles,
    required this.clearIntentData,
  }) : super(key: key);

  @override
  _ReceiveSharedIntentPageState createState() => _ReceiveSharedIntentPageState();
}

class _ReceiveSharedIntentPageState extends State<ReceiveSharedIntentPage> {
  // late StreamSubscription _intentDataStreamSubscription;
  // List<SharedMediaFile>? _sharedFiles;
  // String? _sharedText;
  List<String>? sharedFilePaths;
  late List<File>? files;

  @override
  void initState() {
    super.initState();

    files = widget.sharedFiles?.map((element) {
      return File(element.path);
    }).toList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // widget.clearIntentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Share"),
        leading: IconButton(
          onPressed: () {
            widget.clearIntentData();
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: files!.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: 120,
                  margin: const EdgeInsets.only(top: 8, bottom: 8, left: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 4,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(6),
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {},
                      child: Column(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Container(
                              color: Colors.white,
                              child: Center(
                                child: Icon(
                                  files![index].path.endsWith("pdf")
                                      ? Icons.picture_as_pdf_rounded
                                      : Icons.description_rounded,
                                  size: 48,
                                  color: files![index].path.endsWith("pdf") ? Colors.red : Colors.blue,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 2, right: 2, top: 2),
                              child: Center(
                                child: Text(
                                  basename(files![index].path),
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: const TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ),
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
          Card(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    for (File file in files!) {
                      await ref.read(documentServiceProvider).addDocument(file);
                    }
                    widget.clearIntentData();
                  },
                  child: ListTile(
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.grey[800],
                    ),
                    textColor: Colors.grey[800],
                    title: const Text(
                      "Add to Documents",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                  ),
                ),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 4, bottom: 4),
            child: Text(
              "Add to Topics",
              style: TextStyle(color: Colors.grey[600], fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          const TopicsArea(),
        ],
      ),
    );
  }
}

class TopicsArea extends ConsumerStatefulWidget {
  const TopicsArea({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TopicsAreaState();
}

class _TopicsAreaState extends ConsumerState<TopicsArea> {
  @override
  void initState() {
    super.initState();
    ref.read(subjectServiceProvider).getAllSubjects("ReceiveSharedIntentPage");
  }

  @override
  Widget build(BuildContext context) {
    final subjects = ref.watch(subjectServiceProvider).subjects;

    return Flexible(
      child: ListView.builder(
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          return Container(
            color: Colors.grey[100],
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(subjects[index].avatarColor),
                radius: 22,
                child: Text(
                  subjects[index].name[0],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              textColor: Colors.black,
              title: Text(subjects[index].name),
              subtitle: Text(subjects[index].description),
              trailing: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    unixToDate(subjects[index].timeUpdated),
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    unixToTime(subjects[index].timeUpdated),
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                ],
              ),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
