import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewSubjectDialog extends StatefulWidget {
  final String title, text, subjectName;

  final void Function(String newSubjectName) updateSubjects;

  const NewSubjectDialog({
    Key? key,
    required this.title,
    required this.subjectName,
    required this.text,
    required this.updateSubjects,
  }) : super(key: key);

  @override
  _NewSubjectDialogState createState() => _NewSubjectDialogState();
}

class _NewSubjectDialogState extends State<NewSubjectDialog> {
  final TextEditingController _subjectNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      // appBar: AppBar(
      //   title: Text('Dialog'),
      // ),
      body: Container(
        // color: Colors.white,
        margin: const EdgeInsets.all(8),
        child: Center(
          child: Hero(
            tag: "fab_to_dialogbox",
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
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: TextField(
                      controller: _subjectNameController,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: -24),
                        hintText: "Subject Name",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
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
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          widget.updateSubjects(_subjectNameController.text);
                          _subjectNameController.text = "";
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "Create",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                            // backgroundColor: MaterialStateColor.resolveWith(
                            //   (states) => Colors.green,
                            // ),
                            primary: Colors.blue),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
