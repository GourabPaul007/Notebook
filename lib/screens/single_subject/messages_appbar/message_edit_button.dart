import 'package:flutter/material.dart';
import 'package:frontend/screens/single_subject/edit_message_dialog.dart';

class MessageEditButton extends StatelessWidget {
  const MessageEditButton({
    Key? key,
  }) : super(key: key);

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
            Navigator.of(context).push(
              PageRouteBuilder(
                opaque: false,
                pageBuilder: (context, _, __) => const EditMessageDialog(),
              ),
            );
          },
          icon: const Icon(Icons.edit_rounded, size: 26.0),
        ),
      ),
    );
  }
}
