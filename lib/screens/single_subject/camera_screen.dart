import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/services/camera_service.dart';
import 'package:frontend/services/message_service.dart';
import 'package:frontend/services/subject_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class TakePictureScreen extends ConsumerStatefulWidget {
  // final CameraDescription cameraOld;
  // final CameraDescription cameraNew;
  // final Future Function(String) imgFromCamera;

  const TakePictureScreen({
    Key? key,
    // required this.cameraOld,
    // required this.cameraNew,
    // required this.imgFromCamera,
  }) : super(key: key);

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
        title: const Text('Take a picture'),
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
              color: Colors.black,
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
                    child: Container(
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
                                    color: Colors.white,
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

// TODO: SEPERATE METHOD FOR CREATION OF FOLDER AND STUFF
                                      // late String localImageFilePath;
                                      // if (Platform.isAndroid) {
                                      //   final appDir = await getExternalStorageDirectory();
                                      //   final myImagePath = '${appDir!.path}/CameraImages';
                                      //   final myImgDir =
                                      //       await Directory("storage/emulated/0/Pictures/Notebook").create();
                                      //   debugPrint("*******************************" + appDir.path);
                                      //   final String fileName = tempImageFile.path.split('/').last;
                                      //   localImageFile =
                                      //       await File(tempImageFile.path).copy('${myImgDir.path}/$fileName');
                                      // }
                                      if (!await ref.read(cameraServiceProvider).requestPermission()) {
                                        return Navigator.pop(context);
                                      }
                                      String localImageFilePath =
                                          await ref.read(cameraServiceProvider).saveFile(tempImageFile);

                                      // turn off flash after clicking the photo
                                      ref.watch(cameraServiceProvider).controller.setFlashMode(FlashMode.off);
                                      ref.watch(cameraServiceProvider).flashOn = false;

                                      await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => DisplayPictureScreen(
                                            // imagePath: tempImageFile.path,
                                            imagePath: localImageFilePath,
                                            // imgFromCamera: widget.imgFromCamera,
                                          ),
                                        ),
                                      );
                                    } catch (e) {
                                      debugPrint(e.toString());
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.camera_alt_rounded,
                                    color: Colors.white,
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
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  // final Future Function(String) imgFromCamera;

  const DisplayPictureScreen({
    Key? key,
    required this.imagePath,
    // required this.imgFromCamera,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: Image.file(
                File(imagePath),
                width: double.infinity,
                fit: BoxFit.fitWidth,
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
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Consumer(builder: (context, ref, child) {
                          final singleSubjectRef = ref.watch(subjectServiceProvider);

                          return IconButton(
                            onPressed: () async {
                              await ref.read(messageServiceProvider).imgFromCamera(
                                  imagePath, singleSubjectRef.subjectName, singleSubjectRef.subjectRowId);
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.check,
                              color: Colors.white,
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
