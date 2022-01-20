import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/db/database.dart';
import 'package:frontend/models/subject_model.dart';
import 'package:frontend/screens/single_subject.dart';
import 'package:frontend/screens/subject_list_page/single_subject_tile.dart';
import 'package:frontend/screens/subject_list_page/dialog_box.dart';
import 'package:frontend/services/message_service.dart';
import 'package:frontend/services/subject_service.dart';
import 'package:uuid/uuid.dart';

class SubjectListPage extends ConsumerStatefulWidget {
  // CameraDescription camera;
  // final bool showHoldSubjectIcons;
  // final Function subjectOnLongPress;
  // final List<Subject> selectedSubjects;
  // final Function setAfterSubjectOnTap;
  // final Function resetHoldSubjectEffects;

  // List<Subject> subjects;
  // final Function updateSubjects;

  SubjectListPage({
    Key? key,
    // required this.showHoldSubjectIcons,
    // required this.subjectOnLongPress,
    // required this.selectedSubjects,
    // required this.setAfterSubjectOnTap,
    // required this.resetHoldSubjectEffects,
    // required this.subjects,
    // required this.updateSubjects,
    // required this.camera,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SubjectListPageState();
}

Color pickBgColor() {
  return [
    Colors.redAccent,
    Colors.amberAccent,
    Colors.greenAccent[400],
    Colors.blueAccent,
    Colors.pinkAccent,
    Colors.purpleAccent,
  ][Random().nextInt(6)]!;
}

class _SubjectListPageState extends ConsumerState<SubjectListPage> with AutomaticKeepAliveClientMixin {
  // late String subjectName = "";
  // late String subjectDescription = "";

  // // Adds a new subject
  // Future<void> addSubject(String subjectName, String subjectDescription) async {
  //   if (subjectName.isEmpty) return;
  //   // Database Stuff
  //   WidgetsFlutterBinding.ensureInitialized();
  //   int status = await DBHelper().addSubject(Subject(
  //     rowId: null,
  //     id: const Uuid().v1(),
  //     name: subjectName,
  //     description: subjectDescription,
  //     avatarColor: pickBgColor().value.toString(),
  //     timeCreated: DateTime.now().millisecondsSinceEpoch,
  //     timeUpdated: DateTime.now().millisecondsSinceEpoch,
  //   ));
  //   ref.read(subjectServiceProvider).updateSubjects(status);
  // }

  void _onTap(BuildContext context, Subject subject) {
    if (ref.read(subjectServiceProvider).setAfterSubjectOnTap(subject)) {
      return;
    }

    ref.read(messageServiceProvider).setSubjectName(subject.name);
    ref.read(messageServiceProvider).setSubjectRowId(subject.rowId!);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SingleSubject(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFECE5DD),
      backgroundColor: Theme.of(context).backgroundColor,

      body: Container(
        // margin: const EdgeInsets.only(left: 8, right: 8),
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
              pageBuilder: (context, _, __) => const NewSubjectDialog(
                // subjectName: subjectName,
                // subjectDescription: subjectDescription,
                type: "add",
                // addSubject: addSubject,
              ),
            ),
          );
        },
      ),
    );
  }
}
