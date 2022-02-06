import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/services/documents_service.dart';
import 'package:frontend/widgets/snack_bar.dart';

class PdfsPage extends ConsumerStatefulWidget {
  const PdfsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PdfsPageState();
}

class _PdfsPageState extends ConsumerState<PdfsPage> {
  late final TabController _tabController;

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
      backgroundColor: Colors.white,
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
      body: Container(
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
                  color: Theme.of(context).primaryColor,
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
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
                        children: [
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
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              // color: Colors.red,
                              // to cover the blank area where rounded corner in bottom of title
                              color: Theme.of(context).primaryColor,
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                decoration: const BoxDecoration(
                                  color: Colors.deepPurple,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(4),
                                    bottomRight: Radius.circular(4),
                                  ),
                                ),
                                width: double.maxFinite,
                                child: Center(
                                  child: Text(
                                    singleDocument.name,
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
                            color: Theme.of(context).primaryColor,
                            child: Center(
                              child: Text(
                                singleDocument.size.toString() +
                                    " KB" +
                                    "  •  " +
                                    singleDocument.path
                                        .substring(singleDocument.path.lastIndexOf(".") + 1)
                                        .toUpperCase(),
                                style: TextStyle(
                                    color: ref.watch(documentServiceProvider).selectedDocuments.contains(singleDocument)
                                        ? singleDocument.type == "pdf"
                                            ? Colors.red[100]
                                            : Colors.blue[100]
                                        : Colors.white,
                                    fontSize: 14),
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
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Add Document"),
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

// Container(
//   // height: double.infinity,
//   child: Column(
//     children: [
//       ListView.builder(itemBuilder: (BuildContext context, int index) {
//         return ListTile(
//           title: Text(pdfs[index].name),
//         );
//       }),
//       // TextButton(
//       //   onPressed: () async {
//       //     final File? file = await pickFile();
//       //     if (file == null) return;
//       //     openPDF(context, file);
//       //   },
//       //   child: const Text("Load Pdf"),
//       // ),
//       // //
//       // //
//       // //
//       // TextButton(
//       //   onPressed: () async {
//       //     final File? pdf = await pickFile();
//       //     if (pdf == null) return;
//       //     openPDF2(context, pdf);
//       //   },
//       //   child: const Text("Open Pdf"),
//       // ),
//     ],
//   ),
// ),


