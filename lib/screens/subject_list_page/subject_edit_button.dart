import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/subject_model.dart';
import 'package:frontend/screens/subject_list_page/edit_subject_dialog.dart';
import 'package:frontend/services/subject_service.dart';

class SubjectEditButton extends ConsumerWidget {
  const SubjectEditButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Material(
        // shape: const CircleBorder(),
        clipBehavior: Clip.hardEdge,
        color: Colors.transparent,
        child: InkWell(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.edit_outlined),
                const SizedBox(height: 4),
                Text(
                  "Edit",
                  style: Theme.of(context).textTheme.headline3,
                ),
              ],
            ),
          ),
          onTap: () async {
            List<Subject> selectedSubjects = ref.watch(subjectServiceProvider).selectedSubjects;
            int? subjectRowId = selectedSubjects[0].rowId;
            ref.read(subjectServiceProvider).setSubject(selectedSubjects[0]);
            showDialog(
              context: context,
              barrierColor: Colors.transparent,
              builder: (BuildContext context) {
                return EditSubjectDialog(rowId: subjectRowId, type: "edit");
              },
            );
          },
        ),
      ),
    );
  }
}
