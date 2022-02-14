import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/subject_model.dart';
import 'package:frontend/screens/single_subject_page.dart';
import 'package:frontend/screens/subject_list_page/hold_subject_dialog.dart';
import 'package:frontend/screens/subject_list_page/single_subject_tile.dart';
import 'package:frontend/screens/subject_list_page/edit_subject_dialog.dart';
import 'package:frontend/services/documents_service.dart';
import 'package:frontend/services/subject_service.dart';

class SubjectListPage extends ConsumerStatefulWidget {
  const SubjectListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SubjectListPageState();
}

class _SubjectListPageState extends ConsumerState<SubjectListPage> {
  @override
  void initState() {
    super.initState();
    ref.read(subjectServiceProvider).getAllSubjects("HomePage");
  }

  void _onTap(BuildContext context, Subject subject) {
    if (ref.read(subjectServiceProvider).subjectOnTap(subject)) {
      return;
    }

    // set subject data that will be used inside SingleSubject
    ref.read(subjectServiceProvider).setSubject(subject);
    ref.read(subjectServiceProvider).setSubjectName(subject.name);
    ref.read(subjectServiceProvider).setSubjectRowId(subject.rowId!);
    ref.read(subjectServiceProvider).setSubjectDescription(subject.description);

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const SingleSubject(),
      ),
    );
  }

  // @override
  // bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final subjects = ref.watch(subjectServiceProvider).subjects;
    return Scaffold(
      // backgroundColor: const Color(0xFFECE5DD),
      backgroundColor: Theme.of(context).backgroundColor,

      body:
          // ReorderableListView(
          //   onReorder: (oldIndex, newIndex) {},
          //   children: [
          //     for (Subject subject in subjects)
          //       ListTile(
          //         tileColor: Colors.red,
          //         key: ValueKey(subject),
          //         title: Padding(
          //           padding: const EdgeInsets.only(bottom: 4),
          //           child: Text(
          //             subject.name,
          //             style: const TextStyle(color: Colors.black, fontSize: 20),
          //           ),
          //         ),
          //         subtitle: Text(
          //           subject.description,
          //           style: const TextStyle(color: Colors.black, fontSize: 16),
          //         ),
          //       )
          //   ],
          // ),

          ListView.builder(
        itemCount: subjects.length,
        itemBuilder: (BuildContext context, int index) {
          // Material because "chat on hold" tasks
          return Container(
            margin: const EdgeInsets.only(left: 8, right: 8, top: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              // color: Colors.red,
            ),
            clipBehavior: Clip.hardEdge,
            child: Material(
              color: ref.read(subjectServiceProvider).selectedSubjects.contains(subjects[index])
                  ? Colors.indigo[100]
                  : Colors.transparent,
              child: InkWell(
                splashColor: Colors.indigo[100],
                onLongPress: () {
                  ref.read(subjectServiceProvider).subjectOnLongPress(subjects[index]);
                  // showDialog(
                  //   barrierColor: Colors.transparent,
                  //   context: context,
                  //   builder: (BuildContext context) {
                  //     return HoldSubjectDialog();
                  //   },
                  // );
                },
                onTap: () {
                  // ref.read(subjectServiceProvider).onTap(context, subjects[index]);
                  _onTap(context, subjects[index]);
                },
                child: SingleSubjectTile(
                  subject: subjects[index],
                ),
              ),
            ),
          );
        },
      ),

      // FAB
      floatingActionButton: FloatingActionButton(
        heroTag: "fab_to_dialogbox",
        child: const Icon(
          Icons.add_rounded,
          size: 32,
        ),
        onPressed: () async {
          ref.read(subjectServiceProvider).resetHoldSubjectEffects();
          showDialog(
            context: context,
            barrierColor: Colors.transparent,
            builder: (BuildContext context) {
              return const EditSubjectDialog(type: "add");
            },
          );
        },
      ),
    );
  }
}
