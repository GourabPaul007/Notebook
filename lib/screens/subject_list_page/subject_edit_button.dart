import 'package:flutter/material.dart';
import 'package:frontend/models/subject_model.dart';
import 'package:frontend/screens/subject_list_page/dialog_box.dart';

class SubjectEditButton extends StatelessWidget {
  final bool subjectOnHold;
  final List<Subject> selectedSubjects;
  final Future<void> Function(int rowId, String name, String description) editSubject;

  const SubjectEditButton({
    Key? key,
    required this.subjectOnHold,
    required this.selectedSubjects,
    required this.editSubject,
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
                onPressed: () async {
                  String subjectName = selectedSubjects[0].name;
                  String subjectDescription = selectedSubjects[0].description;
                  int? subjectRowId = selectedSubjects[0].rowId;

                  Navigator.of(context).push(
                    PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (context, _, __) => NewSubjectDialog(
                        rowId: subjectRowId,
                        subjectName: subjectName,
                        subjectDescription: subjectDescription,
                        type: "edit",
                        editSubject: editSubject,
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.edit_rounded,
                  size: 26.0,
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}
