import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
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

  /// changes the camera back to front or vice versa
  /// [cameras[0]] is back camera, [cameras[1]] is front camera.
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
      enableAudio: false,
    );
    initializeControllerFuture = controller.initialize();
  }

  Future<bool> requestStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      return true;
    } else if (await Permission.storage.request().isDenied) {
      return false;
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    }
    return false;
  }

  Future<bool> requestCameraPermission() async {
    if (await Permission.camera.request().isGranted) {
      return true;
    } else if (await Permission.camera.request().isDenied) {
      return false;
    } else if (await Permission.camera.request().isPermanentlyDenied) {
      await openAppSettings();
    }
    return false;
  }

  Future<String?> saveFile(XFile tempImageFile) async {
    final String fileName = basename(tempImageFile.path);
    try {
      if (Platform.isAndroid) {
        // Saving the images in backup directory
        final backupImgDir = await Directory("storage/emulated/0/Pictures/Notebook").create(recursive: true);
        File backupImageFile = await File(tempImageFile.path).copy('${backupImgDir.path}/$fileName');

        // Saving the images in directory for use
        final Directory? externalDirectory = await getExternalStorageDirectory();
        final imageDirectory = await Directory(join(externalDirectory!.path, "images")).create(recursive: true);
        final imageFile = File(join(imageDirectory.path, fileName));
        if (!await imageFile.exists()) {
          imageFile.create(recursive: true);
          await File(tempImageFile.path).copy("${imageDirectory.path}/$fileName");
        }

        return imageFile.path;
      } else {
        // return "";
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return "Permission Denied on SaveFile";
  }

  Future<void> disposeCameraController() async {
    await controller.dispose();
  }
}
