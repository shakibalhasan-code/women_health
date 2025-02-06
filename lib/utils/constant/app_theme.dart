import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:women_health/utils/constant/app_constant.dart';

class AppTheme {

  static Color primaryColor = Colors.black;
  static Color secondColor = Color(0xf000000);
  static Color foregroundColor = Colors.white;
  static Color fillColor = Color(0xffffff);

  static TextStyle titleSmall = GoogleFonts.poppins(fontSize: 12,color: Colors.white);
  static TextStyle titleMedium = GoogleFonts.poppins(fontSize: 16,color: Colors.white);
  static TextStyle titleLarge = GoogleFonts.poppins(fontSize: 18,color: Colors.white);

  static  var theme = ThemeData(
    textTheme: TextTheme(
      titleSmall: GoogleFonts.poppins(
        fontSize: 12,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 16,
      ),
      titleLarge: GoogleFonts.poppins(
        fontSize: 18,
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: foregroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      side: BorderSide.none,
    )
  ),

    inputDecorationTheme: InputDecorationTheme(
      hintStyle: titleSmall.copyWith(color: Colors.grey),
      focusColor: secondColor,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstant.defaultRadius),
        borderSide: BorderSide(color: secondColor)
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstant.defaultRadius),
        borderSide: BorderSide(color: secondColor)
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstant.defaultRadius),
        borderSide: BorderSide(color: Colors.grey)
      ),
      fillColor: fillColor,
      filled: true,

    )
  );
}