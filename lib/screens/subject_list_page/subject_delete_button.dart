import 'package:flutter/material.dart';
import 'package:frontend/models/subject_model.dart';

class SubjectDeleteButton extends StatelessWidget {
  final bool subjectOnHold;
  final List<Subject> selectedSubjects;
  final Future<void> Function(Subject subject) deleteSubject;

  const SubjectDeleteButton({
    Key? key,
    required this.subjectOnHold,
    required this.selectedSubjects,
    required this.deleteSubject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return subjectOnHold
        ? Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Material(
              shape: const CircleBorder(),
              clipBehavior: Clip.hardEdge,
              color: Colors.transparent,
              child: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        title: const Text(
                          "Delete Subject?",
                          style: TextStyle(color: Colors.black, fontSize: 28),
                        ),
                        content: Text(
                          "All Contents in this subject will be deleted.",
                          style: TextStyle(color: Colors.grey[900], fontSize: 18),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => {() {}, Navigator.pop(context, 'Cancel')},
                            child: const Text("Cancel", style: TextStyle(color: Color(0xFF3777f0), fontSize: 18)),
                          ),
                          TextButton(
                            onPressed: () => {
                              deleteSubject(selectedSubjects[0]),
                              Navigator.pop(context),
                            },
                            child: const Text("Delete", style: TextStyle(color: Colors.red, fontSize: 18)),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(
                  Icons.delete_rounded,
                  size: 26.0,
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}
