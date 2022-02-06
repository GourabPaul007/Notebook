import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/services/message_service.dart';

import 'styles.dart';

class EditMessageDialog extends ConsumerStatefulWidget {
  // final int messageRowId;

  const EditMessageDialog({
    Key? key,
    // required this.messageRowId,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditMessageDialogState();
}

class _EditMessageDialogState extends ConsumerState<EditMessageDialog> {
  late TextEditingController _messageTitleController;
  late TextEditingController _messageBodyController;

  // If body textfield is empty then button should be disabled
  bool _buttonDisabled = false;

  @override
  void initState() {
    super.initState();

    _messageTitleController = TextEditingController();
    _messageBodyController = TextEditingController();

    _messageTitleController.text = ref.read(messageServiceProvider).getEditMessageTitle;
    _messageBodyController.text = ref.read(messageServiceProvider).getEditMessageBody;

    // If body textfield is empty then button should be disabled
    _messageBodyController.addListener(() {
      if (_messageBodyController.text.isEmpty) {
        setState(() => _buttonDisabled = true);
      }
      if (_messageBodyController.text.isNotEmpty) {
        setState(() => _buttonDisabled = false);
      }
    });
  }

  @override
  void dispose() {
    _messageTitleController.dispose();
    _messageBodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messageService = ref.watch(messageServiceProvider);

    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        toolbarHeight: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.black54,
        ),
      ),
      body: Hero(
        tag: "fab_to_dialogbox",
        child: Container(
          margin: const EdgeInsets.all(8),
          child: Container(
            color: Colors.transparent,
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 8),
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            "Edit Message",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Subject Name TextField
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            margin: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
                            child: TextField(
                              controller: _messageTitleController,
                              maxLines: 1,
                              cursorColor: cursorColor,
                              decoration: InputDecoration(
                                contentPadding: titlePadding_8_12,
                                hintText: "Title",
                                fillColor: Colors.grey[800],
                                filled: true,
                                border: textfieldBorder,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // ref.read(messageServiceProvider).getEditMessageIsText
                    messageService.selectedMessages.isNotEmpty && messageService.selectedMessages[0].type == 'text'
                        ?
                        // Subject About TextField
                        Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 0),
                              child: Material(
                                color: Colors.transparent,
                                child: Container(
                                  margin: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
                                  child: TextField(
                                    controller: _messageBodyController,
                                    maxLines: 4,
                                    cursorColor: cursorColor,
                                    decoration: InputDecoration(
                                      contentPadding: bodyPadding_12_12,
                                      hintText: "Message",
                                      fillColor: Colors.grey[800],
                                      filled: true,
                                      border: textfieldBorder,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                height: 42,
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // The Confirm Update Button
                            Flexible(
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                height: 42,
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _buttonDisabled
                                      ? null
                                      : () {
                                          ref.read(messageServiceProvider).editMessage(
                                                messageService.selectedMessages[0].rowId!,
                                                _messageTitleController.text,
                                                _messageBodyController.text,
                                              );
                                          _messageTitleController.text = "";
                                          _messageBodyController.text = "";
                                          Navigator.of(context).pop();
                                        },
                                  child: const Text(
                                    "Update",
                                    style: TextStyle(fontSize: 18, color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(primary: Colors.blue),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
