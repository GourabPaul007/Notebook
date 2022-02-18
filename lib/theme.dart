import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// =============================================================================================
// =============================================================================================
// =============================================================================================
// Light Theme
ThemeData lightTheme = ThemeData.dark().copyWith(
  primaryColor: Colors.deepPurpleAccent,
  // primarySwatch: Colors.deepPurple,
  backgroundColor: const Color(0xFFFFFFFF),
  colorScheme: const ColorScheme(
    primary: Colors.deepPurpleAccent,
    primaryVariant: Colors.deepPurple,
    secondary: Colors.deepOrangeAccent,
    secondaryVariant: Colors.deepOrange,
    surface: Color(0xFFcfcfcf),
    background: Color(0xFF121212),
    error: Colors.red,
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onSurface: Colors.black,
    onBackground: Colors.black,
    onError: Colors.white,
    brightness: Brightness.dark,
  ),
  splashColor: Colors.indigo[100],
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.deepPurpleAccent,
    foregroundColor: Colors.white,
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.greenAccent[400],
  ),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.black),
    shadowColor: (Colors.white),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      // Status bar brightness (optional)
      statusBarIconBrightness: Brightness.dark,
      // statusBarBrightness: Brightness.dark,
    ),
  ),

  // Define the default `TextTheme`. Use this to specify the default
  // text styling for headlines, titles, bodies of text, and more.
  textTheme: TextTheme(
    // Top Header of app [WhatsNote]
    headline1: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),

    // In Page Headers
    headline2: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),

    // TabBar Headers
    headline3: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),

    // Topic names in Topic List Page
    headline4: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),

    // Description Styles in Topic List Tile
    headline5: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.grey[800],
    ),

    // Search Text Style
    headline6: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal, color: Colors.black),

    bodyText1: const TextStyle(fontSize: 18, color: Colors.black54),
    bodyText2: const TextStyle(fontSize: 18.0, color: Colors.black, fontFamily: 'Fira Code'),
  ),
  iconTheme: const IconThemeData(color: Colors.black87),
  popupMenuTheme: const PopupMenuThemeData(color: Colors.white, elevation: 5),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      textStyle: MaterialStateProperty.all(
        const TextStyle(fontSize: 18, color: Colors.blue),
      ),
    ),
  ),
);

// =============================================================================================
// =============================================================================================
// =============================================================================================
// Dark Theme

ThemeData darkTheme = ThemeData.dark().copyWith(
  primaryColor: Colors.deepPurpleAccent,
  scaffoldBackgroundColor: const Color(0xFF121212),
  colorScheme: const ColorScheme(
    primary: Colors.deepPurpleAccent,
    primaryVariant: Colors.deepPurple,
    secondary: Colors.deepOrangeAccent,
    secondaryVariant: Colors.deepOrange,
    surface: Color(0xFF222222),
    background: Color(0xFF121212),
    error: Colors.red,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    onBackground: Colors.white,
    onError: Colors.white,
    brightness: Brightness.dark,
  ),
  // primarySwatch: Colors.deepPurple,
  backgroundColor: const Color(0xFF121212),
  splashColor: Colors.indigoAccent[100],
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.deepPurpleAccent,
    foregroundColor: Colors.white,
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.greenAccent[400],
  ),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: Color(0xFF121212),
    iconTheme: IconThemeData(color: Colors.white70),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Color(0xFF121212),
      // Status bar brightness (optional)
      statusBarIconBrightness: Brightness.light,
      // statusBarBrightness: Brightness.dark,
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
    hintStyle: TextStyle(color: Colors.grey[700]),
    fillColor: Colors.grey[200],
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
  ),

  // Define the default `TextTheme`. Use this to specify the default
  // text styling for headlines, titles, bodies of text, and more.
  textTheme: const TextTheme(
    // Top Header of app [WhatsNote]
    headline1: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),

    // In Page Headers, Search Text Style
    headline2: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),

    // TabBar Headers
    headline3: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),

    // Topic names in Topic List Page
    headline4: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),

    // Description Styles in Topic List Tile
    headline5: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.white60,
    ),

    // Starred Message Headers Style
    headline6: TextStyle(fontSize: 16.0, color: Colors.white70),

    bodyText1: TextStyle(fontSize: 18.0, color: Colors.white54),
    bodyText2: TextStyle(fontSize: 18.0, color: Colors.white, fontFamily: 'Fira Code'),
  ),
  iconTheme: const IconThemeData(color: Colors.white70),
  popupMenuTheme: const PopupMenuThemeData(color: Colors.black, elevation: 5),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      textStyle: MaterialStateProperty.all(
        const TextStyle(fontSize: 18, color: Colors.blue),
      ),
    ),
  ),
  // colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xff40bf7a)),
);
