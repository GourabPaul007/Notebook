import 'package:flutter/material.dart';

Color lightenColor(Color color, int valueBy) {
  int r = color.red + valueBy >= 255 ? 255 : color.red + valueBy;
  int g = color.green + valueBy >= 255 ? 255 : color.green + valueBy;
  int b = color.blue + valueBy >= 255 ? 255 : color.blue + valueBy;
  return Color.fromARGB(255, r, g, b);
}

Color darkenColor(Color color, int valueBy) {
  int r = color.red - valueBy <= 0 ? 0 : color.red - valueBy;
  int g = color.green - valueBy <= 0 ? 0 : color.green - valueBy;
  int b = color.blue - valueBy <= 0 ? 0 : color.blue - valueBy;
  return Color.fromARGB(255, r, g, b);
}

// String getLoweredChar(String char) {
// String strColor = color.value.toRadixString(16);
// String newColor = "";
// color.String oldColor = strColor.substring(2);
// for (int i = 0; i < 6; i++) {
//   newColor += getLoweredChar(oldColor[i]);
// }
// return Color(int.parse("0xFF" + newColor));
//   switch (char.toUpperCase()) {
//     case 'F':
//       return "D";
//     case 'E':
//       return "C";
//     case 'D':
//       return "B";
//     case 'C':
//       return "A";
//     case 'B':
//       return "9";
//     case 'A':
//       return "8";
//     case '9':
//       return "7";
//     case '8':
//       return "6";
//     case '7':
//       return "5";
//     case '6':
//       return "4";
//     case '5':
//       return "3";
//     case '4':
//       return "2";
//     case '3':
//       return "1";
//     case '2':
//       return "0";
//     case '1':
//       return "0";
//     case '0':
//       return "0";
//     default:
//       return "0";
//   }
// }
