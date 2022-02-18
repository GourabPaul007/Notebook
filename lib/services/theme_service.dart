import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeServiceProvider = ChangeNotifierProvider((ref) {
  return ThemeService();
});

class ThemeService extends ChangeNotifier {
  static const themeKey = "theme_key";
  late String theme = "system";

  String getTheme() {
    return theme;
  }

  void setTheme(String value) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(themeKey, value);
    theme = value;
    notifyListeners();
  }

  void loadTheme() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    theme = sharedPreferences.getString(themeKey) ?? "system";
    notifyListeners();
  }
}
