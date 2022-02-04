// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:native_pdf_view/native_pdf_view.dart';
// import 'package:path/path.dart';

// class PDFViewerPage extends StatefulWidget {
//   final File file;

//   const PDFViewerPage({
//     Key? key,
//     required this.file,
//   }) : super(key: key);

//   @override
//   _PDFViewerPageState createState() => _PDFViewerPageState();
// }

// class _PDFViewerPageState extends State<PDFViewerPage> {
//   late PDFViewController controller;
//   int pages = 0;
//   int indexPage = 0;

//   @override
//   Widget build(BuildContext context) {
//     final name = basename(widget.file.path);
//     final text = '${indexPage + 1} of $pages';

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(name),
//         actions: pages >= 2
//             ? [
//                 Center(child: Text(text)),
//                 IconButton(
//                   icon: Icon(Icons.chevron_left, size: 32),
//                   onPressed: () {
//                     final page = indexPage == 0 ? pages : indexPage - 1;
//                     controller.setPage(page);
//                   },
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.chevron_right, size: 32),
//                   onPressed: () {
//                     final page = indexPage == pages - 1 ? 0 : indexPage + 1;
//                     controller.setPage(page);
//                   },
//                 ),
//               ]
//             : null,
//       ),
//       body: PDFView(
//         filePath: widget.file.path,
//         // autoSpacing: false,
//         // swipeHorizontal: true,
//         pageSnap: false,
//         // pageFling: false,
//         onRender: (pages) => setState(() => this.pages = pages!),
//         onViewCreated: (controller) => setState(() => this.controller = controller),
//         onPageChanged: (indexPage, _) => setState(() => this.indexPage = indexPage!),
//         fitPolicy: FitPolicy.BOTH,
//       ),
//     );
//   }
// }

// class PDFViewerPage2 extends StatefulWidget {
//   final PdfController controller2;

//   const PDFViewerPage2({
//     Key? key,
//     required this.controller2,
//   }) : super(key: key);

//   @override
//   _PDFViewerPage2State createState() => _PDFViewerPage2State();
// }

// class _PDFViewerPage2State extends State<PDFViewerPage2> {
//   // int pages = 0;
//   // int indexPage = 0;

//   @override
//   Widget build(BuildContext context) {
//     // final name = basename(widget.file.path);

//     return Scaffold(
//         appBar: AppBar(
//           title: const Text("name"),
//         ),
//         body: PdfView(controller: widget.controller2));
//   }
// }
