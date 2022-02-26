import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/helpers/change_color.dart';
import 'package:frontend/helpers/date_time.dart';
import 'package:frontend/models/message_model.dart';
import 'package:frontend/screens/single_subject_page/view_image.dart';
import 'package:frontend/services/message_service.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';

class EachMessage extends ConsumerWidget {
  final Message message;

  /// type is required to know if the message should render in [SingleSubjectPage] or [StarredMessagesPage]
  final String from;

  const EachMessage({
    Key? key,
    required this.from,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Sets images in serviceprovider
    ref.read(messageServiceProvider).setImages();

    return Container(
      // padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.only(left: 4, right: 8, top: 2, bottom: 2),
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(message.color),
          width: 3,
        ),
        borderRadius: BorderRadius.circular(8),
        color: Color(message.color),
        // color: Colors.transparent,
      ),
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // IF [message.title] exists then render it
            message.title != ""
                ? Container(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    // margin: const EdgeInsets.only(bottom: 2),
                    color: Color(message.color),
                    child: Text(
                      message.title,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  )
                : const SizedBox(),

            // FOR TEXT CHATS
            message.type == "text"
                ? Container(
                    padding: message.title != ""
                        ? const EdgeInsets.symmetric(vertical: 8, horizontal: 6)
                        : const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color: message.title != "" ? darkenColor(Color(message.color), 20) : Colors.transparent,
                      // backgroundBlendMode: BlendMode.color,
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              message.body,
                              // style: const TextStyle(fontSize: 16, color: Colors.white),
                              style: const TextStyle(color: Colors.white),
                              softWrap: true,
                            ),
                          ),
                          OtherMessageInfo(message: message),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),

            // FOR IMAGE MESSAGES
            message.type == "image"
                ? File(message.body).existsSync()
                    ? Stack(
                        children: [
                          InkWell(
                            onTap: from == "SingleSubjectPage"
                                ? () {
                                    final images = ref.watch(messageServiceProvider).images;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ViewImage(
                                          index: images.indexOf(message),
                                        ),
                                      ),
                                    );
                                  }
                                : () {},
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: Container(
                                constraints: const BoxConstraints(minWidth: 200, maxWidth: double.maxFinite),
                                child: Image.file(
                                  File(message.body),
                                  width: double.maxFinite,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 2,
                            right: 4,
                            child: OtherMessageInfo(message: message),
                          ),
                        ],
                      )
                    : const FileHasBeenDeleted()
                : const SizedBox(),

            // FOR DOCUMENT CHATS
            message.type == "document"
                ? File(message.body).existsSync()
                    ? InkWell(
                        onTap: () {
                          OpenFile.open(message.body);
                        },
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 5 / 7,
                              padding: const EdgeInsets.only(top: 12, bottom: 12, left: 10, right: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.0),
                                color: darkenColor(Color(message.color), 20),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    message.body.endsWith(".pdf")
                                        ? Icons.picture_as_pdf_rounded
                                        : Icons.description_rounded,
                                    color: message.body.endsWith(".pdf") ? Colors.redAccent : Colors.blue,
                                    size: 32,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      basename(message.body),
                                      style: const TextStyle(fontSize: 16, color: Colors.white),
                                      softWrap: false,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 2, bottom: 0, left: 4, right: 4),
                              color: Colors.deepPurpleAccent,
                              // height: 24,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    message.body.substring(message.body.lastIndexOf(".") + 1).toUpperCase(),
                                    style: const TextStyle(fontSize: 12, color: Colors.white),
                                  ),
                                  OtherMessageInfo(
                                    message: message,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    : const FileHasBeenDeleted()
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

class OtherMessageInfo extends StatelessWidget {
  final Message message;
  const OtherMessageInfo({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Row(
        children: [
          const SizedBox(width: 4),
          message.isFavourite
              ? const Icon(
                  Icons.star_rate_rounded,
                  size: 12,
                  color: Colors.white,
                )
              : const SizedBox(),
          const SizedBox(width: 4),
          Text(
            unixToTime(message.timeCreated),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class FileHasBeenDeleted extends StatelessWidget {
  const FileHasBeenDeleted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.all(8.0),
        constraints: const BoxConstraints(minWidth: 200, maxWidth: double.maxFinite),
        child: Center(
          child: Text(
            "File has been deleted",
            style: TextStyle(color: Colors.grey[300], fontStyle: FontStyle.italic),
          ),
        ),
      ),
    );
  }
}


// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:frontend/screens/single_subject/view_image.dart';
// import 'package:frontend/services/message_service.dart';

// class EachMessage extends ConsumerWidget {
//   final int index;

//   const EachMessage({Key? key, required this.index}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final messages = ref.watch(messageServiceProvider).messages;
//     final message = messages.elementAt(index);

//     late List<String> images = messages.where((value) => value.isImage).map((e) => e.body).toList();

//     return Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         const Flexible(flex: 1, child: SizedBox()),
//         Flexible(
//           flex: 4,
//           child: Container(
//             padding: const EdgeInsets.all(4),
//             margin: const EdgeInsets.only(left: 4, right: 4, top: 2, bottom: 2),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8),
//               color: Theme.of(context).primaryColor,
//             ),
//             child: message.isText
//                 ?
//                 // FOR TEXT CHATS
//                 Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Container(
//                         padding: message.title != ""
//                             ? const EdgeInsets.symmetric(vertical: 8, horizontal: 8)
//                             : const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(4.0),
//                           color: message.title != "" ? Colors.deepPurple[500] : Colors.transparent,
//                         ),
//                         child: Text(
//                           message.body,
//                           style: const TextStyle(fontSize: 20, color: Colors.white),
//                         ),
//                       ),
//                       message.title != ""
//                           ? Container(
//                               padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
//                               // color: Colors.red[500],
//                               // decoration: const BoxDecoration(),
//                               child: Text(
//                                 message.title,
//                                 style: const TextStyle(fontSize: 20, color: Colors.white),
//                                 textAlign: TextAlign.left,
//                               ),
//                             )
//                           : const SizedBox(),
//                     ],
//                   )
//                 :
//                 // FOR IMAGE MESSAGES
//                 Container(
//                     alignment: Alignment.centerRight,
//                     width: 200,
//                     child: InkWell(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => ViewImage(
//                               imageUrl: message.body,
//                               images: images,
//                               index: images.indexOf(message.body),
//                             ),
//                           ),
//                         );
//                       },
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(8.0),
//                         child: Image.file(
//                           File(message.body),
//                         ),
//                       ),
//                     ),
//                   ),
//           ),
//         ),
//       ],
//     );
//   }
// }
