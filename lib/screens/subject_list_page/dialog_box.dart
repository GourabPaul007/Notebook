import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewSubjectDialog extends StatefulWidget {
  final int? rowId;
  final String type, subjectName, subjectDescription;

  final void Function(String newSubjectName, String subjectDescription)? addSubject;
  final void Function(int rowId, String newSubjectName, String subjectDescription)? editSubject;

  const NewSubjectDialog({
    Key? key,
    this.rowId,
    required this.subjectName,
    required this.subjectDescription,
    required this.type,
    this.addSubject,
    this.editSubject,
  }) : super(key: key);

  @override
  _NewSubjectDialogState createState() => _NewSubjectDialogState();
}

class _NewSubjectDialogState extends State<NewSubjectDialog> {
  final TextEditingController _subjectNameController = TextEditingController();
  final TextEditingController _subjectDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _subjectNameController.text = widget.subjectName;
    _subjectDescriptionController.text = widget.subjectDescription;
  }

  @override
  Widget build(BuildContext context) {
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
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 8),
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            widget.type == "add" ? "Add New Subject" : "Edit Subject",
                            style: const TextStyle(
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
                            margin: const EdgeInsets.only(top: 8, left: 9, right: 8),
                            child: TextField(
                              controller: _subjectNameController,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: -24),
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
                                contentPadding: EdgeInsets.only(bottom: -24),
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
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                            widget.type == "add"
                                ? Flexible(
                                    child: ElevatedButton(
                                        onPressed: () {
                                          widget.addSubject!(
                                            _subjectNameController.text,
                                            _subjectDescriptionController.text,
                                          );
                                          _subjectNameController.text = "";
                                          _subjectDescriptionController.text = "";
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          "Create",
                                          style: TextStyle(fontSize: 18, color: Colors.white),
                                        ),
                                        style: ElevatedButton.styleFrom(primary: Colors.blue)),
                                  )
                                : const SizedBox(),
                            widget.type == "edit"
                                ? Flexible(
                                    child: ElevatedButton(
                                        onPressed: () {
                                          widget.editSubject!(
                                            widget.rowId!,
                                            _subjectNameController.text,
                                            _subjectDescriptionController.text,
                                          );
                                          _subjectNameController.text = "";
                                          _subjectDescriptionController.text = "";
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          "Update",
                                          style: TextStyle(fontSize: 18, color: Colors.white),
                                        ),
                                        style: ElevatedButton.styleFrom(primary: Colors.blue)),
                                  )
                                : const SizedBox()
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
