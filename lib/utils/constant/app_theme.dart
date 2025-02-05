import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {

  static Color primaryColor = Color(0xf5f259c);
  static Color secondColor = Color(0xf000000);
  static Color foregroundColor = Color(0xffffff);
  static Color fillColor = Color(0xffffff);

  static TextStyle titleSmall = GoogleFonts.poppins(fontSize: 12);
  static TextStyle titleMedium = GoogleFonts.poppins(fontSize: 16);
  static TextStyle titleLarge = GoogleFonts.poppins(fontSize: 18);

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
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: secondColor)
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: secondColor)
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey)
      ),
      fillColor: fillColor,
      filled: true,

    )
  );
}