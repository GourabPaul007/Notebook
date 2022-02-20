import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/services/documents_service.dart';

class DocumentShareButton extends StatelessWidget {
  const DocumentShareButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      color: Colors.transparent,
      child: Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
        return InkWell(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.share_rounded),
                const SizedBox(height: 4),
                Text(
                  "Share",
                  style: Theme.of(context).textTheme.headline3,
                ),
              ],
            ),
          ),
          onTap: () {
            ref.read(documentServiceProvider).shareSelectedDocuments();
          },
        );
      }),
    );
  }
}
