import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class TakePictureScreen extends StatefulWidget {
  // final CameraDescription cameraOld;
  final CameraDescription cameraNew;
  final Future Function(String) imgFromCamera;

  const TakePictureScreen({
    Key? key,
    // required this.cameraOld,
    required this.cameraNew,
    required this.imgFromCamera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  late bool flashOn = false;

// For requesting Device Storage Permission
  Future<bool> _requestPermission() async {
    if (await Permission.storage.isGranted) {
      return true;
    }
    // else {
    //   var request = await permission.request();
    //   if (request == PermissionStatus.granted) {
    //     return true;
    //   } else {
    //     return false;
    //   }
    // }
    else if (await Permission.storage.request().isPermanentlyDenied) {
      return await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {
      return false;
    }
    return false;
  }

  Future<String> saveFile(XFile tempImageFile) async {
    Directory directory;
    try {
      if (Platform.isAndroid) {
        // if (await _requestPermission(Permission.storage)) {
        final appDir = await getExternalStorageDirectory();
        final myImagePath = '${appDir!.path}/CameraImages';
        final myImgDir = await Directory("storage/emulated/0/Pictures/Notebook").create();
        debugPrint("*******************************" + appDir.path);
        final String fileName = tempImageFile.path.split('/').last;
        File localImageFile = await File(tempImageFile.path).copy('${myImgDir.path}/$fileName');

        return localImageFile.path;
        // } else {
        //   return "Permission Denied";
        // }
      } else {
        return "";
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    debugPrint("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
    return "Permission Denied";
  }

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      widget.cameraNew,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
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
        future: _initializeControllerFuture,
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
                        aspectRatio: _controller.value.aspectRatio,
                        child: CameraPreview(_controller),
                      )),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Center(
                        child: Row(
                          children: [
                            Expanded(
                              child: Material(
                                color: Colors.blue,
                                shape: const CircleBorder(),
                                clipBehavior: Clip.hardEdge,
                                child: IconButton(
                                  icon: Icon(
                                    flashOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  iconSize: 36,
                                  onPressed: () async {
                                    try {
                                      // Ensure that the camera is initialized.
                                      await _initializeControllerFuture;

                                      setState(() {
                                        flashOn = !flashOn;
                                      });
                                      flashOn
                                          ? _controller.setFlashMode(FlashMode.torch)
                                          : _controller.setFlashMode(FlashMode.off);
                                    } catch (e) {
                                      debugPrint(e.toString());
                                    }
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Material(
                                color: Colors.blue,
                                shape: const CircleBorder(),
                                clipBehavior: Clip.hardEdge,
                                child: IconButton(
                                  iconSize: 48,
                                  onPressed: () async {
                                    try {
                                      // Ensure that the camera is initialized.
                                      await _initializeControllerFuture;
                                      final tempImageFile = await _controller.takePicture();

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
                                      if (!await _requestPermission()) {
                                        return Navigator.pop(context);
                                      }
                                      String localImageFilePath = await saveFile(tempImageFile);
                                      // while (localImageFilePath == "Permission Denied") {
                                      //   // return Navigator.pop(context);
                                      //   await _requestPermission();
                                      // }

                                      // turn off flash after clicking the photo
                                      _controller.setFlashMode(FlashMode.off);
                                      setState(() {
                                        flashOn = false;
                                      });

                                      await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => DisplayPictureScreen(
                                            // imagePath: tempImageFile.path,
                                            imagePath: localImageFilePath,
                                            imgFromCamera: widget.imgFromCamera,
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
                                color: Colors.blue,
                                shape: const CircleBorder(),
                                clipBehavior: Clip.hardEdge,
                                child: IconButton(
                                  iconSize: 36,
                                  onPressed: () async {
                                    try {
                                      // Ensure that the camera is initialized.
                                      await _initializeControllerFuture;
                                      final image = await _controller.takePicture();
                                      await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => DisplayPictureScreen(
                                            imagePath: image.path,
                                            imgFromCamera: widget.imgFromCamera,
                                          ),
                                        ),
                                      );
                                    } catch (e) {
                                      debugPrint(e.toString());
                                    }
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

      // floatingActionButton: Container(
      //   padding: const EdgeInsets.only(bottom: 100.0),
      //   child: Align(
      //     alignment: Alignment.bottomCenter,
      //     child: FloatingActionButton(
      //       onPressed: () async {
      //         // Take the Picture in a try / catch block. If anything goes wrong,
      //         // catch the error.
      //         try {
      //           // Ensure that the camera is initialized.
      //           await _initializeControllerFuture;
      //           // Attempt to take a picture and get the file `image`
      //           // where it was saved.
      //           final image = await _controller.takePicture();
      //           // If the picture was taken, display it on a new screen.
      //           await Navigator.of(context).push(
      //             MaterialPageRoute(
      //               builder: (context) => DisplayPictureScreen(
      //                 // Pass the automatically generated path to the DisplayPictureScreen widget.
      //                 imagePath: image.path, imgFromCamera: widget.imgFromCamera,
      //               ),
      //             ),
      //           );
      //         } catch (e) {
      //           // If an error occurs, log the error to the console.
      //           print(e);
      //         }
      //       },
      //       child: const Icon(Icons.camera_alt),
      //     ),
      //   ),
      // ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final Future Function(String) imgFromCamera;

  const DisplayPictureScreen({Key? key, required this.imagePath, required this.imgFromCamera}) : super(key: key);

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
            Image.file(
              File(imagePath),
            ),
            Expanded(
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
                        child: IconButton(
                          onPressed: () async {
                            await imgFromCamera(imagePath);
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 36,
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
      ),
    );
  }
}
