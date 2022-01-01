import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/message_model.dart';
import 'package:frontend/screens/single_subject/view_image.dart';

class EachMessage extends StatelessWidget {
  final Message message;
  final List<Message> messages;
  // final List<String> images;

  EachMessage({
    Key? key,
    required this.message,
    required this.messages,
    // required this.images,
  }) : super(key: key);

  // int messageColor = 0xFF3777f0;
  Color? messageColor = Colors.indigoAccent;

  late List<String> images =
      messages.where((value) => value.body.contains(".jpg") || value.body.length > 10).map((e) => e.body).toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.only(left: 0, right: 0),
      margin: const EdgeInsets.only(left: 60, right: 4, top: 2, bottom: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: messageColor,
        // border: Border.all(width: 12),
      ),
      child: Container(
          // padding: const EdgeInsets.all(4),
          child: !message.body.contains(".jpg")
              ?
              // FOR TEXT CHATS
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Text(
                    message.body,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                )
              : Container(
                  padding: const EdgeInsets.all(4),
                  alignment: Alignment.centerRight,
                  // color: Color.fromRGBO(0, 96, 91, 1.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewImage(
                            imageUrl: message.body,
                            images: images,
                            index: images.indexOf(message.body),
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.file(
                        File(message.body),
                      ),
                    ),
                  ),
                  width: 200,
                )),
    );
  }
}
