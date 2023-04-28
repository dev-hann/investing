import 'package:flutter/material.dart';

class IVColor {
  // blueGrey[800]
  static const Color blueGrey = Color(0xFF37474F);
  // orangeAccent[200];
  static const Color orange = Color(0xFFFFAB40);
  static const Color blue = Colors.blueAccent;
  static const Color grey = Colors.grey;

  static const Color darkWhite = Colors.white54;
  static const Color white = Colors.white;

  static const Color darkRed = Color(0xFF81484F);
  static const Color red = Color(0xFFB14949);
  static const Color lightRed = Color(0xFFFF5252);

  static const Color darkGreen = Color(0xFF467451);
  static const Color green = Color(0xFF529C57);
  static const Color lightGreen = Color(0xFF65C967);

  static Color stockColor(double netChange) {
    if (netChange > 0.0) {
      return IVColor.lightRed;
    }
    if (netChange < 0.0) {
      return IVColor.blue;
    }
    return IVColor.grey;
  }
}
