import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/services/message_service.dart';
import 'package:frontend/services/subject_service.dart';

class MessageDeleteButton extends ConsumerWidget {
  const MessageDeleteButton({
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
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  title: const Text(
                    "Delete Message?",
                    style: TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.w400),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => {() {}, Navigator.pop(context, 'Cancel')},
                      child: Text("Cancel", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20)),
                    ),
                    TextButton(
                      onPressed: () => {
                        ref
                            .read(messageServiceProvider)
                            .deleteMessages(ref.watch(subjectServiceProvider).subject.rowId!),
                        Navigator.pop(context),
                      },
                      child: Text("Delete", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20)),
                    ),
                    const SizedBox(width: 4),
                  ],
                );
              },
            );
          },
          icon: const Icon(Icons.delete_outline_rounded, size: 26.0),
        ),
      ),
    );
  }
}
