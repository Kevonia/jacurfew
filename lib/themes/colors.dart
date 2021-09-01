import 'package:flutter/material.dart';

extension ColorExtension on String {
  toColor() {
    var hexColor = this.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}

class CustomColors {
  static final Color primaryColor = Colors.grey.shade600;
  static final Color secondaryColor = Colors.grey.shade400;
  static final Color curfew_strokeColor = Colors.redAccent;
  static final Color curfew_progessbarColor = Colors.grey.shade400;
  static final Color strokeColor = '#36B649'.toColor();
  static final Color progessbarColor = '#FFF200'.toColor();
  static final Color textColor = Colors.grey.shade400;
}
