import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/screens/home_page.dart';
import 'package:frontend/theme.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // List<CameraDescription> cameras;
  const MyApp({
    Key? key,
    // required this.cameras,
  }) : super(key: key);

  final theme = "dar";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // debugShowCheckedModeBanner: false,
      theme: theme == "dark" ? darkTheme : lightTheme,
      home: const MyHomePage(),
    );
  }
}
