import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/subject_model.dart';
import 'package:frontend/screens/subject_list_page/edit_subject_dialog.dart';
import 'package:frontend/services/subject_service.dart';

class SubjectEditButton extends ConsumerWidget {
  const SubjectEditButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Material(
        shape: const CircleBorder(),
        clipBehavior: Clip.hardEdge,
        color: Colors.transparent,
        child: IconButton(
          onPressed: () async {
            List<Subject> selectedSubjects = ref.watch(subjectServiceProvider).selectedSubjects;
            int? subjectRowId = selectedSubjects[0].rowId;
            ref.read(subjectServiceProvider).setSubjectDescription(selectedSubjects[0].description);
            ref.read(subjectServiceProvider).setSubjectName(selectedSubjects[0].name);
            showDialog(
              context: context,
              barrierColor: Colors.transparent,
              builder: (BuildContext context) {
                return EditSubjectDialog(rowId: subjectRowId, type: "edit");
              },
            );
          },
          icon: const Icon(
            Icons.edit_outlined,
            size: 26.0,
          ),
        ),
      ),
    );
  }
}
