import 'dart:math';
import 'package:flutter/material.dart';
import 'package:frontend/db/database.dart';
import 'package:frontend/models/subject_model.dart';
import 'package:frontend/screens/single_subject.dart';
import 'package:frontend/screens/subject_list_page/single_subject_tile.dart';
import 'package:frontend/screens/subject_list_page/dialog_box.dart';
import 'package:uuid/uuid.dart';

class SubjectListPage extends StatefulWidget {
  // CameraDescription camera;
  final bool showHoldSubjectIcons;
  final Function subjectOnLongPress;
  final List<Subject> selectedSubjects;
  final Function setAfterSubjectOnTap;

  List<Subject> subjects;
  final Function updateSubjects;

  SubjectListPage({
    Key? key,
    required this.showHoldSubjectIcons,
    required this.subjectOnLongPress,
    required this.selectedSubjects,
    required this.setAfterSubjectOnTap,
    required this.subjects,
    required this.updateSubjects,
    // required this.camera,
  }) : super(key: key);

  @override
  State<SubjectListPage> createState() => _SubjectListPageState();
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

class _SubjectListPageState extends State<SubjectListPage> with AutomaticKeepAliveClientMixin {
  late String subjectName = "";

  // Adds a new subject
  Future<void> addSubject(String subjectName) async {
    if (subjectName.isEmpty) return;
    // Database Stuff
    WidgetsFlutterBinding.ensureInitialized();
    int status = await DBHelper().addSubject(Subject(
      rowId: null,
      id: const Uuid().v1(),
      name: subjectName,
      avatarColor: pickBgColor().value.toString(),
      timeCreated: DateTime.now().millisecondsSinceEpoch,
      timeUpdated: DateTime.now().millisecondsSinceEpoch,
    ));
    widget.updateSubjects(status);
  }

  void _onTap(BuildContext context, Subject subject) {
    if (widget.setAfterSubjectOnTap(subject)) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SingleSubject(
          subjectName: subject.name,
          subjectRowId: subject.rowId!,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECE5DD),
      body: Container(
        // margin: const EdgeInsets.only(left: 8, right: 8),
        child: ListView.builder(
          itemCount: widget.subjects.length,
          itemBuilder: (BuildContext context, int index) {
            // Material because "chat on hold" tasks
            return Material(
              color: widget.selectedSubjects.contains(widget.subjects[index]) ? Colors.grey[400] : Colors.transparent,
              child: InkWell(
                splashColor: Colors.grey[400],
                onLongPress: () {
                  widget.subjectOnLongPress(widget.subjects[index]);
                },
                onTap: () {
                  _onTap(context, widget.subjects[index]);
                },
                child: SingleSubjectTile(
                  subject: widget.subjects[index],
                ),
              ),
            );
          },
        ),
      ),

      // FAB
      floatingActionButton: FloatingActionButton(
        heroTag: "fab_to_dialogbox",
        child: const Icon(Icons.add),
        onPressed: () async {
          Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false,
              pageBuilder: (context, _, __) => NewSubjectDialog(
                title: "Add New Subject",
                subjectName: subjectName,
                text: "text",
                addSubject: addSubject,
              ),
            ),
          );
        },
      ),
    );
  }
}
