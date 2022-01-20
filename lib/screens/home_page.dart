import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/db/database.dart';
import 'package:frontend/models/subject_model.dart';
import 'package:frontend/screens/subject_list_page.dart';
import 'package:frontend/screens/subject_list_page/subject_delete_button.dart';
import 'package:frontend/screens/subject_list_page/dialog_box.dart';
import 'package:frontend/screens/subject_list_page/subject_edit_button.dart';
import 'package:frontend/services/subject_service.dart';

class MyHomePage extends ConsumerStatefulWidget {
  // CameraDescription camera;
  const MyHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  // Get All Subjects on Page Load
  @override
  void initState() {
    super.initState();

    ref.read(subjectServiceProvider).getData();
  }

  @override
  Widget build(BuildContext context) {
    final subjectService = ref.watch(subjectServiceProvider);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: subjectService.subjectOnHold
              ? Colors.deepPurpleAccent[400]
              : Theme.of(context).appBarTheme.backgroundColor,
          systemOverlayStyle: subjectService.subjectOnHold
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
            subjectService.subjectOnHold ? const SubjectDeleteButton() : const SizedBox(),

            // Edit Button
            subjectService.subjectOnHold ? const SubjectEditButton() : const SizedBox(),

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
                // showHoldSubjectIcons: _subjectOnHold,
                // subjectOnLongPress: _subjectOnLongPress,
                // selectedSubjects: _selectedSubjects,
                // setAfterSubjectOnTap: _setAfterSubjectOnTap,
                // resetHoldSubjectEffects: _resetHoldSubjectEffects,

                // subjects: subjects,
                // updateSubjects: updateSubjects,
                ),
            const Icon(Icons.directions_transit),
            const Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }
}
