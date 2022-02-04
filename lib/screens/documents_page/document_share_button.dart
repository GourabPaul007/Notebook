import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/services/documents_service.dart';
import 'package:frontend/widgets/snack_bar.dart';
import 'package:share_plus/share_plus.dart';

class DocumentShareButton extends StatelessWidget {
  const DocumentShareButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(right: 6),
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.hardEdge,
          color: Colors.transparent,
          child: Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
            return IconButton(
              onPressed: () {
                ref.read(documentServiceProvider).shareSelectedDocuments();
              },
              icon: const Icon(
                Icons.share_rounded,
                size: 26,
              ),
            );
          }),
        ));
  }
}
