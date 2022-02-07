import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/screens/single_subject/camera_screen.dart';
import 'package:frontend/screens/single_subject/edit_message_dialog.dart';
import 'package:frontend/services/message_service.dart';
import 'package:frontend/services/subject_service.dart';

class SingleSubjectBottomSheet extends StatelessWidget {
  final int subjectRowId;

  const SingleSubjectBottomSheet({Key? key, required this.subjectRowId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 0),
          height: 260,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: kElevationToShadow[1],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BottomSheetAction(actionType: "document", subjectRowId: subjectRowId),
                  BottomSheetAction(actionType: "camera", subjectRowId: subjectRowId),
                  BottomSheetAction(actionType: "gallery", subjectRowId: subjectRowId),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BottomSheetAction(actionType: "richNote", subjectRowId: subjectRowId),
                  BottomSheetAction(subjectRowId: subjectRowId),
                  BottomSheetAction(subjectRowId: subjectRowId),
                ],
              ),
            ],
          ),
        ),
        // the hidden container over [inputArea], will close the popup on tap.
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            height: 60,
            color: Colors.transparent,
          ),
        ),
      ],
    );
  }
}

class BottomSheetAction extends StatelessWidget {
  final String? actionType;
  final int subjectRowId;

  const BottomSheetAction({
    Key? key,
    this.actionType,
    required this.subjectRowId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (actionType) {
      case null:
        return Flexible(
          flex: 1,
          child: Column(
            children: const [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 32,
              ),
            ],
          ),
        );
      // break;

      case "document":
        return Flexible(
          flex: 1,
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.deepPurpleAccent,
                radius: 32,
                child: Consumer(
                  builder: (BuildContext context, WidgetRef ref, Widget? child) {
                    return IconButton(
                      onPressed: () async {
                        await ref.read(messageServiceProvider).pickDocuments(subjectRowId);
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.insert_drive_file_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Document",
                style: TextStyle(color: Colors.grey[700]),
              )
            ],
          ),
        );
      case "camera":
        return Flexible(
          flex: 1,
          child: Column(
            children: [
              CircleAvatar(
                  backgroundColor: Colors.pink,
                  radius: 32,
                  child: Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
                    return IconButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TakePictureScreen(),
                          ),
                        );
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    );
                  })),
              const SizedBox(height: 8),
              Text(
                "Camera",
                style: TextStyle(color: Colors.grey[700]),
              )
            ],
          ),
        );
      case "gallery":
        return Flexible(
          flex: 1,
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.purple,
                radius: 32,
                child: Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  return IconButton(
                    onPressed: () async {
                      await ref.read(messageServiceProvider).imgFromGallery(subjectRowId);
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.image_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),
              Text(
                "Gallery",
                style: TextStyle(color: Colors.grey[700]),
              )
            ],
          ),
        );
      case "richNote":
        return Flexible(
          flex: 1,
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.lightBlue,
                radius: 32,
                child: IconButton(
                  onPressed: () async {
                    await Navigator.of(context).push(
                      // have to use PageRouteBuilder if want opacity
                      PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (context, _, __) => const EditMessageDialog(type: "new"),
                      ),
                    );

                    // await Navigator.of(context).push(
                    //   MaterialPageRoute(builder: (context) => const EditMessageDialog(type: "new")),
                    // );
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.text_format_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Rich Note",
                style: TextStyle(color: Colors.grey[700]),
              )
            ],
          ),
        );
      default:
        return const SizedBox();
    }
  }
}
