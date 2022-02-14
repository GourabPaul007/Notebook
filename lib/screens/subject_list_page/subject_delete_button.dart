import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/services/subject_service.dart';

class SubjectDeleteButton extends StatelessWidget {
  const SubjectDeleteButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    "Delete Subject?",
                    style: TextStyle(color: Colors.black, fontSize: 28),
                  ),
                  content: Text(
                    "The Subject and all Contents inside it will be deleted.",
                    style: TextStyle(color: Colors.grey[900], fontSize: 18),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => {() {}, Navigator.pop(context, 'Cancel')},
                      child: Text("CANCEL", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18)),
                    ),
                    const SizedBox(width: 2),
                    Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
                      return TextButton(
                        onPressed: () => {
                          // deleting the subject
                          ref.read(subjectServiceProvider).deleteSubjects(),
                          Navigator.pop(context),
                        },
                        child: Text("DELETE", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18)),
                      );
                    }),
                    const SizedBox(width: 8),
                  ],
                );
              },
            );
          },
          icon: const Icon(
            Icons.delete_outline_rounded,
            size: 26.0,
          ),
        ),
      ),
    );
  }
}
