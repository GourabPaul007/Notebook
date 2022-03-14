import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/screens/camera_screen.dart';
import 'package:frontend/screens/single_subject_page/edit_message_dialog.dart';
import 'package:frontend/services/message_service.dart';

class SingleSubjectBottomSheet extends StatelessWidget {
  final int subjectRowId;
  final String subjectName;

  const SingleSubjectBottomSheet({Key? key, required this.subjectName, required this.subjectRowId}) : super(key: key);

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
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(12),
            boxShadow: kElevationToShadow[1],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BottomSheetAction(
                    actionType: "document",
                    subjectRowId: subjectRowId,
                    subjectName: subjectName,
                  ),
                  BottomSheetAction(
                    actionType: "camera",
                    subjectRowId: subjectRowId,
                    subjectName: subjectName,
                  ),
                  BottomSheetAction(
                    actionType: "gallery",
                    subjectRowId: subjectRowId,
                    subjectName: subjectName,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BottomSheetAction(
                    actionType: "richNote",
                    subjectRowId: subjectRowId,
                    subjectName: subjectName,
                  ),
                  BottomSheetAction(subjectName: subjectName, subjectRowId: subjectRowId),
                  BottomSheetAction(subjectName: subjectName, subjectRowId: subjectRowId),
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
  final String subjectName;

  const BottomSheetAction({
    Key? key,
    this.actionType,
    required this.subjectName,
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
                radius: 28,
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
                radius: 28,
                child: Consumer(
                  builder: (BuildContext context, WidgetRef ref, Widget? child) {
                    return IconButton(
                      onPressed: () async {
                        await ref.read(messageServiceProvider).pickDocuments(subjectName, subjectRowId);
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.insert_drive_file_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Document",
                style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
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
                  radius: 28,
                  child: Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
                    return IconButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TakePictureScreen(from: "SingleSubjectPage"),
                          ),
                        );
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    );
                  })),
              const SizedBox(height: 8),
              Text(
                "Camera",
                style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
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
                radius: 28,
                child: Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  return IconButton(
                    onPressed: () async {
                      await ref.read(messageServiceProvider).imgFromGallery(subjectName, subjectRowId);
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.image_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),
              Text(
                "Gallery",
                style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
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
                radius: 28,
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
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Rich Note",
                style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
              )
            ],
          ),
        );
      default:
        return const SizedBox();
    }
  }
}
