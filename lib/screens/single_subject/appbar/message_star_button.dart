import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/services/message_service.dart';

class MessageStarButton extends ConsumerWidget {
  const MessageStarButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMessages = ref.watch(messageServiceProvider).selectedMessages;
    selectedMessages.any((element) => element.isFavourite);
    // selectedMessages.where((element) => element.isFavourite)

    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Material(
        shape: const CircleBorder(),
        clipBehavior: Clip.hardEdge,
        color: Colors.transparent,
        child: IconButton(
          onPressed: () async {
            await ref.read(messageServiceProvider).toggleStarMessages();
          },
          icon: Icon(
            ref.watch(messageServiceProvider).selectedMessages.every((element) => element.isFavourite)
                ? Icons.star_rate_rounded
                : Icons.star_border_rounded,
            size: 28.0,
          ),
        ),
      ),
    );
  }
}
