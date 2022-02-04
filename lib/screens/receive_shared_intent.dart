import 'dart:async';

import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class ShareIntent extends StatefulWidget {
  List<SharedMediaFile>? sharedFiles;
  final Function clearIntentData;
  ShareIntent({Key? key, required this.sharedFiles, required this.clearIntentData}) : super(key: key);

  @override
  _ShareIntentState createState() => _ShareIntentState();
}

class _ShareIntentState extends State<ShareIntent> {
  // late StreamSubscription _intentDataStreamSubscription;
  // List<SharedMediaFile>? _sharedFiles;
  // String? _sharedText;

  @override
  void initState() {
    super.initState();

    // // For sharing images coming from outside the app while the app is in the memory
    // _intentDataStreamSubscription = ReceiveSharingIntent.getMediaStream().listen((List<SharedMediaFile> value) {
    //   setState(() {
    //     _sharedFiles = value;
    //     debugPrint("+++++++++++++++++Shared:" + (_sharedFiles?.map((f) => f.path).join(",") ?? ""));
    //   });
    // }, onError: (err) {
    //   debugPrint("getIntentDataStream error: $err");
    // });

    // // For sharing images coming from outside the app while the app is closed
    // ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
    //   setState(() {
    //     _sharedFiles = value;
    //     debugPrint("*****************Shared:" + (_sharedFiles?.map((f) => f.path).join(",") ?? ""));
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Share"),
      ),
      body: Column(
        children: [
          Text(
            // _sharedText ?? "null",
            widget.sharedFiles
                    ?.map((f) => "{Path: ${f.path}, Type: ${f.type.toString().replaceFirst("SharedMediaType.", "")}}\n")
                    .join(",\n") ??
                "no file",
            style: const TextStyle(color: Colors.black),
          ),
          Center(
            child: TextButton(
                onPressed: () {
                  widget.clearIntentData();
                },
                child: const Text(
                  "Button",
                  style: TextStyle(color: Colors.red),
                )),
          )
        ],
      ),
    );
  }
}
