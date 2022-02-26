import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/services/theme_service.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  String setThemeNameInListTileSubtitle(String theme) {
    switch (theme) {
      case "light":
        return "Light";
      case "dark":
        return "Dark";
      case "system":
        return "System Default";
      default:
        return "System Default";
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeServiceProvider).theme;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(
          "Settings",
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(
              "Appearance",
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          ListTile(
            title: Text(
              "Theme",
              style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 18),
            ),
            subtitle: Text(
              setThemeNameInListTileSubtitle(theme),
              style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 16),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    backgroundColor: Theme.of(context).backgroundColor,
                    elevation: 5,
                    child: const ThemeDialog(),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

// =============================================================================================================================
// =============================================================================================================================
// =============================================================================================================================
// ThemeDialog Class
class ThemeDialog extends ConsumerStatefulWidget {
  const ThemeDialog({Key? key}) : super(key: key);

  @override
  _ThemeDialogState createState() => _ThemeDialogState();
}

enum ThemeValue { light, dark, system }

class _ThemeDialogState extends ConsumerState<ThemeDialog> {
  ThemeValue? _character = ThemeValue.light;

  @override
  void initState() {
    super.initState();

    switch (ref.read(themeServiceProvider).getTheme()) {
      case "light":
        _character = ThemeValue.light;
        break;
      case "dark":
        _character = ThemeValue.dark;
        break;
      case "system":
        _character = ThemeValue.system;
        break;
      default:
        _character = ThemeValue.system;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(unselectedWidgetColor: Colors.grey),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8.0),
          RadioListTile<ThemeValue>(
            title: Text("System Default", style: Theme.of(context).textTheme.headline4),
            value: ThemeValue.system,
            groupValue: _character,
            onChanged: (ThemeValue? value) {
              setState(() {
                _character = value;
              });
              ref.read(themeServiceProvider).setTheme("system");
              // widget.overrideThemeNameToSystemDefault(true);
              Navigator.pop(context);
            },
          ),
          RadioListTile<ThemeValue>(
            title: Text('Light', style: Theme.of(context).textTheme.headline4),
            value: ThemeValue.light,
            groupValue: _character,
            onChanged: (ThemeValue? value) {
              setState(() {
                _character = value;
              });
              ref.read(themeServiceProvider).setTheme("light");
              // widget.overrideThemeNameToSystemDefault(false);

              Navigator.pop(context);
            },
          ),
          RadioListTile<ThemeValue>(
            title: Text("Dark", style: Theme.of(context).textTheme.headline4),
            value: ThemeValue.dark,
            groupValue: _character,
            onChanged: (ThemeValue? value) {
              setState(() {
                _character = value;
              });
              ref.read(themeServiceProvider).setTheme("dark");
              // widget.overrideThemeNameToSystemDefault(false);

              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 8.0),
        ],
      ),
    );
  }
}
