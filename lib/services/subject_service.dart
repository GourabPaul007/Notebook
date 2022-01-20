import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/db/database.dart';
import 'package:frontend/repositories/subject_repository.dart';
import 'package:frontend/models/subject_model.dart';
import 'package:frontend/services/message_service.dart';
import 'package:uuid/uuid.dart';

final subjectServiceProvider = ChangeNotifierProvider((ref) => SubjectService(ref));

class SubjectService extends ChangeNotifier {
  SubjectService(this.ref);

  final Ref ref;

  late String subjectName = "";
  late String subjectDescription = "";
  List<Subject> subjects = [];
  List<Subject> selectedSubjects = [];
  bool subjectOnHold = false;

  String get getSubjectDescription => subjectDescription;
  void setSubjectDescription(String description) {
    subjectDescription = description;
    notifyListeners();
  }

  String get getSubjectName => subjectName;
  void setSubjectName(String name) {
    subjectName = name;
    notifyListeners();
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

  // =================================Main Features===================================

  // get all initial data
  Future<void> getData() async {
    List<Subject> data = await SubjectRepository().getSubjectsFromLocalDatabase();
    // List<Subject> data = await ref.read(subjectRepositoryProvider).getSubjects();

    // setState(() {
    subjects = data;
    // });
    notifyListeners();
  }

  // Adds a new subject
  Future<void> addSubject(String subjectName, String subjectDescription) async {
    if (subjectName.isEmpty) return;
    // Database Stuff
    WidgetsFlutterBinding.ensureInitialized();
    Subject subject = Subject(
      rowId: null,
      id: const Uuid().v1(),
      name: subjectName,
      description: subjectDescription,
      avatarColor: pickBgColor().value.toString(),
      timeCreated: DateTime.now().millisecondsSinceEpoch,
      timeUpdated: DateTime.now().millisecondsSinceEpoch,
    );
    int status = await SubjectRepository().addSubjectToLocalDatabse(subject);
    // int status = await ref.read(subjectRepositoryProvider).addSubject(subject);
    updateSubjects(status);
  }

  void onTap(BuildContext context, Subject subject) {
    if (setAfterSubjectOnTap(subject)) {
      return;
    }

    ref.read(messageServiceProvider).setSubjectName(subject.name);
    ref.read(messageServiceProvider).setSubjectRowId(subject.rowId!);

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => const SingleSubject(),
    //   ),
    // );
  }

  // Delete Subject
  Future<void> deleteSubject(Subject subject) async {
    int status = await SubjectRepository().deleteSubjectFromLocalDatabase(subject);
    // int status = await ref.read(subjectRepositoryProvider).deleteSubject(subject);
    updateSubjects(status);
  }

  // Update Subject(eg. subjectName, subjectAbout etc. )
  Future<void> editSubject(int rowId, String name, String about) async {
    int timeUpdated = DateTime.now().millisecondsSinceEpoch;
    int status = await SubjectRepository().updateSubjectFromLocalDatabase(rowId, name, about, timeUpdated);
    // int status = await ref.read(subjectRepositoryProvider).updateSubject(rowId, name, about, timeUpdated);
    updateSubjects(status);
  }

  // Updates the state with subjects after adding or deleting a subject
  Future<void> updateSubjects(int status) async {
    List<Subject> newSubjects = [];
    if (status != -1) {
      newSubjects = await SubjectRepository().getSubjectsFromLocalDatabase();
      // newSubjects = await ref.read(subjectRepositoryProvider).getSubjects();
    }
    // setState(() {
    subjects = newSubjects;
    // });
    notifyListeners();
    resetHoldSubjectEffects();
  }
  // ============================================================================

// ************** can not be in subject-list-page cause the functionality is called by things on this page ***************
  bool hasSelectedSubjects() {
    return selectedSubjects.isNotEmpty;
  }

  void subjectOnLongPress(Subject subject) {
    HapticFeedback.vibrate();
    // setState(() {
    selectedSubjects = [subject];
    subjectOnHold = hasSelectedSubjects();
    // });
    notifyListeners();
  }

  //When you tap on the already selected message, it should unselect, not go inside the page
  bool setAfterSubjectOnTap(Subject subject) {
    if (selectedSubjects.isNotEmpty) {
      resetHoldSubjectEffects();
      return true;
    } else {
      resetHoldSubjectEffects();
      return false;
    }
  }

  void resetHoldSubjectEffects() {
    // setState(() {
    selectedSubjects = [];
    subjectOnHold = hasSelectedSubjects();
    // });
    notifyListeners();
  }
}
