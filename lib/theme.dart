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
    bodyText2: const TextStyle(fontSize: 14.0, fontFamily: 'Fira Code'),
  ),
  iconTheme: IconThemeData(color: Colors.black),
  popupMenuTheme: PopupMenuThemeData(color: Colors.white, elevation: 5),
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
  // primarySwatch: Colors.deepPurple,
  backgroundColor: const Color(0xFFFFFFFF),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.deepPurpleAccent,
    foregroundColor: Colors.white,
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.greenAccent[400],
  ),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: Colors.deepPurpleAccent,
    iconTheme: IconThemeData(color: Colors.white),
    shadowColor: (Colors.white),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.deepPurpleAccent,
      // Status bar brightness (optional)
      statusBarIconBrightness: Brightness.light,
      // statusBarBrightness: Brightness.dark,
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

    // In Page Headers
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
      color: Colors.black,
    ),

    // Description Styles in Topic List Tile
    headline5: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.white60,
    ),

    // Search Text Style
    headline6: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal, color: Colors.black),
    bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Fira Code'),
  ),
  iconTheme: IconThemeData(color: Colors.white),
  popupMenuTheme: PopupMenuThemeData(color: Colors.black, elevation: 5),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      textStyle: MaterialStateProperty.all(
        const TextStyle(fontSize: 18, color: Colors.blue),
      ),
    ),
  ),
  // colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xff40bf7a)),
);
