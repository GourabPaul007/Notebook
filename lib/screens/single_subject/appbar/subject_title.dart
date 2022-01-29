import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/screens/subject_details_page.dart';
import 'package:frontend/services/message_service.dart';

class SubjectTitle extends ConsumerWidget {
  const SubjectTitle({
    Key? key,
    // required this.messageService,
  }) : super(key: key);

  // final MessageService messageService;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMessages = ref.watch(messageServiceProvider).selectedMessages;
    final subjectName = ref.watch(messageServiceProvider).subjectName;

    return SizedBox(
      height: kToolbarHeight,
      child: selectedMessages.isNotEmpty
          ? Container(
              padding: const EdgeInsets.only(left: 4),
              alignment: Alignment.centerLeft,
              width: double.maxFinite,
              child: Text(
                selectedMessages.length.toString(),
              ),
            )
          : Material(
              color: Colors.transparent,
              child: InkWell(
                child: Container(
                  padding: const EdgeInsets.only(left: 4),
                  alignment: Alignment.centerLeft,
                  width: double.maxFinite,
                  child: Text(
                    subjectName,
                    style: const TextStyle(fontSize: 24),
                    maxLines: 1,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SubjectDetailsPage()),
                  );
                },
              ),
            ),
    );
  }
}
