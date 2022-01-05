import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/screens/home_page.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();
  List<CameraDescription> cameras = [];
  // Obtain a list of the available cameras on the device.
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    debugPrint(e.description);
  }

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras[0];

  runApp(MyApp(
      // cameras: cameras,
      ));
}

class MyApp extends StatelessWidget {
  // List<CameraDescription> cameras;
  MyApp({
    Key? key,
    // required this.cameras,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF3777f0),
        primarySwatch: Colors.red,

        buttonTheme: ButtonThemeData(
          buttonColor: Colors.greenAccent[400],
        ),

        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Color(0xFF3777f0),
          shadowColor: (Colors.white),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Color(0xFF3777f0),
            // Status bar brightness (optional)
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
        ),

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.normal),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Fira Code'),
        ),
      ),
      home: const MyHomePage(
          // camera: cameras[0],
          ),
    );
  }
}
