import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/helpers/color_list.dart';
import 'package:frontend/screens/documents_page/edit_document_dialog.dart';
import 'package:frontend/services/documents_service.dart';
import 'package:frontend/services/theme_service.dart';
import 'package:frontend/widgets/snack_bar.dart';

class DocumentEditButton extends ConsumerStatefulWidget {
  const DocumentEditButton({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DocumentEditButtonState();
}

class _DocumentEditButtonState extends ConsumerState<DocumentEditButton> {
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
              const Icon(Icons.edit_outlined),
              const SizedBox(height: 4),
              Text(
                "Edit",
                style: Theme.of(context).textTheme.headline3,
              ),
            ],
          ),
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return const EditDocumentDialog();
            },
          );
        },
      ),
    );
  }
}
