import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/subject_model.dart';
import 'package:frontend/screens/subject_list_page/single_subject_tile.dart';
import 'package:frontend/services/camera_service.dart';
import 'package:frontend/services/message_service.dart';
import 'package:frontend/services/subject_service.dart';

class TakePictureScreen extends ConsumerStatefulWidget {
  final String from;
  const TakePictureScreen({Key? key, required this.from}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends ConsumerState<TakePictureScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(cameraServiceProvider).initCameraController();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    // ref.read(cameraServiceProvider).disposeState();
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: Text(
          "Take Image Note",
          style: Theme.of(context).textTheme.headline1,
        ),
        systemOverlayStyle: Theme.of(context).appBarTheme.systemOverlayStyle,
      ),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: ref.read(cameraServiceProvider).initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.

            return Container(
              color: Theme.of(context).backgroundColor,
              child: Column(
                children: [
                  Expanded(
                      flex: 6,
                      child: AspectRatio(
                        aspectRatio: ref.watch(cameraServiceProvider).controller.value.aspectRatio,
                        child: CameraPreview(ref.watch(cameraServiceProvider).controller),
                      )),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Row(
                        children: [
                          Expanded(
                            child: Material(
                              color: Colors.transparent,
                              shape: const CircleBorder(),
                              clipBehavior: Clip.hardEdge,
                              child: IconButton(
                                icon: Icon(
                                  ref.watch(cameraServiceProvider).flashOn
                                      ? Icons.flash_on_rounded
                                      : Icons.flash_off_rounded,
                                  size: 24,
                                ),
                                iconSize: 36,
                                onPressed: () async {
                                  try {
                                    // Ensure that the camera is initialized.
                                    await ref.read(cameraServiceProvider).initializeControllerFuture;

                                    setState(() {
                                      ref.watch(cameraServiceProvider).flashOn =
                                          !ref.watch(cameraServiceProvider).flashOn;
                                    });
                                    ref.watch(cameraServiceProvider).flashOn
                                        ? ref.watch(cameraServiceProvider).controller.setFlashMode(FlashMode.torch)
                                        : ref.watch(cameraServiceProvider).controller.setFlashMode(FlashMode.off);
                                  } catch (e) {
                                    debugPrint(e.toString());
                                  }
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Material(
                              color: Colors.transparent,
                              shape: const CircleBorder(),
                              clipBehavior: Clip.hardEdge,
                              child: IconButton(
                                iconSize: 48,
                                onPressed: () async {
                                  try {
                                    // Ensure that the camera is initialized.
                                    await ref.read(cameraServiceProvider).initializeControllerFuture;
                                    final tempImageFile =
                                        await ref.watch(cameraServiceProvider).controller.takePicture();

                                    if (!await ref.read(cameraServiceProvider).requestStoragePermission() &&
                                        !await ref.read(cameraServiceProvider).requestCameraPermission()) {
                                      return Navigator.pop(context);
                                    }
                                    String? localImageFilePath =
                                        await ref.read(cameraServiceProvider).saveFile(tempImageFile);

                                    // turn off flash after clicking the photo
                                    ref.watch(cameraServiceProvider).controller.setFlashMode(FlashMode.off);
                                    ref.watch(cameraServiceProvider).flashOn = false;

                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => DisplayPictureScreen(
                                          imagePath: localImageFilePath!,
                                          from: widget.from,
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    debugPrint(e.toString());
                                  }
                                },
                                icon: const Icon(
                                  Icons.camera_alt_rounded,
                                  size: 36,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Material(
                              color: Colors.transparent,
                              shape: const CircleBorder(),
                              clipBehavior: Clip.hardEdge,
                              child: IconButton(
                                iconSize: 36,
                                onPressed: () async {
                                  ref.read(cameraServiceProvider).changeBackOrFrontCamera();
                                },
                                icon: const Icon(
                                  Icons.camera_front_rounded,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

// ====================================================================================================================
// ====================================================================================================================
// ====================================================================================================================
// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final String from;
  // final Future Function(String) imgFromCamera;

  const DisplayPictureScreen({
    Key? key,
    required this.imagePath,
    required this.from,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        systemOverlayStyle: Theme.of(context).appBarTheme.systemOverlayStyle,
      ),

      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: Column(
          children: [
            Expanded(
              flex: 9,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: Image.file(
                  File(imagePath),
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.only(left: 48, right: 48),
                  child: Row(
                    children: [
                      Expanded(
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.refresh,
                            size: 36,
                          ),
                        ),
                      ),
                      from == "SubjectListPage"
                          ?

                          /// If the image taken from home page then show the modal
                          Expanded(
                              child: Consumer(builder: (context, ref, child) {
                                return IconButton(
                                  onPressed: () async {
                                    showModalBottomSheet(
                                        context: context,
                                        barrierColor: Colors.transparent,
                                        backgroundColor: Colors.transparent,
                                        isScrollControlled: true,
                                        builder: (context) {
                                          final subjects = ref.watch(subjectServiceProvider).subjects;
                                          return BottomSheetSubjectList(subjects: subjects, imagePath: imagePath);
                                        });
                                  },
                                  icon: const Icon(
                                    Icons.send_rounded,
                                    size: 36,
                                  ),
                                );
                              }),
                            )
                          :

                          /// If the Image was taken inside a subject then add it to the messages
                          Expanded(
                              child: Consumer(builder: (context, ref, child) {
                                final subject = ref.watch(subjectServiceProvider).subject;

                                return IconButton(
                                  onPressed: () async {
                                    await ref
                                        .read(messageServiceProvider)
                                        .imgFromCamera(imagePath, subject.name, subject.rowId!);
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                  icon: const Icon(
                                    Icons.check,
                                    size: 36,
                                  ),
                                );
                              }),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ====================================================================================================================
// ====================================================================================================================
// ====================================================================================================================
// Bottom Sheet That Shows where user wants to send the image
class BottomSheetSubjectList extends ConsumerWidget {
  final List<Subject> subjects;
  final String imagePath;
  const BottomSheetSubjectList({Key? key, required this.subjects, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.25,
      maxChildSize: 1.0,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(18),
            ),
          ),
          child: ListView(
            controller: scrollController,
            children: <Widget>[
              Container(
                width: 8.0,
                height: 5.0,
                margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 2.4, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey,
                ),
              ),
              ListView.builder(
                // to scroll the list inside the parent listview
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: subjects.length,
                itemBuilder: (BuildContext context, int index) {
                  // Each Subject Tile
                  return Container(
                    margin: const EdgeInsets.only(left: 8, right: 8, top: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Material(
                      color: ref.read(subjectServiceProvider).selectedSubjects.contains(subjects[index])
                          ? Theme.of(context).splashColor
                          : Colors.transparent,
                      child: InkWell(
                        splashColor: Theme.of(context).splashColor,
                        // onLongPress: () {
                        //   ref.read(subjectServiceProvider).subjectOnLongPress(subjects[index]);
                        // },
                        onTap: () async {
                          await ref
                              .read(messageServiceProvider)
                              .imgFromCamera(imagePath, subjects[index].name, subjects[index].rowId!);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: SingleSubjectTile(
                          subject: subjects[index],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
