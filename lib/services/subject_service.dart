import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/repositories/subject_repository.dart';
import 'package:frontend/models/subject_model.dart';
import 'package:uuid/uuid.dart';

final subjectServiceProvider = ChangeNotifierProvider((ref) => SubjectService(ref));

class SubjectService extends ChangeNotifier {
  SubjectService(this.ref);

  final Ref ref;

  late Subject subject;
  late int subjectRowId;
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

  Subject get getSubject => subject;
  void setSubject(Subject s) {
    subject = s;
    notifyListeners();
  }

  String get getSubjectName => subjectName;
  void setSubjectName(String name) {
    subjectName = name;
    notifyListeners();
  }

  int get getSubjectRowId => subjectRowId;
  void setSubjectRowId(int id) {
    subjectRowId = id;
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

  /// get all [subjects] from database
  /// if called from [HomePage] then notify all listeners
  /// else if called from [SharedIntentPage], just get the data.
  Future<void> getAllSubjects(String calledFrom) async {
    List<Subject> data = await SubjectRepository().getSubjectsFromLocalDatabase();
    subjects = data;
    if (calledFrom != "ReceiveSharedIntentPage") {
      notifyListeners();
    }
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
      avatarColor: pickBgColor().value,
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
    // why ?
    ref.read(subjectServiceProvider).setSubjectName(subject.name);
    ref.read(subjectServiceProvider).setSubjectRowId(subject.rowId!);
  }

  /// Delete Subject
  Future<void> deleteSubject(Subject subject) async {
    int status = await SubjectRepository().deleteSubjectFromLocalDatabase(subject);
    // int status = await ref.read(subjectRepositoryProvider).deleteSubject(subject);
    // subjects.remove(subject);
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
    subjects = newSubjects;
    // notifyListeners();
    resetHoldSubjectEffects();
  }
  // ============================================================================

  void subjectOnLongPress(Subject subject) {
    HapticFeedback.vibrate();
    // setState(() {
    selectedSubjects = [subject];
    subjectOnHold = selectedSubjects.isNotEmpty;
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
    selectedSubjects = [];
    subjectOnHold = false;
    notifyListeners();
  }
}
