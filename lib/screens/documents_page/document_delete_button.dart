import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/services/documents_service.dart';
import 'package:frontend/widgets/snack_bar.dart';

class DocumentDeleteButton extends StatelessWidget {
  const DocumentDeleteButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      color: Colors.transparent,
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.delete_outline_rounded),
              const SizedBox(height: 4),
              Text(
                "Delete",
                style: Theme.of(context).textTheme.headline3,
              ),
            ],
          ),
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: const Text(
                  "Delete Document(s)?",
                  style: TextStyle(color: Colors.black, fontSize: 28),
                ),
                content: Text(
                  "You will no longer see the documents. However it will not delete the files on device.",
                  style: TextStyle(color: Colors.grey[900], fontSize: 18),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => {() {}, Navigator.pop(context, 'Cancel')},
                    child: Text("CANCEL", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18)),
                  ),
                  const SizedBox(width: 2),
                  Consumer(
                    builder: (BuildContext context, WidgetRef ref, Widget? child) {
                      return TextButton(
                        onPressed: () => {
                          ref.read(documentServiceProvider).deleteSelectedDocuments(),
                          Navigator.pop(context),
                          SnackBarWidget.buildSnackbar(context, "Document Removed"),
                        },
                        child: Text("DELETE", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18)),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
