import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/services/subject_service.dart';

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
  bool _buttonDisabled = false;

  @override
  void initState() {
    super.initState();
    if (widget.type == "edit") {
      _subjectNameController.text = ref.read(subjectServiceProvider).getSubjectName;
      _subjectDescriptionController.text = ref.read(subjectServiceProvider).getSubjectDescription;
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
    return Scaffold(
      // backgroundColor: Colors.black54,
      appBar: AppBar(
        title: Text(widget.type == "add" ? "Add New Subject" : "Edit Subject"),
      ),
      body: Hero(
        tag: "fab_to_dialogbox",
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          height: double.infinity,
          color: Colors.grey[900],
          child: Column(
            children: [
              // Subject Name TextField
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
                      child: TextField(
                        controller: _subjectNameController,
                        maxLines: 1,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: -24, left: 2),
                          hintText: "Subject Name",
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Subject About TextField
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                      child: TextField(
                        controller: _subjectDescriptionController,
                        maxLines: 1,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: -24, left: 2),
                          hintText: "Subject Description (Optional)",
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Material(
                          shape: const CircleBorder(),
                          clipBehavior: Clip.hardEdge,
                          color: Theme.of(context).primaryColor,
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            iconSize: 36,
                            icon: const Icon(Icons.close_rounded, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      widget.type == "add"
                          ? Flexible(
                              child: Material(
                                shape: const CircleBorder(),
                                clipBehavior: Clip.hardEdge,
                                color: Theme.of(context).primaryColor,
                                child: IconButton(
                                  onPressed: _buttonDisabled
                                      ? null
                                      : () {
                                          ref.read(subjectServiceProvider).addSubject(
                                                _subjectNameController.text,
                                                _subjectDescriptionController.text,
                                              );
                                          _subjectNameController.text = "";
                                          _subjectDescriptionController.text = "";
                                          Navigator.of(context).pop();
                                        },
                                  iconSize: 36,
                                  icon: const Icon(Icons.done_rounded, color: Colors.white),
                                ),
                              ),
                            )
                          : const SizedBox(),
                      widget.type == "edit"
                          ? Flexible(
                              child: Material(
                                shape: const CircleBorder(),
                                clipBehavior: Clip.hardEdge,
                                color: _buttonDisabled ? Colors.grey[800] : Theme.of(context).primaryColor,
                                child: IconButton(
                                  onPressed: _buttonDisabled
                                      ? null
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
                                  color: Theme.of(context).primaryColor,
                                  iconSize: 36,
                                  icon: const Icon(Icons.done_rounded, color: Colors.white),
                                ),
                              ),
                            )
                          : const SizedBox(),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // ),
    );
  }
}

// =============================================================================================
// =============================================================================================
// =============================================================================================
// class CustomDialogBox extends StatefulWidget {
//   String title, text, subjectName;
//   final void Function(String newSubjectName) updateSubjects;

//   CustomDialogBox({
//     Key? key,
//     required this.title,
//     required this.subjectName,
//     required this.text,
//     required this.updateSubjects,
//   }) : super(key: key);

//   @override
//   _CustomDialogBoxState createState() => _CustomDialogBoxState();
// }

// class _CustomDialogBoxState extends State<CustomDialogBox> {
//   final TextEditingController _subjectNameController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       elevation: 5,
//       backgroundColor: Colors.transparent,
//       child: contentBox(context),
//     );
//   }

//   contentBox(context) {
//     return Stack(
//       children: <Widget>[
//         Container(
//           padding: const EdgeInsets.all(8),
//           // margin: const EdgeInsets.all(24),
//           decoration: BoxDecoration(
//             shape: BoxShape.rectangle,
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//             // boxShadow: [
//             //   BoxShadow(color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
//             // ],
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               const SizedBox(
//                 height: 12,
//               ),
//               Text(
//                 widget.title,
//                 style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
//               ),
//               const SizedBox(
//                 height: 24,
//               ),
//               Container(
//                 margin: const EdgeInsets.all(8),
//                 child: TextField(
//                   controller: _subjectNameController,
//                   maxLines: 1,
//                   decoration: const InputDecoration(
//                     contentPadding: EdgeInsets.only(bottom: -24),
//                     hintText: "Subject Name",
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 22,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   // Material(
//                   //   color: Colors.amber,
//                   //   borderRadius: BorderRadius.all(Radius.circular(50)),
//                   //   clipBehavior: Clip.hardEdge,
//                   //   child: IconButton(
//                   //     onPressed: () {},
//                   //     icon: Icon(Icons.check_rounded),
//                   //   ),
//                   // ),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: const Text(
//                       "Cancel",
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: Colors.red,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   ElevatedButton(
//                     onPressed: () {
//                       widget.updateSubjects(_subjectNameController.text);
//                       _subjectNameController.text = "";
//                       Navigator.of(context).pop();
//                     },
//                     child: const Text(
//                       "Create",
//                       style: TextStyle(fontSize: 18),
//                     ),
//                     // style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Colors.green)),
//                   ),
//                   // const SizedBox(width: 8),
//                   // Material(
//                   //   color: Colors.transparent,
//                   //   borderRadius: BorderRadius.all(Radius.circular(4)),
//                   //   clipBehavior: Clip.hardEdge,
//                   //   child: InkWell(
//                   //     onTap: () {},
//                   //     child: Container(
//                   //       padding: EdgeInsets.all(12),
//                   //       child: const Text(
//                   //         "data",
//                   //         style: TextStyle(fontSize: 18),
//                   //       ),
//                   //     ),
//                   //   ),
//                   // ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
