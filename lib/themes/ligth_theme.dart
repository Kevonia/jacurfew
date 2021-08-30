import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
        primaryColor: CustomColors.primaryColor,
        accentColor: CustomColors.textColor,
        scaffoldBackgroundColor: Colors.white,
        iconTheme: IconThemeData(size: 12.0, color: Colors.blueAccent),
        textTheme: TextTheme(
          headline1: GoogleFonts.roboto(
              textStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 25,
                  color: CustomColors.textColor)),
          headline2: GoogleFonts.roboto(
              textStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 50,
                  color: CustomColors.textColor)),
          subtitle1: GoogleFonts.roboto(
              textStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: CustomColors.textColor)),
          bodyText1: GoogleFonts.roboto(
              textStyle: TextStyle(fontSize: 14, color: CustomColors.textColor),
              fontWeight: FontWeight.w700),
          bodyText2: GoogleFonts.roboto(
              textStyle: TextStyle(fontSize: 18, color: Colors.black)),
        ));
  }
}
