import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/helpers/change_color.dart';
import 'package:frontend/services/documents_service.dart';
import 'package:frontend/widgets/snack_bar.dart';
import 'package:path/path.dart';
// import 'package:pdf_render/pdf_render.dart';

import 'documents_page/hold_document_dialog.dart';

// class PdfsPage extends ConsumerStatefulWidget {
//   const PdfsPage({Key? key}) : super(key: key);

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _PdfsPageState();
// }

// class _PdfsPageState extends ConsumerState<PdfsPage> {
//   @override
//   void initState() {
//     super.initState();
//     // get the initial [messages] to show on page load
//     ref.read(documentServiceProvider).getAllDocuments();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final documents = ref.watch(documentServiceProvider).documents;
//     return Scaffold(
//       backgroundColor: Theme.of(context).backgroundColor,
//       body: Stack(
//         children: [
//           Container(
//             height: double.infinity,
//             width: double.infinity,
//             margin: const EdgeInsets.all(12),
//             child: ListView.builder(
//               itemCount: documents.length,
//               itemBuilder: (context, index) {
//                 final singleDocument = documents[index];
//                 return EachDocumentCard(singleDocument: singleDocument);
//               },
//             ),
//           ),
//           ref.watch(documentServiceProvider).selectedDocuments.isNotEmpty
//               ? const Positioned(left: 24, right: 24, bottom: 24, child: HoldDocumentDialog())
//               : const SizedBox(),
//         ],
//       ),
//       floatingActionButton: ref.watch(documentServiceProvider).selectedDocuments.isNotEmpty
//           ? null
//           : FloatingActionButton.extended(
//               label: const Text("Add Books"),
//               icon: const Icon(
//                 Icons.add_rounded,
//                 size: 28,
//               ),
//               onPressed: () async {
//                 List<File>? newDocuments = await ref.read(documentServiceProvider).pickFiles();
//                 String message = "No Files Selected";
//                 if (newDocuments != null) {
//                   for (var eachDocument in newDocuments) {
//                     message = await ref.read(documentServiceProvider).addDocument(eachDocument);
//                   }
//                 }
//                 SnackBarWidget.buildSnackbar(context, message);
//               },
//             ),
//     );
//   }
// }

// class EachDocumentCard extends ConsumerWidget {
//   final Document singleDocument;
//   const EachDocumentCard({Key? key, required this.singleDocument}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Container(
//       height: 140,
//       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: kElevationToShadow[1],
//         color: Colors.white,
//       ),
//       clipBehavior: Clip.hardEdge,
//       child: Material(
//         color: ref.watch(documentServiceProvider).selectedDocuments.contains(singleDocument)
//             ? Theme.of(context).splashColor
//             : Colors.transparent,
//         child: InkWell(
//           onTap: () async {
//             ref.read(documentServiceProvider).documentOnTap(context, singleDocument);
//           },
//           onLongPress: () {
//             ref.read(documentServiceProvider).documentOnLongPress(singleDocument);
//           },
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: <Widget>[
//               Flexible(
//                 flex: 3,
//                 child: Center(
//                   child: singleDocument.type == "pdf"
//                       ? Container(
//                           decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
//                           clipBehavior: Clip.hardEdge,
//                           child: singleDocument.thumbnailPath == ""
//                               ? Icon(
//                                   Icons.picture_as_pdf_rounded,
//                                   size: 72,
//                                   color: singleDocument.type == "pdf" ? Colors.red : Colors.blue,
//                                 )
//                               : Image.file(File(singleDocument.thumbnailPath)),
//                         )
//                       : Icon(
//                           Icons.description_rounded,
//                           size: 72,
//                           color: singleDocument.type == "pdf" ? Colors.red : Colors.blue,
//                         ),
//                 ),
//               ),
//               Flexible(
//                 flex: 7,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.only(top: 20, bottom: 12, left: 8, right: 12),
//                       width: double.maxFinite,
//                       child: Text(
//                         // If no name then show name from file path, else show name
//                         singleDocument.name == "" ? basename(singleDocument.path) : singleDocument.name,
//                         softWrap: false,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 2,
//                         style: TextStyle(color: Theme.of(context).colorScheme.onBackground, fontSize: 18),
//                       ),
//                     ),
//                     // meta data
//                     Container(
//                       padding: const EdgeInsets.only(top: 8, bottom: 20, left: 8, right: 12),
//                       width: double.maxFinite,
//                       child: Text(
//                         singleDocument.size.toString() +
//                             " KB" +
//                             "  •  " +
//                             singleDocument.path.substring(singleDocument.path.lastIndexOf(".") + 1).toUpperCase(),
//                         style: TextStyle(
//                           color: Theme.of(context).colorScheme.onBackground,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class PdfsPage extends ConsumerStatefulWidget {
  const PdfsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PdfsPageState();
}

class _PdfsPageState extends ConsumerState<PdfsPage> {
  @override
  void initState() {
    super.initState();
    // // dispose the previous [states] if there are
    // ref.read(messageServiceProvider).deleteStates();

    // get the initial [messages] to show on page load
    ref.read(documentServiceProvider).getAllDocuments();
  }

  @override
  Widget build(BuildContext context) {
    final documents = ref.watch(documentServiceProvider).documents;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      // body: GridView.builder(
      //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      //   itemCount: documents.length,
      //   itemBuilder: (BuildContext context, int index) {
      //     return ListTile(
      //       title: Text(
      //         documents[index].title,
      //         style: const TextStyle(
      //           color: Colors.black,
      //         ),
      //       ),
      //     );
      //   },
      // ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            margin: const EdgeInsets.all(12),
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: List.generate(
                documents.length,
                (int index) {
                  final singleDocument = documents[index];
                  return Container(
                    // clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Color(singleDocument.color),
                        width: 4,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      clipBehavior: Clip.hardEdge,
                      child: Material(
                        color: ref.watch(documentServiceProvider).selectedDocuments.contains(singleDocument)
                            ? singleDocument.type == "pdf"
                                ? Colors.red[100]
                                : Colors.blue[100]
                            : Colors.white,
                        child: InkWell(
                          splashColor: singleDocument.type == "pdf" ? Colors.red[100] : Colors.blue[100],
                          onTap: () async {
                            ref.read(documentServiceProvider).documentOnTap(context, singleDocument);
                          },
                          onLongPress: () {
                            ref.read(documentServiceProvider).documentOnLongPress(singleDocument);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                flex: 5,
                                child: Container(
                                  color: Colors.transparent,
                                  child: Center(
                                    child: Icon(
                                      singleDocument.type == "pdf"
                                          ? Icons.picture_as_pdf_rounded
                                          : Icons.description_rounded,
                                      size: 48,
                                      color: singleDocument.type == "pdf" ? Colors.red : Colors.blue,
                                    ),
                                    // child: singleDocument.type == "pdf"
                                    //     ? PdfDocumentLoader.openFile(
                                    //         singleDocument.path,
                                    //         pageNumber: 1,
                                    //         pageBuilder: (context, textureBuilder, pageSize) {
                                    //           debugPrint("devicePixelRatio" +
                                    //               MediaQuery.of(context).devicePixelRatio.toString());
                                    //           return textureBuilder(renderingPixelRatio: 1.0);
                                    //         },
                                    //       )
                                    //     : Icon(
                                    //         singleDocument.type == "pdf"
                                    //             ? Icons.picture_as_pdf_rounded
                                    //             : Icons.description_rounded,
                                    //         size: 48,
                                    //         color: singleDocument.type == "pdf" ? Colors.red : Colors.blue,
                                    //       ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  // to cover the blank area where rounded corner in bottom of title
                                  color: Color(singleDocument.color),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: darkenColor(Color(singleDocument.color), 20),
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(4),
                                        bottomRight: Radius.circular(4),
                                      ),
                                    ),
                                    width: double.maxFinite,
                                    child: Center(
                                      child: Text(
                                        // If no name then show name from file path, else show name
                                        singleDocument.name == "" ? basename(singleDocument.path) : singleDocument.name,
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                            color: ref
                                                    .watch(documentServiceProvider)
                                                    .selectedDocuments
                                                    .contains(singleDocument)
                                                ? singleDocument.type == "pdf"
                                                    ? Colors.red[100]
                                                    : Colors.blue[100]
                                                : Colors.white,
                                            fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(top: 2),
                                width: double.maxFinite,
                                color: Color(singleDocument.color),
                                child: Center(
                                  child: Text(
                                    singleDocument.size.toString() +
                                        " KB" +
                                        "  •  " +
                                        singleDocument.path
                                            .substring(singleDocument.path.lastIndexOf(".") + 1)
                                            .toUpperCase(),
                                    style: TextStyle(
                                      color:
                                          ref.watch(documentServiceProvider).selectedDocuments.contains(singleDocument)
                                              ? singleDocument.type == "pdf"
                                                  ? Colors.red[100]
                                                  : Colors.blue[100]
                                              : Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          ref.watch(documentServiceProvider).selectedDocuments.isNotEmpty
              ? const Positioned(left: 24, right: 24, bottom: 24, child: HoldDocumentDialog())
              : const SizedBox(),
        ],
      ),

      floatingActionButton: ref.watch(documentServiceProvider).selectedDocuments.isNotEmpty
          ? null
          : FloatingActionButton.extended(
              label: const Text("Add Books"),
              icon: const Icon(
                Icons.add_rounded,
                size: 28,
              ),
              onPressed: () async {
                List<File>? newDocuments = await ref.read(documentServiceProvider).pickFiles();
                String message = "No Files Selected";
                if (newDocuments != null) {
                  for (var eachDocument in newDocuments) {
                    message = await ref.read(documentServiceProvider).addDocument(eachDocument);
                  }
                }
                SnackBarWidget.buildSnackbar(context, message);
              },
            ),
    );
  }
}
