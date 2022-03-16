import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/screens/subject_list_page/subject_delete_button.dart';
import 'package:frontend/screens/subject_list_page/subject_edit_button.dart';
import 'package:frontend/services/subject_service.dart';

class HoldSubjectDialog extends ConsumerStatefulWidget {
  const HoldSubjectDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HoldSubjectDialogState();
}

class _HoldSubjectDialogState extends ConsumerState<HoldSubjectDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.bottomCenter,
      backgroundColor: Theme.of(context).backgroundColor,
      elevation: 10,
      insetPadding: const EdgeInsets.all(16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16.0),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Subject Delete Button
          ref.watch(subjectServiceProvider).subjectsOnHold
              ? const Expanded(child: SubjectDeleteButton())
              : const SizedBox(),
          // Subject Edit Button
          ref.watch(subjectServiceProvider).selectedSubjects.length == 1
              ? const Expanded(child: SubjectEditButton())
              : const SizedBox(),
          // Expanded(
          //   child: Material(
          //     color: Colors.transparent,
          //     clipBehavior: Clip.hardEdge,
          //     child: InkWell(
          //       onTap: () {},
          //       child: Padding(
          //         padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
          //         child: Column(
          //           mainAxisSize: MainAxisSize.min,
          //           children: [
          //             const Icon(Icons.more_horiz),
          //             const SizedBox(height: 4),
          //             Text(
          //               "More",
          //               style: Theme.of(context).textTheme.headline3,
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
