import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/helpers/color_list.dart';
import 'package:frontend/services/subject_service.dart';

// class EditSubjectDialog extends ConsumerStatefulWidget {
//   final int? rowId;
//   final String type;

//   const EditSubjectDialog({
//     Key? key,
//     this.rowId,
//     required this.type,
//   }) : super(key: key);

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _EditSubjectDialogState();
// }

// class _EditSubjectDialogState extends ConsumerState<EditSubjectDialog> {
//   final TextEditingController _subjectNameController = TextEditingController();
//   final TextEditingController _subjectDescriptionController = TextEditingController();

//   // If body textfield is empty then button should be disabled
//   bool _buttonDisabled = false;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.type == "edit") {
//       _subjectNameController.text = ref.read(subjectServiceProvider).getSubjectName;
//       _subjectDescriptionController.text = ref.read(subjectServiceProvider).getSubjectDescription;
//     }
//     // If body textfield is empty then button should be disabled
//     _subjectNameController.addListener(() {
//       if (_subjectNameController.text.isEmpty) {
//         setState(() => _buttonDisabled = true);
//       }
//       if (_subjectNameController.text.isNotEmpty) {
//         setState(() => _buttonDisabled = false);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.type == "add" ? "Add New Subject" : "Edit Subject"),
//       ),
//       body: Hero(
//         tag: "fab_to_dialogbox",
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
//           height: double.infinity,
//           color: Colors.grey[900],
//           child: Column(
//             children: [
//               // Subject Name TextField
//               Flexible(
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 8),
//                   child: Material(
//                     color: Colors.transparent,
//                     child: Container(
//                       margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
//                       child: TextField(
//                         controller: _subjectNameController,
//                         maxLines: 1,
//                         decoration: const InputDecoration(
//                           contentPadding: EdgeInsets.only(bottom: -24, left: 2),
//                           hintText: "Subject Name",
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               // Subject About TextField
//               Flexible(
//                 child: Padding(
//                   padding: const EdgeInsets.only(bottom: 8),
//                   child: Material(
//                     color: Colors.transparent,
//                     child: Container(
//                       margin: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
//                       child: TextField(
//                         controller: _subjectDescriptionController,
//                         maxLines: 1,
//                         decoration: const InputDecoration(
//                           contentPadding: EdgeInsets.only(bottom: -24, left: 2),
//                           hintText: "Subject Description (Optional)",
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Flexible(
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Flexible(
//                         child: Material(
//                           shape: const CircleBorder(),
//                           clipBehavior: Clip.hardEdge,
//                           color: Theme.of(context).primaryColor,
//                           child: IconButton(
//                             onPressed: () {
//                               Navigator.of(context).pop();
//                               ref.read(subjectServiceProvider).resetHoldSubjectEffects();
//                             },
//                             iconSize: 36,
//                             icon: const Icon(
//                               Icons.close_rounded,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 24),
//                       widget.type == "add"
//                           ? Flexible(
//                               child: Material(
//                                 shape: const CircleBorder(),
//                                 clipBehavior: Clip.hardEdge,
//                                 color: Theme.of(context).primaryColor,
//                                 child: IconButton(
//                                   onPressed: _buttonDisabled
//                                       ? null
//                                       : () {
//                                           ref.read(subjectServiceProvider).addSubject(
//                                                 _subjectNameController.text,
//                                                 _subjectDescriptionController.text,
//                                               );
//                                           _subjectNameController.text = "";
//                                           _subjectDescriptionController.text = "";
//                                           Navigator.of(context).pop();
//                                         },
//                                   iconSize: 36,
//                                   icon: const Icon(Icons.done_rounded, color: Colors.white),
//                                 ),
//                               ),
//                             )
//                           : const SizedBox(),
//                       widget.type == "edit"
//                           ? Flexible(
//                               child: Material(
//                                 shape: const CircleBorder(),
//                                 clipBehavior: Clip.hardEdge,
//                                 color: _buttonDisabled ? Colors.grey[800] : Theme.of(context).primaryColor,
//                                 child: IconButton(
//                                   onPressed: _buttonDisabled
//                                       ? null
//                                       : () {
//                                           ref.read(subjectServiceProvider).editSubject(
//                                                 widget.rowId!,
//                                                 _subjectNameController.text,
//                                                 _subjectDescriptionController.text,
//                                               );
//                                           _subjectNameController.text = "";
//                                           _subjectDescriptionController.text = "";
//                                           Navigator.of(context).pop();
//                                         },
//                                   color: Theme.of(context).primaryColor,
//                                   iconSize: 36,
//                                   icon: const Icon(Icons.done_rounded, color: Colors.white),
//                                 ),
//                               ),
//                             )
//                           : const SizedBox(),
//                       const SizedBox(width: 8),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// =============================================================================================
// =============================================================================================
// =============================================================================================
class EditSubjectDialog extends ConsumerStatefulWidget {
  final int? rowId;
  final String type;

  const EditSubjectDialog({
    Key? key,
    this.rowId,
    required this.type,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditSubjectDialogState();
}

class _EditSubjectDialogState extends ConsumerState<EditSubjectDialog> {
  final TextEditingController _subjectNameController = TextEditingController();
  final TextEditingController _subjectDescriptionController = TextEditingController();

  // If body textfield is empty then button should be disabled
  bool _buttonDisabled = true;
  int _value = Colors.deepPurple[100]!.value;

  @override
  void initState() {
    super.initState();
    _buttonDisabled = widget.type == "add" ? true : false;
    if (widget.type == "edit") {
      final subject = ref.read(subjectServiceProvider).getSubject;
      _subjectNameController.text = subject.name;
      _subjectDescriptionController.text = subject.description;
      _value = ref.read(subjectServiceProvider).subject.avatarColor;
    }
    // If body textfield is empty then button should be disabled
    _subjectNameController.addListener(() {
      if (_subjectNameController.text.isEmpty) {
        setState(() => _buttonDisabled = true);
      }
      if (_subjectNameController.text.isNotEmpty) {
        setState(() => _buttonDisabled = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Container(
      padding: const EdgeInsets.all(8),
      // margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: kElevationToShadow[1],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: 12,
            ),
            Text(
              widget.type == "add" ? "ADD NEW TOPIC" : "EDIT TOPIC",
              style: Theme.of(context).textTheme.bodyText1,
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
                      controller: _subjectNameController,
                      maxLines: 1,
                      cursorColor: Theme.of(context).primaryColor,
                      style: Theme.of(context).textTheme.bodyText2,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        hintText: "Topic Name",
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
            // Subject About TextField
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                    child: TextField(
                      controller: _subjectDescriptionController,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.bodyText2,
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        hintText: "Topic Description (Optional)",
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
            //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //     child: GridView.count(
            //       shrinkWrap: true,
            //       crossAxisCount: 4,
            //       mainAxisSpacing: 2,
            //       crossAxisSpacing: 16,
            //       children: List.generate(
            //         avatarColorList.length,
            //         (int index) {
            //           List<int> colors = avatarColorList;
            //           return ChoiceChip(
            //             shape: const CircleBorder(),
            //             side: BorderSide(
            //               color: _value == colors[index] ? Theme.of(context).colorScheme.onPrimary : Colors.transparent,
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
                  onPressed: _buttonDisabled
                      ? null
                      : widget.type == "add"
                          ? () {
                              ref.read(subjectServiceProvider).addSubject(
                                    _subjectNameController.text,
                                    _subjectDescriptionController.text,
                                    "",
                                  );
                              _subjectNameController.text = "";
                              _subjectDescriptionController.text = "";
                              Navigator.of(context).pop();
                            }
                          : () {
                              ref.read(subjectServiceProvider).editSubject(
                                    widget.rowId!,
                                    _subjectNameController.text,
                                    _subjectDescriptionController.text,
                                  );
                              _subjectNameController.text = "";
                              _subjectDescriptionController.text = "";
                              Navigator.of(context).pop();
                            },
                  child: Text(
                    widget.type == "add" ? "CREATE" : "UPDATE",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: _buttonDisabled ? Colors.grey[700] : Theme.of(context).primaryColor,
                    ),
                  ),
                  // style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Colors.green)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
