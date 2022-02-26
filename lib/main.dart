import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/screens/home_page.dart';
import 'package:frontend/services/theme_service.dart';
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

class MyApp extends ConsumerStatefulWidget {
  // List<CameraDescription> cameras;
  const MyApp({
    Key? key,
    // required this.cameras,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    ref.read(themeServiceProvider).loadTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // debugShowCheckedModeBanner: false,
      theme: chooseTheme(ref.watch(themeServiceProvider).theme),
      home: const MyHomePage(),
    );
  }
}

ThemeData? chooseTheme(String theme) {
  switch (theme) {
    case "dark":
      return darkTheme;
    case "light":
      return lightTheme;
    case "system":
      Brightness brightness = SchedulerBinding.instance!.window.platformBrightness;
      if (brightness == Brightness.dark) {
        return darkTheme;
      } else {
        return lightTheme;
      }
    // default:
    //   return lightTheme;
  }
}
