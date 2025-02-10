import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:women_health/utils/constant/app_constant.dart';

class AppTheme {

  static Color primaryColor = Color(0xffE05D43);
  static Color secondColor = Color(0xff298E5F);
  static Color secondTransColor = Color(0xffD2EFE2);
  static Color blue50 = Color(0xffEDF4FC);
  static Color black400 = Color(0xff585858);
  static Color blue = Color(0xff64B5F6);
  static Color bluebg = blue.withOpacity(0.2);
  static Color highListColor = Color(0xffD81B60);
  static Color foregroundColor = Colors.white;
  static Color fillColor = Color(0xffffff);
  static TextStyle titleSmall = GoogleFonts.poppins(fontSize: 14,color: primaryColor);
  static TextStyle titleMedium = GoogleFonts.poppins(fontSize: 18,color: primaryColor);
  static TextStyle titleLarge = GoogleFonts.poppins(fontSize: 26,color: primaryColor,fontWeight: FontWeight.w700);

  static double defaultRadius = 20;


  static  var theme = ThemeData(
    textTheme: TextTheme(
      titleSmall: GoogleFonts.poppins(
        fontSize: 12,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 14,
      ),
      titleLarge: GoogleFonts.poppins(
        fontSize: 18,
    ),
  ),
  appBarTheme: AppBarTheme(
    elevation: 1,
    backgroundColor: Colors.white,
    shadowColor: AppTheme.primaryColor.withOpacity(0.3)
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: foregroundColor,
      textStyle: titleMedium.copyWith(fontWeight: FontWeight.w400,fontSize: 18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.defaultRadius)
      ),
      side: BorderSide.none,
      shadowColor: Colors.transparent,
      elevation: 0,
      padding: EdgeInsets.symmetric(vertical: 8)
    )
  ),

    inputDecorationTheme: InputDecorationTheme(
      hintStyle: titleSmall.copyWith(color: Colors.grey),
      focusColor: secondColor,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
        borderSide: BorderSide(color: secondColor)
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
        borderSide: BorderSide(color: secondColor)
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
        borderSide: BorderSide(color: Colors.grey)
      ),
      fillColor: fillColor,
      filled: true,

    )
  );
}