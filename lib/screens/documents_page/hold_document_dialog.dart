import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/screens/documents_page/document_delete_button.dart';
import 'package:frontend/screens/documents_page/document_share_button.dart';
import 'package:frontend/services/documents_service.dart';

class HoldDocumentDialog extends ConsumerStatefulWidget {
  const HoldDocumentDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HoldDocumentDialogState();
}

class _HoldDocumentDialogState extends ConsumerState<HoldDocumentDialog> {
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
          // Document Delete Button
          ref.watch(documentServiceProvider).documentsOnHold
              ? const Expanded(child: DocumentDeleteButton())
              : const SizedBox(),
          // Document Edit Button
          ref.watch(documentServiceProvider).selectedDocuments.length == 1
              ? const Expanded(child: DocumentShareButton())
              : const SizedBox(),
          Expanded(
            child: Material(
              color: Colors.transparent,
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.more_horiz),
                      const SizedBox(height: 4),
                      Text(
                        "More",
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
