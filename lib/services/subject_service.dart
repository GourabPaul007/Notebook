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
  bool subjectsOnHold = false;

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
    getSubjects(status);
  }

  /// Delete Subject
  Future<void> deleteSubjects() async {
    int status = await SubjectRepository().deleteSubjectsFromLocalDatabase(selectedSubjects);
    // int status = await ref.read(subjectRepositoryProvider).deleteSubject(subject);
    // subjects.remove(subject);
    getSubjects(status);
  }

  // Update Subject(eg. subjectName, subjectAbout etc. )
  Future<void> editSubject(int rowId, String name, String about) async {
    int timeUpdated = DateTime.now().millisecondsSinceEpoch;
    int status = await SubjectRepository().updateSubjectFromLocalDatabase(rowId, name, about, timeUpdated);
    // int status = await ref.read(subjectRepositoryProvider).updateSubject(rowId, name, about, timeUpdated);
    getSubjects(status);
  }

  // Updates the state with subjects after adding or deleting a subject
  Future<void> getSubjects(int status) async {
    List<Subject> newSubjects = [];
    if (status != -1) {
      newSubjects = await SubjectRepository().getSubjectsFromLocalDatabase();
    }
    subjects = newSubjects;
    selectedSubjects = [];
    subjectsOnHold = false;
    notifyListeners();
  }
  // ============================================================================

  void subjectOnLongPress(Subject subject) {
    HapticFeedback.vibrate();
    // selectedSubjects = [subject];
    if (selectedSubjects.contains(subject)) {
      selectedSubjects.remove(subject);
    } else {
      selectedSubjects.add(subject);
    }
    subjectsOnHold = selectedSubjects.isNotEmpty;
    notifyListeners();
  }

  /// What happens when you tap on a Subject Tile.
  ///
  /// When you tap on the already selected subject, it should unselect, not go inside the page.
  bool subjectOnTap(Subject message) {
    if (selectedSubjects.isEmpty) {
      return false;
    } else if (selectedSubjects.isNotEmpty && !selectedSubjects.contains(message)) {
      selectedSubjects.add(message);
      subjectsOnHold = selectedSubjects.isNotEmpty;
    } else {
      selectedSubjects.remove(message);
      subjectsOnHold = selectedSubjects.isNotEmpty;
    }
    notifyListeners();
    return true;
  }

  void resetHoldSubjectEffects() {
    selectedSubjects = [];
    subjectsOnHold = false;
    notifyListeners();
  }
}
