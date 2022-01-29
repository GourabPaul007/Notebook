import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/subject_model.dart';
import 'package:frontend/screens/single_subject_page.dart';
import 'package:frontend/screens/subject_list_page/single_subject_tile.dart';
import 'package:frontend/screens/subject_list_page/edit_subject_dialog.dart';
import 'package:frontend/services/message_service.dart';
import 'package:frontend/services/subject_service.dart';

class SubjectListPage extends ConsumerStatefulWidget {
  const SubjectListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SubjectListPageState();
}

class _SubjectListPageState extends ConsumerState<SubjectListPage> with AutomaticKeepAliveClientMixin {
  void _onTap(BuildContext context, Subject subject) {
    if (ref.read(subjectServiceProvider).setAfterSubjectOnTap(subject)) {
      return;
    }

    // ref.read(messageServiceProvider).setSubjectName(subject.name);
    // // ref.read(messageServiceProvider).setSubjectDescription(subject.description);
    // ref.read(messageServiceProvider).setSubjectRowId(subject.rowId!);
    ref.read(subjectServiceProvider).setSubject(subject);
    ref.read(subjectServiceProvider).setSubjectName(subject.name);
    ref.read(subjectServiceProvider).setSubjectRowId(subject.rowId!);
    ref.read(subjectServiceProvider).setSubjectDescription(subject.description);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SingleSubject(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final subjects = ref.watch(subjectServiceProvider).subjects;
    return Scaffold(
      // backgroundColor: const Color(0xFFECE5DD),
      backgroundColor: Theme.of(context).backgroundColor,

      body: Container(
        // child: ReorderableListView(
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

        child: ListView.builder(
          itemCount: ref.watch(subjectServiceProvider).subjects.length,
          itemBuilder: (BuildContext context, int index) {
            // Material because "chat on hold" tasks
            return Material(
              color: ref
                      .read(subjectServiceProvider)
                      .selectedSubjects
                      .contains(ref.watch(subjectServiceProvider).subjects[index])
                  ? Colors.grey[400]
                  : Colors.transparent,
              child: InkWell(
                splashColor: Colors.grey[400],
                onLongPress: () {
                  ref
                      .read(subjectServiceProvider)
                      .subjectOnLongPress(ref.watch(subjectServiceProvider).subjects[index]);
                },
                onTap: () {
                  // ref.read(subjectServiceProvider).onTap(context, ref.watch(subjectServiceProvider).subjects[index]);
                  _onTap(context, ref.watch(subjectServiceProvider).subjects[index]);
                },
                child: SingleSubjectTile(
                  subject: ref.watch(subjectServiceProvider).subjects[index],
                ),
              ),
            );
          },
        ),
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
          Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false,
              pageBuilder: (context, _, __) => const EditSubjectDialog(type: "add"),
            ),
          );
        },
      ),
    );
  }
}
