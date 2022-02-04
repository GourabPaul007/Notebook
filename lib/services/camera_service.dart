import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

final cameraServiceProvider = ChangeNotifierProvider((ref) => CameraService());

class CameraService extends ChangeNotifier {
  late List<CameraDescription> cameras;
  late CameraDescription camera = cameras[0];
  late CameraController controller;
  late Future<void> initializeControllerFuture;
  late bool flashOn = false;

  void initCameras() {
    try {
      availableCameras().then((availableCameras) {
        cameras = availableCameras;
      });
    } on CameraException catch (e) {
      debugPrint(e.description);
    }
  }

  void changeBackOrFrontCamera() {
    try {
      if (camera == cameras[0]) {
        camera = cameras[1];
      } else {
        camera = cameras[0];
      }
      initCameraController();
    } catch (e) {
      debugPrint(e.toString());
    }
    notifyListeners();
  }

  void initCameraController() async {
    controller = CameraController(
      camera,
      ResolutionPreset.veryHigh,
    );
    initializeControllerFuture = controller.initialize();
  }

  Future<bool> requestPermission() async {
    if (await Permission.storage.isGranted) {
      return true;
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      return await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {
      return false;
    }
    return false;
  }

  Future<String> saveFile(XFile tempImageFile) async {
    // Directory directory;
    try {
      if (Platform.isAndroid) {
        // if (await _requestPermission(Permission.storage)) {
        // final appDir = await getExternalStorageDirectory();
        // final myImagePath = '${appDir!.path}/CameraImages';
        final myImgDir = await Directory("storage/emulated/0/Pictures/Notebook").create();
        final String fileName = tempImageFile.path.split('/').last;
        File localImageFile = await File(tempImageFile.path).copy('${myImgDir.path}/$fileName');

        return localImageFile.path;
      } else {
        return "";
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    debugPrint("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
    return "Permission Denied on SaveFile";
  }

  Future<void> disposeState() async {
    await controller.dispose();
  }
}
