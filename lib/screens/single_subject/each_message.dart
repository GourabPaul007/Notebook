import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/message_model.dart';
import 'package:frontend/screens/single_subject/view_image.dart';
import 'package:frontend/services/message_service.dart';

class EachMessage extends ConsumerWidget {
  final int index;

  const EachMessage({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final message = ref.watch(messageServiceProvider).messages.elementAt(index);

    // Sets images in serviceprovider
    ref.read(messageServiceProvider).setImages();

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Flexible(
          flex: 1,
          child: SizedBox(),
        ),
        Flexible(
          flex: 4,
          child: Container(
            padding: const EdgeInsets.all(4),
            margin: const EdgeInsets.only(left: 4, right: 4, top: 2, bottom: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).primaryColor,
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
                          margin: const EdgeInsets.only(bottom: 2),
                          child: Text(
                            message.title,
                            style: const TextStyle(fontSize: 20, color: Colors.white),
                            textAlign: TextAlign.left,
                          ),
                        )
                      : const SizedBox(),

                  // FOR TEXT CHATS
                  message.isText
                      ? Container(
                          padding: message.title != ""
                              ? const EdgeInsets.symmetric(vertical: 8, horizontal: 6)
                              : const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            color: message.title != "" ? Colors.deepPurple : Colors.transparent,
                          ),
                          child: Text(
                            message.body,
                            style: const TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        )
                      : const SizedBox(),

                  // FOR IMAGE MESSAGES
                  message.isImage
                      ? InkWell(
                          onTap: () {
                            final images = ref.watch(messageServiceProvider).images;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewImage(
                                  index: images.indexOf(message),
                                ),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Image.file(
                              File(message.body),
                              width: message.title.length < 20 ? 200 : double.maxFinite,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ],
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
