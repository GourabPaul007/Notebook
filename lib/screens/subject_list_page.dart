import 'dart:math';
import 'package:flutter/material.dart';
import 'package:frontend/db/database.dart';
import 'package:frontend/models/subject_overview_model.dart';
import 'package:frontend/screens/subject_list_page/single_subject_tile.dart';
import 'package:frontend/screens/subject_list_page/dialog_box.dart';

class SubjectListPage extends StatefulWidget {
  // CameraDescription camera;
  const SubjectListPage({
    Key? key,
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

  Future<void> updateSubjects(String subjectName) async {
    if (subjectName == "") return;
    // Database Stuff
    WidgetsFlutterBinding.ensureInitialized();
    int status = await DBHelper().addSubject(Subject(name: subjectName, avatarColor: pickBgColor().value.toString()));
    List<Subject> newSubjects = [];
    if (status != -1) {
      newSubjects = await DBHelper().getSubjects();
    }

    debugPrint("*******************" + subjectName);
    setState(() {
      subjects = newSubjects;
    });
  }

  List<Subject> subjects = [];

  @override
  void initState() {
    super.initState();

    void getData() async {
      // var result = await DatabaseHelper.instance.getSubjects();
      var result = await DBHelper().getSubjects();
      setState(() {
        subjects = result;
      });
    }

    getData();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Flutter Demo Home Page'),
      // ),
      body: Container(
        child: ListView.builder(
          itemCount: subjects.length,
          itemBuilder: (BuildContext context, int index) {
            return SingleSubjectTile(
              subjectOverview: subjects[index],
              // camera: widget.camera,
            );
          },
        ),
      ),

      // FAB
      floatingActionButton: FloatingActionButton(
        // heroTag: "fab_to_dialogbox",
        child: const Icon(Icons.add),
        onPressed: () async {
          Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false,
              pageBuilder: (context, _, __) => NewSubjectDialog(
                title: "Add New Subject",
                subjectName: subjectName,
                text: "text",
                updateSubjects: updateSubjects,
              ),
            ),
          );
        },
      ),
    );
  }
}
