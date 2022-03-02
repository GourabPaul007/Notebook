import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/helpers/color_list.dart';
import 'package:frontend/services/documents_service.dart';

class EditDocumentDialog extends ConsumerStatefulWidget {
  const EditDocumentDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditDocumentDialogState();
}

class _EditDocumentDialogState extends ConsumerState<EditDocumentDialog> {
  final _bookNameController = TextEditingController();

  int _value = Colors.deepPurpleAccent.value;

  @override
  void initState() {
    super.initState();
    _value = ref.read(documentServiceProvider).getEditMessageColor;
  }

  @override
  void dispose() {
    _bookNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: kElevationToShadow[1],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: 12,
              ),
              Center(
                child: Text(
                  "EDIT BOOK",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              // Subject Name TextField
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
                      child: TextField(
                        controller: _bookNameController,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.bodyText2,
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                          hintText: "Book Name",
                          hintStyle: const TextStyle(color: Colors.grey),
                          fillColor: Theme.of(context).colorScheme.surface,
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

              // TODO: UnComment for future update
              // Flexible(
              //   child: Padding(
              //     padding: const EdgeInsets.only(top: 16.0, left: 8.0, bottom: 8.0),
              //     child: Text(
              //       "Set document color",
              //       style: Theme.of(context).textTheme.bodyText1,
              //     ),
              //   ),
              // ),
              // Flexible(
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //     child: GridView.count(
              //       shrinkWrap: true,
              //       crossAxisCount: 4,
              //       mainAxisSpacing: 2,
              //       crossAxisSpacing: 16,
              //       children: List.generate(
              //         documentColorList.length,
              //         (int index) {
              //           List<int> colors = documentColorList;
              //           return ChoiceChip(
              //             shape: const CircleBorder(),
              //             side: BorderSide(
              //               color:
              //                   _value == colors[index] ? Theme.of(context).colorScheme.onPrimary : Colors.transparent,
              //               width: 3,
              //             ),
              //             backgroundColor: Color(colors[index]),
              //             selectedColor: Color(colors[index]),
              //             padding: const EdgeInsets.all(20),
              //             label: const SizedBox(),
              //             selected: _value == colors[index],
              //             onSelected: (bool selected) {
              //               setState(() {
              //                 _value = colors[index];
              //               });
              //             },
              //           );
              //         },
              //       ),
              //     ),
              //   ),
              // ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "CANCEL",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // color: _buttonDisabled ? Colors.grey[800] : Theme.of(context).primaryColor,
                  TextButton(
                    onPressed: () async {
                      await ref.read(documentServiceProvider).editDocument(_bookNameController.text, _value);
                      _bookNameController.text = "";
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "UPDATE",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
