import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/db/database.dart';
import 'package:frontend/models/subject_model.dart';
import 'package:frontend/screens/subject_list_page.dart';

class MyHomePage extends StatefulWidget {
  // CameraDescription camera;
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showHoldSubjectIcons = false;
  List<Subject> _selectedSubjects = [];

  bool hasSelectedSubjects() {
    return _selectedSubjects.isNotEmpty;
  }

  void _subjectOnLongPress(Subject subject) {
    HapticFeedback.vibrate();
    setState(() {
      _selectedSubjects = [subject];
      _showHoldSubjectIcons = hasSelectedSubjects();
    });
  }

  //When you tap on the already selected message, it should unselect, not go inside the page
  bool _setAfterSubjectOnTap(Subject subject) {
    if (_selectedSubjects.isNotEmpty) {
      setState(() {
        _selectedSubjects = [];
        _showHoldSubjectIcons = hasSelectedSubjects();
      });
      return true;
    } else {
      setState(() {
        _selectedSubjects = [];
        _showHoldSubjectIcons = hasSelectedSubjects();
      });
      return false;
    }
  }

  // Subjects Area
  List<Subject> subjects = [];

  Future<void> deleteSubject(Subject subject) async {
    int status = await DBHelper().deleteSubject(subject);
    updateSubjects(status);
  }

  // Updates the state with subjects after adding or deleting a subject
  Future<void> updateSubjects(int status) async {
    List<Subject> newSubjects = [];
    if (status != -1) {
      newSubjects = await DBHelper().getSubjects();
    }

    setState(() {
      subjects = newSubjects;
    });
  }

  // Get All Subjects on Page Load
  @override
  void initState() {
    super.initState();

    Future<void> getData() async {
      List<Subject> data = await DBHelper().getSubjects();
      setState(() {
        subjects = data;
      });
    }

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          systemOverlayStyle: Theme.of(context).appBarTheme.systemOverlayStyle,
          // toolbarHeight: 0,
          elevation: Theme.of(context).appBarTheme.elevation,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            // indicatorPadding: EdgeInsets.all(8),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 3,
            tabs: [
              Tab(icon: Icon(Icons.library_books_rounded)),
              Tab(icon: Icon(Icons.directions_transit)),
              Tab(icon: Icon(Icons.directions_bike)),
            ],
          ),
          title: const Text(
            'WhatsNote',
            style: TextStyle(fontSize: 24),
          ),
          actions: <Widget>[
            _showHoldSubjectIcons
                ? Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Material(
                      shape: const CircleBorder(),
                      clipBehavior: Clip.hardEdge,
                      color: Colors.transparent,
                      child: IconButton(
                        onPressed: () {
                          deleteSubject(_selectedSubjects[0]);
                        },
                        icon: const Icon(
                          Icons.delete_rounded,
                          size: 26.0,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Material(
                shape: const CircleBorder(),
                clipBehavior: Clip.hardEdge,
                color: Colors.transparent,
                child: PopupMenuButton(
                  color: const Color(0xFFECE5DD),
                  elevation: 5,
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      child: Text(
                        "View Details",
                        style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                      value: 1,
                    ),
                    const PopupMenuItem(
                      child: Text("Second",
                          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400)),
                      value: 2,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            // Icon(Icons.directions_car),
            SubjectListPage(
              // camera: camera,
              showHoldSubjectIcons: _showHoldSubjectIcons,
              subjectOnLongPress: _subjectOnLongPress,
              selectedSubjects: _selectedSubjects,
              setAfterSubjectOnTap: _setAfterSubjectOnTap,

              subjects: subjects,
              updateSubjects: updateSubjects,
            ),
            const Icon(Icons.directions_transit),
            const Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }
}
