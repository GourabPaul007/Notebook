import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/db/database.dart';
import 'package:frontend/models/subject_model.dart';
import 'package:frontend/screens/subject_list_page.dart';
import 'package:frontend/screens/subject_list_page/subject_delete_button.dart';
import 'package:frontend/screens/subject_list_page/dialog_box.dart';
import 'package:frontend/screens/subject_list_page/subject_edit_button.dart';

class MyHomePage extends StatefulWidget {
  // CameraDescription camera;
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Subject> subjects = [];
  List<Subject> _selectedSubjects = [];
  bool _subjectOnHold = false;

  // =================================Main Features===================================
  // Delete Subject
  Future<void> deleteSubject(Subject subject) async {
    int status = await DBHelper().deleteSubject(subject);
    updateSubjects(status);
  }

  // Update Subject(eg. subjectName, subjectAbout etc. )
  Future<void> editSubject(int rowId, String name, String about) async {
    int status = await DBHelper().updateSubject(rowId, name, about);
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
    _resetHoldSubjectEffects();
  }
  // ============================================================================

// ************** can not be in subject-list-page cause the functionality is called by things on this page ***************
  bool hasSelectedSubjects() {
    return _selectedSubjects.isNotEmpty;
  }

  void _subjectOnLongPress(Subject subject) {
    HapticFeedback.vibrate();
    setState(() {
      _selectedSubjects = [subject];
      _subjectOnHold = hasSelectedSubjects();
    });
  }

  //When you tap on the already selected message, it should unselect, not go inside the page
  bool _setAfterSubjectOnTap(Subject subject) {
    if (_selectedSubjects.isNotEmpty) {
      _resetHoldSubjectEffects();
      return true;
    } else {
      _resetHoldSubjectEffects();
      return false;
    }
  }

  void _resetHoldSubjectEffects() {
    setState(() {
      _selectedSubjects = [];
      _subjectOnHold = hasSelectedSubjects();
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
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor:
              _subjectOnHold ? Colors.deepPurpleAccent[400] : Theme.of(context).appBarTheme.backgroundColor,
          systemOverlayStyle: _subjectOnHold
              ? SystemUiOverlayStyle(statusBarColor: Colors.deepPurpleAccent[400])
              : Theme.of(context).appBarTheme.systemOverlayStyle,
          // toolbarHeight: 0,
          elevation: Theme.of(context).appBarTheme.elevation,

          // TAB BAR
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
          title: const Text('WhatsNote', style: TextStyle(fontSize: 24)),
          actions: <Widget>[
            // Delete Button
            SubjectDeleteButton(
              subjectOnHold: _subjectOnHold,
              selectedSubjects: _selectedSubjects,
              deleteSubject: deleteSubject,
            ),

            // Edit Button
            SubjectEditButton(
              subjectOnHold: _subjectOnHold,
              selectedSubjects: _selectedSubjects,
              editSubject: editSubject,
            ),

            // Search Button
            Padding(
              padding: const EdgeInsets.all(0),
              child: Material(
                shape: const CircleBorder(),
                clipBehavior: Clip.hardEdge,
                color: Colors.transparent,
                child: IconButton(
                  onPressed: () async {
                    // showSearch(context: context, delegate: SearchDelegate<Subject>);
                  },
                  icon: const Icon(
                    Icons.search_rounded,
                    size: 26.0,
                  ),
                ),
              ),
            ),

            // Popup Menu Button
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Material(
                shape: const CircleBorder(),
                clipBehavior: Clip.hardEdge,
                color: Colors.transparent,
                child: PopupMenuButton(
                  color: Colors.white,
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
                      child: Text(
                        "Second",
                        style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400),
                      ),
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
              showHoldSubjectIcons: _subjectOnHold,
              subjectOnLongPress: _subjectOnLongPress,
              selectedSubjects: _selectedSubjects,
              setAfterSubjectOnTap: _setAfterSubjectOnTap,
              resetHoldSubjectEffects: _resetHoldSubjectEffects,

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
