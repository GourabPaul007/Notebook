import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/services/message_service.dart';
import 'package:frontend/services/subject_service.dart';
import 'package:frontend/services/theme_service.dart';

import 'styles.dart';

class EditMessageDialog extends ConsumerStatefulWidget {
  // final int messageRowId;
  final String type;

  const EditMessageDialog({
    Key? key,
    // required this.messageRowId,
    required this.type,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditMessageDialogState();
}

class _EditMessageDialogState extends ConsumerState<EditMessageDialog> {
  final TextEditingController _messageTitleController = TextEditingController();
  final TextEditingController _messageBodyController = TextEditingController();

  // If body textfield is empty then button should be disabled
  bool _buttonDisabled = false;
  int _value = Colors.deepPurpleAccent.value;

  @override
  void initState() {
    super.initState();
    if (widget.type == "edit") {
      _messageTitleController.text = ref.read(messageServiceProvider).getEditMessageTitle;
      _messageBodyController.text = ref.read(messageServiceProvider).getEditMessageBody;
      _value = ref.read(messageServiceProvider).getEditMessageColor;
      setState(() {
        _buttonDisabled = false;
      });
    } else {
      setState(() {
        _buttonDisabled = true;
      });
    }

    // If body textfield is empty then button should be disabled
    _messageBodyController.addListener(() {
      if (_messageBodyController.value.text.isEmpty || _messageBodyController.text == "") {
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
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Flexible(
                      child: Align(
                        heightFactor: 1,
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 8),
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              widget.type == "new" ? "New Rich Text" : "Edit Message",
                              style: Theme.of(context).textTheme.headline2!.copyWith(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                  ),
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
                              style: TextStyle(
                                color: ref.watch(themeServiceProvider).theme == "dark" ? Colors.white : Colors.black,
                              ),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                hintText: "Title",
                                hintStyle: TextStyle(
                                  color:
                                      ref.watch(themeServiceProvider).theme == "dark" ? Colors.grey : Colors.grey[700],
                                ),
                                fillColor: ref.watch(themeServiceProvider).theme == "dark"
                                    ? Colors.grey[900]
                                    : Colors.grey[300],
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // ref.read(messageServiceProvider).getEditMessageIsText
                    (messageService.selectedMessages.isNotEmpty && messageService.selectedMessages[0].type == 'text') ||
                            widget.type == "new"
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
                                    style: TextStyle(
                                      color:
                                          ref.watch(themeServiceProvider).theme == "dark" ? Colors.white : Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: bodyPadding_12_12,
                                      hintText: "Message",
                                      hintStyle: TextStyle(
                                        color: ref.watch(themeServiceProvider).theme == "dark"
                                            ? Colors.grey
                                            : Colors.grey[700],
                                      ),
                                      fillColor: ref.watch(themeServiceProvider).theme == "dark"
                                          ? Colors.grey[900]
                                          : Colors.grey[300],
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 8.0, bottom: 8.0),
                        child: Text(
                          "Message Color",
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Wrap(
                        children: List<Widget>.generate(
                          6,
                          (int index) {
                            List<int> colors = [
                              Colors.deepPurpleAccent.value,
                              0xFF2196f3,
                              0xFFFF4444,
                              0xFF44DD44,
                              0xFFfdd835,
                              0xFFf4511e,
                            ];
                            return ChoiceChip(
                              shape: const CircleBorder(),
                              side: BorderSide(
                                color: _value == colors[index] ? Colors.white54 : Colors.transparent,
                                width: 2,
                              ),
                              backgroundColor: Color(colors[index]),
                              selectedColor: Color(colors[index]),
                              padding: const EdgeInsets.all(20),
                              label: const SizedBox(),
                              selected: _value == colors[index],
                              onSelected: (bool selected) {
                                setState(() {
                                  _value = colors[index];
                                });
                              },
                            );
                          },
                        ).toList(),
                      ),
                    ),
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
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).primaryColor,
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
                                child: TextButton(
                                  onPressed: _buttonDisabled
                                      ? null
                                      : widget.type == "new"
                                          ? () {
                                              ref.read(messageServiceProvider).addMessage(
                                                  _messageTitleController.text,
                                                  _messageBodyController.text,
                                                  _value,
                                                  ref.watch(subjectServiceProvider).subjectRowId,
                                                  "text");
                                              _messageTitleController.text = "";
                                              _messageBodyController.text = "";
                                              Navigator.of(context).pop();
                                            }
                                          : () {
                                              ref.read(messageServiceProvider).editMessage(
                                                    messageService.selectedMessages[0].rowId!,
                                                    _messageTitleController.text,
                                                    _messageBodyController.text,
                                                    _value,
                                                  );
                                              _messageTitleController.text = "";
                                              _messageBodyController.text = "";
                                              Navigator.of(context).pop();
                                            },
                                  child: Text(
                                    widget.type == "new" ? "Create" : "Update",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: _buttonDisabled ? Colors.grey[700] : Theme.of(context).primaryColor),
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
